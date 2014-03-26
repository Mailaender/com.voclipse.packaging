#
# Copyright (c) 2014 vogella GmbH, Hamburg Germany
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
#

# USE lzma, otherwise Windows will throw an error when the script was compiled under linux.
SetCompressor lzma

#
# GENERAL SYMBOL DEFINITIONS
#
Name voclipse
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION "4.4M6"
!define COMPANY "vogella GmbH"
!define URL "http://www.voclipse.com"

#
# SOURCE CODE, PROCESSOR DEFINITIONS
#
!define SOURCE_CODE "com.vogella.vde.luna.product-win32.win32.${ARCHITECTURE}"

#
# MULTIUSER SYMBOL DEFINITIONS
#
!define MULTIUSER_MUI
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR "voclipse"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE "Path"

#
# MUI SYMBOL DEFINITIONS
#
!define MUI_ICON "vogella.ico"
!define MUI_UNICON "vogella.ico"

#
# MUI SETTINGS / HEADER
#
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "voclipse-horizontal.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "voclipse-horizontal.bmp"

#
# MUI SETTINGS / WIZARD
#
!define MUI_WELCOMEFINISHPAGE_BITMAP "voclipse-vertical.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "voclipse-vertical.bmp"
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "voclipse"
!define MUI_FINISHPAGE_RUN $INSTDIR\voclipse.exe

#
# MODERN INTERFACE
#
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh

#
# WELCOME AND LICENSE
# JRE DETECTION PAGE
# INSTALLMODE ...
#
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
Var StartMenuGroup
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

#
# INSTALLER LANGUAGES
#
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE German

#
#--------------------------------------------------------------INCLUDES
#

#
# INSTALLER VALUES
#
OutFile voclipse-${VERSION}-${ARCHITECTURE}-Setup.exe
InstallDir $INSTDIR
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 0.2.0.0
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName voclipse
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription "Vogella Development Environment"
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright "Copyright (c) 2014 vogella GmbH"
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

#
# DEPENDENCIES
#
Section "-Java" JAVA
	ClearErrors
	ReadRegStr $0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
	IfErrors error 0
	IntCmp $0 1 done error done
	error:
		MessageBox MB_YESNO "Java 6 or later is required to run voclipse. $\n \
		Do you wish for the installer to launch your web browser in order to download and install it?" \
		IDYES download IDNO error2
	download:
		ExecShell "open" "http://java.com/download"
		Goto done
	error2:
		MessageBox MB_OK "Installation will continue but be aware that voclipse will not run unless Java 6 \
		or later is installed."
	done:
SectionEnd

#
# VOCLIPSE
#
Section -voclipse VOCLIPSE
    #
    # SET THE INSTALL PATH
    #
    SetOutPath $INSTDIR
    SetOverwrite on

    #
    # INSTALL VOCLIPSE APPLICATION FILES
    #
    SetOutPath $INSTDIR\configuration
    File /r "${SOURCE_CODE}\configuration\*"

    SetOutPath $INSTDIR\features
    File /r "${SOURCE_CODE}\features\*"

    SetOutPath $INSTDIR\p2
    File /r "${SOURCE_CODE}\p2\*"

    SetOutPath $INSTDIR\plugins
    File /r "${SOURCE_CODE}\plugins\*"

    #SetOutPath $INSTDIR\readme
    #File /r "${SOURCE_CODE}\readme\*"

    SetOutPath $INSTDIR
    File "${SOURCE_CODE}\.eclipseproduct"
    File "${SOURCE_CODE}\artifacts.xml"
    File "${SOURCE_CODE}\eclipsec.exe"
    File "${SOURCE_CODE}\epl-v10.html"
    File "${SOURCE_CODE}\notice.html"
    File "${SOURCE_CODE}\voclipse.exe"
    File "${SOURCE_CODE}\voclipse.ini"

    WriteRegStr HKLM "${REGKEY}\Components" voclipse 1
SectionEnd

