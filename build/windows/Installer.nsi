SetCompressor /SOLID LZMA
!include MUI2.nsh
!include FileFunc.nsh
InstallDir "$PROGRAMFILES64\JamTools"
;InstallDirRegKey HKCU "Software\JamTools" "$PROGRAMFILES64\JamTools"
!define PRODUCT_NAME "JamTools"
!define PRODUCT_VERSION "0.14.1B"
Unicode True

;--------------------------------
;Perform Machine-level install, if possible

!define MULTIUSER_EXECUTIONLEVEL Highest
;Add support for command-line args that let uninstaller know whether to
;uninstall machine- or user installation:
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!include MultiUser.nsh
!include LogicLib.nsh

Function .onInit
  ReadRegStr $0 HKCU "Software\JamTools" ""
  ReadRegStr $6 HKCU "Software\JamTools" "bb"
  ${If} $0 == ""
  ${Else}
  StrCpy $INSTDIR $0
  MessageBox MB_OKCANCEL|MB_ICONQUESTION  "Jamtools$6�Ѱ�װ��$0 $\n������װ����ֱ�Ӹ��ǻ����·��(�����������������)" IDCANCEL Exit
  ${EndIf}
  killer::IsProcessRunning "JamTools.exe"
  Pop $R0
  IntCmp $R0 1 0 no_run
  MessageBox MB_OKCANCEL|MB_ICONQUESTION  "��װ�����⵽ ${PRODUCT_NAME} �������С�$\r$\n$\r$\n��� ��ȷ���� ǿ�ƹر�${PRODUCT_NAME}��������װ��$\r$\n��� ��ȡ���� �˳���װ����" IDCANCEL Exit
  killer::KillProcess "JamTools.exe"
  Sleep 500
  killer::IsProcessRunning "JamTools.exe"
  Pop $R0
  IntCmp $R0 1 0 no_run
  Exit:
  Quit
  no_run:
  ;
  
  

FunctionEnd

Function un.onInit
  !insertmacro MULTIUSER_UNINIT
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "ж��${PRODUCT_NAME}���������" IDYES +2
  Abort
  killer::IsProcessRunning "JamTools.exe"
  Pop $R0
  IntCmp $R0 1 0 no_run
  MessageBox MB_OKCANCEL|MB_ICONQUESTION  "ж�س����⵽ ${PRODUCT_NAME} �������С�$\r$\n$\r$\n��� ��ȷ���� ǿ�ƹر�${PRODUCT_NAME}������ж�ء�$\r$\n��� ��ȡ���� �˳�ж�س���" IDCANCEL Exit
  killer::KillProcess "JamTools.exe"
  Sleep 500
  killer::IsProcessRunning "JamTools.exe"
  Pop $R0
  IntCmp $R0 1 0 no_run
  Exit:
  Quit
  no_run:
  
  
 
FunctionEnd


;--------------------------------
;General

  Name "JamTools"
  OutFile "..\JamTools${PRODUCT_VERSION}Setup_for_windows.exe"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\Icon.ico"
  !define MUI_WELCOMEPAGE_TEXT "���򵼽���JamTools��װ����ĵ����ϣ�$\r$\n$\r$\n$\r$\nClick Next to continue."
  !define MUI_DIRECTORYPAGE_TEXT_TOP  "ѡ��װ��λ�ã������鰲װ��ϵͳ��(��Ϊ̫����...) "
  !define MUI_
  !insertmacro MUI_PAGE_WELCOME
  ; ���ҳ��
  !define MUI_PAGE_CUSTOMFUNCTION_SHOW LicenseShow 
!insertmacro MUI_PAGE_LICENSE "..\JamTools\LICENSE" 
Function LicenseShow 
    
FunctionEnd 



  ; ��װĿ¼ѡ��ҳ��
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !define MUI_FINISHPAGE_NOAUTOCLOSE
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_CHECKED
  !define MUI_FINISHPAGE_RUN_TEXT "Run JamTools"
  !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "SimpChinese"
VIProductVersion "1.0.0.0"
VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=2052 "Comments" "�����Ȩ��ԭ�������У����˲��ø��ƻ���ο���������"
VIAddVersionKey /LANG=2052 "FileDescription" "JamTools��װ�򵼳���"
VIAddVersionKey /LANG=2052 "FileVersion" "${PRODUCT_VERSION}"
;--------------------------------
;Installer Sections

