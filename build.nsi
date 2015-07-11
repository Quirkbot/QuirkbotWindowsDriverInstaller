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

    ${IfNot} ${AtLeastWin7}
        ;--------------------------------
        ;Windows XP

        ${IfNot} ${AtLeastWin7}
            MessageBox MB_OK "Make sure there is a Quirkbot connected to the computer."
        ${EndIf}

        InstDrv::InitDriverSetup /NOUNLOAD "{4d36e978-e325-11ce-bfc1-08002be10318}" "USB\Class_02&SubClass_02&Prot_00"
        Pop $0
        DetailPrint "InitDriverSetup: $0"

        InstDrv::DeleteOemInfFiles /NOUNLOAD
        Pop $0
        DetailPrint "DeleteOemInfFiles: $0"
        StrCmp $0 "00000000" PrintInfNames ContInst1

        PrintInfNames:
            Pop $0
            DetailPrint "Deleted $0"
            Pop $0
            DetailPrint "Deleted $0"

        ContInst1:
            InstDrv::CreateDevice /NOUNLOAD
            Pop $0
            DetailPrint "CreateDevice: $0"


            InstDrv::InstallDriver /NOUNLOAD "$TEMP\arduino.inf"
            Pop $0
            DetailPrint "InstallDriver: $0"
            ${If} $0 == "00000000"
                MessageBox MB_OK "Installation succeeded!"
            ${ElseIf} $0 == "E000020B"
                MessageBox MB_OK "Installation failed. Couldn't find a Quirkbot connected to the computer."
            ${Else}
                MessageBox MB_OK "Installation failed. Please try again."
            ${EndIf}


    ${Else}
        ;--------------------------------
        ;Windows 7 and above

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

    ${EndIf}

SectionEnd
