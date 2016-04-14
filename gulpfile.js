'use strict';

var path = require('path');
var fs = require('fs');
var gulp = require('gulp');
var argv = require('yargs').default('environment', 'stage').argv;
var $ = require('gulp-load-plugins')();
var merge = require('merge-stream');
var runSequence = require('run-sequence');

var SRC_NAME = 'Quirkbot-Windows-Drivers-Installer.exe';
var RELEASE_NAME = 'quirkbot-windows-drivers';
var PACKAGE = JSON.parse(fs.readFileSync('package.json'));
var VERSION_FILENAME = `${RELEASE_NAME}-${PACKAGE.version}.exe`;
var LATEST_FILENAME = `${RELEASE_NAME}-latest.exe`;


/**
 * Cleans all the generated files
 */
gulp.task('clean', function () {
	return gulp.src([
		LATEST_FILENAME,
		RELEASE_NAME + '-*.exe'
	])
	.pipe($.clean());
});


/**
 * Generate the files that will be published
 */
gulp.task('build', function (cb) {

	var exec = require('child_process').exec;

	exec(
		`cp ${SRC_NAME} ${LATEST_FILENAME} `+
		`&& cp ${SRC_NAME} ${VERSION_FILENAME}`,
		(error, stdout, stderr) => {
			console.log(stderr)
			cb();
		}
	);

});

/**
 * Builds and publish to s3
 */
gulp.task('s3', ['build'], function () {
	var aws = JSON.parse(fs.readFileSync(path.join('aws-config', `${argv.environment}.json`)));

	return gulp.src([
		LATEST_FILENAME,
		VERSION_FILENAME
	])
	.pipe($.s3(aws, {
		uploadPath: 'downloads/'
	}));
});


/**
 * Deploys the release. Asks for confirmation if deploying to production
 */
gulp.task('confirm-deploy', [], function () {
	if(argv.environment == 'production'){
		return gulp.src('')
		.pipe($.prompt.confirm('You are about to deploy TO PRODUCTION! Are you sure you want to continue)'))
		.pipe($.prompt.confirm('Really sure?!'))
	}

});
gulp.task('deploy', function (cb) {
	runSequence(
		'confirm-deploy',
		's3',
	cb);
});


