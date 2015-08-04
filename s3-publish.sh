rm -r s3_publish
mkdir s3_publish

cp Quirkbot-Windows-Drivers-Installer.exe s3_publish/quirkbot-drivers.exe

aws s3 sync s3_publish s3://code.quirkbot.com/drivers --delete --exclude *.DS_Store
