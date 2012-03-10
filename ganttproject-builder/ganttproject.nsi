; The name of the installer
!include "MUI.nsh"
!include "LogicLib.nsh"

Name "GanttProject"
XPStyle on
Icon "ganttproject_32_2.ico"

!define MUI_ICON "ganttproject_32_2.ico"
!define VERSION "2.5-r1024"

OutFile ganttproject-${VERSION}.exe

; The default installation directory
InstallDir $PROGRAMFILES\GanttProject-2.5


!define MUI_ABORTWARNING
	
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
  
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "Catalan"

!insertmacro MUI_RESERVEFILE_LANGDLL

Section "GanttProject"

  SectionIn RO ; read-only
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

	
  ; Put file there
  File ganttproject_16.ico
  File ganttproject_32_2.ico
  File eclipsito.jar
  File ganttproject.bat
  File ganttproject.exe
  File HouseBuildingSample.gan
  File LICENSE
  
  StrCpy $OUTDIR "$INSTDIR\plugins"
  File /r plugins\net.sourceforge.ganttproject
  SetOutPath $INSTDIR

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\GanttProject "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GanttProject" "DisplayName" "GanttProject"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GanttProject" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GanttProject" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GanttProject" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
	
	; Associate .gan files with GP
	WriteRegStr HKCR ".gan" "" "GanttProject File"
	WriteRegStr HKCR ".gan\shell" "" "open"
	WriteRegStr HKCR ".gan\DefaultIcon" "" "$INSTDIR\ganttproject_32_2.ico,0"
	WriteRegStr HKCR ".gan\shell\open\command" "" '"$INSTDIR\ganttproject.exe" "%1"'
	System::Call 'Shell32::SHChange	Notify(i SHCNE_ASSOCCHANGED, i SHCNF_IDLIST, i 0, i 0)'
SectionEnd

Section "MS-Project Import/Export"

  SetOutPath $INSTDIR
  StrCpy $OUTDIR "$INSTDIR\plugins"
  File /r plugins\biz.ganttproject.impex.msproject2
  SetOutPath $INSTDIR
SectionEnd

Section "PERT chart"

  SetOutPath $INSTDIR
  StrCpy $OUTDIR "$INSTDIR\plugins"
  File /r plugins\org.ganttproject.chart.pert
  SetOutPath $INSTDIR

SectionEnd

; to uncheck a section by default use Section /o "HTML export plug-in"
Section "HTML/PDF export"
  SectionSetText "HTML and PDF export capabilities" 1
  SetOutPath $INSTDIR
  StrCpy $OUTDIR "$INSTDIR\plugins"
  File /r plugins\org.ganttproject.impex.htmlpdf
  SetOutPath $INSTDIR

SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\GanttProject"
  CreateShortCut "$SMPROGRAMS\GanttProject\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\GanttProject\GanttProject.lnk" "$INSTDIR\ganttproject.exe" "" "$INSTDIR\ganttproject_32_2.ico"
  CreateShortCut "$SMPROGRAMS\GanttProject\HouseBuildingSample.lnk" "$INSTDIR\HouseBuildingSample.gan" "" "$INSTDIR\ganttproject_32_2.ico"
  CreateShortCut "$INSTDIR\Run GanttProject.lnk" "$INSTDIR\ganttproject.exe" "" "$INSTDIR\ganttproject_32_2.ico"
  CreateShortCut "$DESKTOP\GanttProject.lnk" "$INSTDIR\ganttproject.exe" "" "$INSTDIR\ganttproject_32_2.ico"

SectionEnd

Section /o "Open Microsoft Project files with GanttProject"
	WriteRegStr HKCR ".mpp" "" "Microsoft Project File"
	WriteRegStr HKCR ".mpp\shell" "" "open"
	WriteRegStr HKCR ".mpp\DefaultIcon" "" "$INSTDIR\ganttproject_32_2.ico,0"
	WriteRegStr HKCR ".mpp\shell\open\command" "" '"$INSTDIR\ganttproject.exe" "%1"'
	System::Call 'Shell32::SHChangeNotify(i SHCNE_ASSOCCHANGED, i SHCNF_IDLIST, i 0, i 0)'

	WriteRegStr HKCR ".mpx" "" "Microsoft Project File"
	WriteRegStr HKCR ".mpx\shell" "" "open"
	WriteRegStr HKCR ".mpx\DefaultIcon" "" "$INSTDIR\ganttproject_32_2.ico,0"
	WriteRegStr HKCR ".mpx\shell\open\command" "" '"$INSTDIR\ganttproject.exe" "%1"'
	System::Call 'Shell32::SHChangeNotify(i SHCNE_ASSOCCHANGED, i SHCNF_IDLIST, i 0, i 0)'
	
      WriteRegStr HKCR "SOFTWARE\GanttProject" "Open_MSProject_Files" 1

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  ReadRegStr $1 HKCR "SOFTWARE\GanttProject" "Open_MSProject_Files"  
  ${If} $1 = 1
    DeleteRegKey HKCR ".mpp"
    DeleteRegKey HKCR ".mpx"
  ${EndIf}
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GanttProject"
  DeleteRegKey HKLM SOFTWARE\GanttProject
  DeleteRegKey HKCR ".gan"
  DeleteRegKey HKCR ".gan\shell"
  DeleteRegKey HKCR ".gan\DefaultIcon"
  DeleteRegKey HKCR ".gan\shell\open\command"

  ; Remove files and uninstaller
  RMDir /r "$INSTDIR"


  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\GanttProject\*.*"
  Delete "$DESKTOP\GanttProject.lnk"
	Delete "$INSTDIR\Run GanttProject.lnk"

  ; Remove directories used
  RMDir "$SMPROGRAMS\GanttProject"
  RMDir "$INSTDIR"

SectionEnd