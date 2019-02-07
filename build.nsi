;--------------------------------
;Include Modern UI
    !include "MUI2.nsh"
    !include "UAC.nsh"
    !include WinMessages.nsh
    !include LogicLib.nsh
;--------------------------------
;General
	RequestExecutionLevel user
    Name "Quirkbot drivers installation"
    OutFile "Quirkbot-Windows-Drivers-Installer.exe"
    InstallDir "$TEMP\quirkbot"

    !define CAPTION "Quirkbot drivers installation"
    !define VERSION "1.0.0.1"
    !define APP_NAME "Quirkbot"
    !define EXECUTABLE_NAME "Quirkbot-Windows-Drivers-Installer.exe"

    Caption "${CAPTION}"
    VIProductVersion "${VERSION}"
    VIAddVersionKey ProductVersion "${VERSION}"
    VIAddVersionKey FileVersion "${VERSION}"
    VIAddVersionKey FileDescription "${APP_NAME}"
    VIAddVersionKey ProductName "${APP_NAME}"
    VIAddVersionKey InternalName "${APP_NAME}"
    VIAddVersionKey LegalCopyright "${APP_NAME}"
    VIAddVersionKey CompanyName "${APP_NAME}"
    VIAddVersionKey OriginalFilename "${EXECUTABLE_NAME}"
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

Function .onInit
    uac_tryagain:
    !insertmacro UAC_RunElevated
    DetailPrint "Install drivers"
    ${Switch} $0
    ${Case} 0
        ${IfThen} $1 = 1 ${|} Quit ${|} ;we are the outer process, the inner process has done its work, we are done
        ${IfThen} $3 <> 0 ${|} ${Break} ${|} ;we are admin, let the show go on
        ${If} $1 = 3 ;RunAs completed successfully, but with a non-admin user
            MessageBox mb_YesNo|mb_IconExclamation|mb_TopMost|mb_SetForeground "${CAPTION} requires admin privileges, try again" /SD IDNO IDYES uac_tryagain IDNO 0
        ${EndIf}
        ;fall-through and die
    ${Case} 1223
        MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "${CAPTION} requires admin privileges, aborting!"
        Quit
    ${Case} 1062
        MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Logon service not running, aborting!"
        Quit
    ${Default}
        MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Unable to elevate, error $0"
        Quit
    ${EndSwitch}

    SetShellVarContext all
FunctionEnd

;--------------------------------
Section "Install a Driver" InstDriver
    ${If} ${AtMostWin8.1}
        SetOutPath $TEMP
        File /r drivers\*

        ${if} ${RunningX64}
            ExecWait '"$TEMP\dpinst-amd64.exe" /u old1000\quirkbot.inf /S' $1
            DetailPrint "Uninstall: $1"
            ExecWait '"$TEMP\dpinst-amd64.exe" /sw' $1
        ${Else}
            ExecWait '"$TEMP\dpinst-x86.exe" /u old1000\quirkbot.inf /S' $1
            DetailPrint "Uninstall: $1"
            ExecWait '"$TEMP\dpinst-x86.exe" /sw' $1
        ${EndIf}

        DetailPrint "Installation: $1"

        ${If} $1 > 0
            MessageBox MB_OK "${CAPTION} succeeded!"
        ${Else}
            MessageBox MB_OK "${CAPTION} failed. Please try again."
        ${EndIf}
    ${Else}
        MessageBox MB_OK "Your Windows version doesn't need any drivers!"
    ${EndIf}

SectionEnd