#
# METADATA
#
Section -post METADATA
    #
    # GET THE INSTALL PATH
    #
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    #
    # MENU/PROGRAM ICONS
    #
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    SetOutPath $INSTDIR
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" "$INSTDIR\uninstall.exe"

    CreateShortCut "$SMPROGRAMS\$StartMenuGroup\voclipse.lnk" "$INSTDIR\voclipse.exe"
    CreateShortCut "$DESKTOP\voclipse.lnk" "$INSTDIR\voclipse.exe"
    CreateShortCut "$QUICKLAUNCH\voclipse.lnk" "$INSTDIR\voclipse.exe"

    #
    # REGISTRY
    #
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

#
# UNINSTALL SECTIONS
#

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}

    next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"

    done${UNSECTION_ID}:
    Pop $R0
!macroend

#
# UNVOCLIPSE
#
Section /o -un.voclipse UNVOCLIPSE
    DeleteRegValue HKLM "${REGKEY}\Components" voclipse
SectionEnd

#
# UNMETADATA
#
Section -un.post UNMETADATA
    #
    # DELETE REGISTRY ENTRIES
    #
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"

    #
    # DELETE FILES
    #
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk"
    Delete /REBOOTOK "$DESKTOP\voclipse.lnk"
    Delete /REBOOTOK "$QUICKLAUNCH\voclipse.lnk"

    Delete /REBOOTOK "$INSTDIR\.eclipseproduct"
    Delete /REBOOTOK "$INSTDIR\artifacts.xml"
    Delete /REBOOTOK "$INSTDIR\eclipsec.exe"
    Delete /REBOOTOK "$INSTDIR\epl-v10.html"
    Delete /REBOOTOK "$INSTDIR\notice.html"
    Delete /REBOOTOK "$INSTDIR\voclipse.exe"
    Delete /REBOOTOK "$INSTDIR\voclipse.ini"

    Delete /REBOOTOK "$INSTDIR\uninstall.exe"

    Delete /REBOOTOK "$INSTDIR\*.log"

    #
    # DELETE DIRS
    #
    RMDir /R /REBOOTOK "$SMPROGRAMS\$StartMenuGroup"

    #
    # RMDir /REBOOTOK $INSTDIR (DELETE IF NOT EMPTY => WITHOUT /R)
    #
    RMDir /R /REBOOTOK "$INSTDIR\configuration"
    RMDir /R /REBOOTOK "$INSTDIR\features"
    RMDir /R /REBOOTOK "$INSTDIR\p2"
    RMDir /R /REBOOTOK "$INSTDIR\plugins"
    RMDir /R /REBOOTOK "$INSTDIR\readme"

    RMDir /REBOOTOK "$INSTDIR"

    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup

    no_smgroup:
    Pop $R0
SectionEnd

#
# INSTALLER
#
Function .onInit
    #
    # SET THE CORRECT REGISTRY ACCESS
    #
    !if ${ARCHITECTURE} == x86_64
      SetRegView 64
    !else
      SetRegView 32
    !endif
    #
    # INSTALL
    #
    InitPluginsDir
    !insertmacro MULTIUSER_INIT
    !if ${ARCHITECTURE} == x86_64
      StrCpy $INSTDIR $PROGRAMFILES64\voclipse
    !else
      StrCpy $INSTDIR $PROGRAMFILES\voclipse
    !endif
FunctionEnd

#
# UNINSTALLER
#
Function un.onInit
    #
    # SET THE CORRECT REGISTRY ACCESS
    #
    !if ${ARCHITECTURE} == x86_64
      SetRegView 64
    !else
      SetRegView 32
    !endif
    #
    # UNINSTALL
    #
    SetAutoClose true
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MULTIUSER_UNINIT
    !insertmacro SELECT_UNSECTION voclipse ${UNVOCLIPSE}
FunctionEnd

#
# LANGUAGE STRINGS
#
LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_GERMAN} "Deinstalliere $(^Name)"
