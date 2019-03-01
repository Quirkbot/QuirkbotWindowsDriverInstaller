# Quirkbot Windows Drivers Installer

## Build instructions (Windows)

- Downdload and install [NSIS](http://nsis.sourceforge.net/Download) (verison `3.0b3`).
- Install [NSIS UAC Plugin](https://nsis.sourceforge.io/UAC_plug-in):
    - [Download zip with source files](https://nsis.sourceforge.io/mediawiki/images/8/8f/UAC.zip)
    - Extract `UAC.zip\Plugins\x86-ansi\UAC.dll` to `C:\Program Files\NSIS\Plugins\x86-ansi\UAC.dll`
    - Extract `UAC.zip\Plugins\x86-unicode\UAC.dll` to `C:\Program Files\NSIS\Plugins\x86-unicode\UAC.dll`
    - Extract `UAC.zip\UAC.nsh` to `C:\Program Files\NSIS\Includes\UAC.sh`
- Right click `build.nsi` and select `Compile Script`.
- Wait for `Quirkbot-Windows-Drivers-Installer.exe` to be generated.

## Code signing

We use `SignTool` to sign both the driver's catalog file (`cat`) and installer. It says on the [documentation](https://docs.microsoft.com/en-us/dotnet/framework/tools/signtool-exe) that it comes with the Windows SDK but it seems to be a little bit tricker to do it on a fresh [Windows 7 VirtualBox image provided by Microsoft](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/):

- [Install .NET Framework 4](https://www.microsoft.com/en-us/download/details.aspx?id=17851) (It has to be 4, 4.7 won't work)
- [Install Windows SDK](https://www.microsoft.com/en-us/download/details.aspx?id=8279)
- Add Windows SDK Tools binary folder to system `PATH`

Once `signtool` is available from the `CMD` or `PowerShell`:

- [Install and activate SafeNet driver and client](https://knowledge.digicert.com/solution/SO27164.html#attach)
- Connect USB token
- Run `signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a "PATH TO FILE"`

To sign the driver, point to the catalog file inside the `drivers` folder. It should look something like this:

`signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a ".\drivers\quirkbot.cat"`

***You must sign the driver before building the NSIS installer***.

Then build the NSIS installer and run the same command but pointing to the `exe` file:

`signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a ".\Quirkbot-Windows-Driver-Installer.exe"`
