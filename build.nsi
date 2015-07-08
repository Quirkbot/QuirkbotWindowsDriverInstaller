RequestExecutionLevel admin

;NSIS Modern User Interface

;--------------------------------
;Include Modern UI

!include "MUI2.nsh"
!include WinMessages.nsh
!include LogicLib.nsh

;--------------------------------
;General

  ;Name and file
  Name "Quirkbot Drivers Installer"
  OutFile "Quirkbot-Windows-Drivers-Installer.exe"
  InstallDir "$TEMP\quirkbot"

  Caption "Quirkbot Drivers Installer"
  VIProductVersion "1.0.0.0"
  VIAddVersionKey ProductVersion "1.0.0.0"
  VIAddVersionKey FileVersion "1.0"
  VIAddVersionKey FileDescription "Quirkbot Drivers Installer"
  VIAddVersionKey ProductName "Quirkbot Drivers Installer"
  VIAddVersionKey InternalName "Quirkbot Drivers Installer"
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
  
section
setOutPath $INSTDIR
File /r drivers\*

!include x64.nsh

ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion

${if} ${RunningX64}
	; 64 bits go here
	ExecWait '"$INSTDIR\quirkbot\dpinst-amd64.exe" /sw' $1
${Else}
	; 32 bits go here
	ExecWait '"$INSTDIR\quirkbot\dpinst-x86.exe" /sw' $1
${EndIf}

!macro _CompletedWithSuccess _a _b _t _f
    !if `${_f}` == ``
        !undef _f
        !define _f +2 
    !endif
    IntCmp ${_b} 1 +2
    IntCmp ${_b} 256 `${_t}` `${_f}` `${_f}`
    !if `${_t}` != ``
        Goto `${_t}`
    !endif
!macroend
!define CompletedWithSuccess `"" CompletedWithSuccess`

${If} ${CompletedWithSuccess} $1
${Else}
  Sleep 3000
    MessageBox MB_OK "Installation failed. Please try again."
${EndIf}

sectionEnd