!define UNINST_KEY \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\JamTools"
Section
  SetShellVarContext all
  ${If} $0 == ""
  ${Else}
  ;StrCpy $INSTDIR $0
  RMDir /r "$0"
  ${EndIf}
  SetOutPath "$InstDir"
  File /r "..\JamTools\*"
  WriteRegStr HKCU "Software\JamTools" "" $InstDir
  WriteRegStr HKCU "Software\JamTools" "bb" "${PRODUCT_VERSION}"
  
  
  ;����jam�ļ�
  WriteRegStr HKCR ".jam" "" "jamfile"
  WriteRegStr HKCR "jamfile" "" "JamTools�����ļ�"
  WriteRegStr HKCR "jamfile\DefaultIcon" "" "$INSTDIR\JamTools.exe,0"
  WriteRegStr HKCR "jamfile\shell" "" open
  WriteRegStr HKCR "jamfile\shell\open" "" "���Ŷ���"
  WriteRegStr HKCR "jamfile\shell\open\command" "" '"$INSTDIR\JamTools.exe" "%1"'
  
  WriteUninstaller "$InstDir\uninstall.exe"
  CreateShortCut "$SMPROGRAMS\JamTools.lnk" "$InstDir\JamTools.exe"
  CreateShortCut "$DESKTOP\JamTools.lnk" "$InstDir\JamTools.exe"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayName" "JamTools"
  WriteRegStr HKCU "${UNINST_KEY}" "UninstallString" \
    "$\"$InstDir\uninstall.exe$\" /$MultiUser.InstallMode"
  WriteRegStr HKCU "${UNINST_KEY}" "QuietUninstallString" \
    "$\"$InstDir\uninstall.exe$\" /$MultiUser.InstallMode /S"
  WriteRegStr HKCU "${UNINST_KEY}" "Instdirstring" "$\"$InstDir$\""
  WriteRegStr HKCU "${UNINST_KEY}" "Publisher" "Fandes"
  ${GetSize} "$InstDir" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKCU "${UNINST_KEY}" "EstimatedSize" "$0"
  
  ExecWait 'regsvr32 /s "$INSTDIR\audio_sniffer-x64.dll"'
  ExecWait 'regsvr32 /s "$INSTDIR\screen-capture-recorder-x64.dll"'
  ;ExecWait 'regsvr32 /s "$INSTDIR\bin\LAVAudio.ax"'
  ;ExecWait 'regsvr32 /s "$INSTDIR\bin\LAVSplitter.ax"'
  ;ExecWait 'regsvr32 /s "$INSTDIR\bin\LAVVideo.ax"'
  ;DeleteRegKey HKCU "Software\Fandes"
  ;把exe封装进启动器
  ;File /r "..\Setup Screen Capturer Recorder v0.12.10.exe"
  ;执行外部程序setup.exe
  ;ExecWait "$INSTDIR\Setup Screen Capturer Recorder v0.12.10.exe parameter"
  ;Delete "$INSTDIR\Setup Screen Capturer Recorder v0.12.10.exe"



SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  SetShellVarContext all
  ExecWait 'regsvr32 /s /u "$INSTDIR\audio_sniffer-x64.dll"'
  ExecWait 'regsvr32 /s /u "$INSTDIR\screen-capture-recorder-x64.dll"'
  ;ExecWait 'regsvr32 /s /u "$INSTDIR\bin\LAVAudio.ax"'
  ;ExecWait 'regsvr32 /s /u "$INSTDIR\bin\LAVSplitter.ax"'
  ;ExecWait 'regsvr32 /s /u "$INSTDIR\bin\LAVVideo.ax"'
  RMDir /r "$InstDir"
  Delete "$SMPROGRAMS\JamTools.lnk"
  Delete "$DESKTOP\JamTools.lnk"
  
  DeleteRegKey HKCU "${UNINST_KEY}"
  DeleteRegKey HKCU "Software\Fandes\jamtools"
  DeleteRegKey /ifempty HKCU "Software\Fandes"
  DeleteRegKey HKCU "Software\JamTools"

SectionEnd

Function mulu
;���������ť
FindWindow $0 "#32770" "" $HWNDPARENT
GetDlgItem $0 $0 1001
EnableWindow $0 0
;��ֹ�༭Ŀ¼
FindWindow $0 "#32770" "" $HWNDPARENT
GetDlgItem $0 $0 1019
EnableWindow $0 0
FunctionEnd

Function LaunchLink
  !addplugindir "."
  ExecShell  "" "$InstDir\JamTools.exe"
FunctionEnd
