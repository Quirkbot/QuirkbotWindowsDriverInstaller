;--------------------------------
;Include Modern UI
    !include "MUI2.nsh"
    !include WinMessages.nsh
    !include LogicLib.nsh
;--------------------------------
;General
    Name "Quirkbot drivers installation"
    OutFile "Quirkbot-Windows-Drivers-Installer.exe"
    InstallDir "$TEMP\quirkbot"

    Caption "Quirkbot drivers installation"
    VIProductVersion "1.0.0.0"
    VIAddVersionKey ProductVersion "1.0.0.0"
    VIAddVersionKey FileVersion "1.0"
    VIAddVersionKey FileDescription "Quirkbot"
    VIAddVersionKey ProductName "Quirkbot"
    VIAddVersionKey InternalName "Quirkbot"
    VIAddVersionKey LegalCopyright "Quirkbot"
    VIAddVersionKey CompanyName Quirkbot
    VIAddVersionKey OriginalFilename "Quirkbot-Windows-Drivers-Installer.exe"
;--------------------------------
;Interface Settings
    !define MUI_ABORTWARNING
    !define MUI_ICON "quirkbot.ico"
;--------------------------------
;Pages
    !insertmacro MUI_PAGE_INSTFILES
;--------------------------------
;Languages
    !insertmacro MUI_LANGUAGE "English"
;--------------------------------
;Windows detection
    !include x64.nsh
    !include WinVer.nsh

;--------------------------------
Section "Install a Driver" InstDriver

    SetOutPath $TEMP
    File /r drivers\*

    ${if} ${RunningX64}
        ExecWait '"$TEMP\dpinst-amd64.exe" /sw' $1
    ${Else}
        ExecWait '"$TEMP\dpinst-x86.exe" /sw' $1
    ${EndIf}

    DetailPrint "Installation: $1"

    ${If} $1 > 0
        MessageBox MB_OK "Driver installation succeeded!"
    ${Else}
        MessageBox MB_OK "Driver installation failed. Please try again."
    ${EndIf}

SectionEnd
