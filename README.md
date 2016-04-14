# Quirkbot Windows Drivers Installer

## Build instructions (Windows)

- Downdload and install [NSIS](http://nsis.sourceforge.net/Download) (verison ```3.0b3```).
- Right click ```build.nsi``` and select ```Compile Script``.
- Wait for ```Quirkbot-Windows-Drivers-Installer.exe``` to be generated.


## Building releases

You should build and test the release before deploying them:

- Install node dependencies:
```
npm install
```
- Update the version in `package.json`
- Run:
```
npm run gulp -- build
```

## Deploying Releases
To deploy to Amazon S3, please create the corresponding configuration
files in `/aws-config/[environment].json`.
For security, those files should not be included on the repository.

Examples:

#### `/aws-config/stage.json`

```
{
  "key": "YOUR_S3_KEY",
  "secret": "YOUR_S3_SECRET",
  "bucket": "code-stage.quirkbot.com",
  "region": "us-east-1"
}

```
#### `/aws-config/production.json`

```
{
  "key": "YOUR_S3_KEY",
  "secret": "YOUR_S3_SECRET",
  "bucket": "code.quirkbot.com",
  "region": "us-east-1"
}

```

Before deploying, please run the "Building Releases" instructions and make sure
everything works as desired. When you are ready to deploy:

- Update the version in `package.json`
- Run:
```
npm run gulp -- deploy --environment=stage
```
or
```
npm run gulp -- deploy --environment=production
```