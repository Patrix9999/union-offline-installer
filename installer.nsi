;--------------------------------
;Includes

  !include "MUI2.nsh" ;Modern UI
  !include "Sections.nsh" ;Exclusive sections
  !include "LogicLib.nsh" ;Simpler Logic
  !include "WordFunc.nsh" ;VersionCompare

;--------------------------------
;Constants

  !define PROJECT_NAME "Union"

  !ifndef PROJECT_VERSION
    !define PROJECT_VERSION "1.0.0.0"
  !endif

  !ifndef INSTALLER_NAME
    !define INSTALLER_NAME "union-1.0m"
  !endif

  !define PROJECT_WEBSITE "https://worldofplayers.ru/threads/40376/"
  !define AUTHOR "Gratt"

;--------------------------------
;Compile time directives

;--------------------------------
;Version Information

  VIProductVersion "${PROJECT_VERSION}"
  VIAddVersionKey "ProductName" "${PROJECT_NAME}"
  VIAddVersionKey "Comments" "n/a"
  VIAddVersionKey "LegalCopyright" "© ${AUTHOR}"
  VIAddVersionKey "FileDescription" "${PROJECT_NAME} installer"
  VIAddVersionKey "FileVersion" "${PROJECT_VERSION}"
  VIAddVersionKey "OriginalFilename" "${INSTALLER_NAME}.exe"

;--------------------------------
;General

  Name "${PROJECT_NAME}"
  BrandingText "${PROJECT_NAME} - Setup"
  OutFile "${INSTALLER_NAME}.exe"
  
  !AddPluginDir "Plugins"

  Unicode True
  SetCompressor /SOLID /FINAL lzma

  InstallDir "C:\Program Files (x86)\JoWooD\Gothic II\"

  RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "resources\header.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "resources\wizard.bmp"
  
  !define MUI_FINISHPAGE_LINK "${PROJECT_NAME} forum thread"
  !define MUI_FINISHPAGE_LINK_LOCATION ${PROJECT_WEBSITE}

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ; The first language is the default language
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Ukrainian"

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;Installer Sections

Section "Gothic 1 Classic" SectionG1

  SetOutPath "$INSTDIR"

  Call BackupGameFiles

  File /r "files\g1\*.*"
  File /r "files\union\*.*"

SectionEnd

Section /o "Gothic 1 Addon" SectionG1A

  SetOutPath "$INSTDIR"

  Call BackupGameFiles

  File /r "files\g1a\*.*"
  File /r "files\union\*.*"

SectionEnd

Section /o "Gothic 2 Classic" SectionG2

  SetOutPath "$INSTDIR"

  Call BackupGameFiles

  File /r "files\g2\*.*"
  File /r "files\union\*.*"

SectionEnd

Section /o "Gothic 2 Addon" SectionG2A

  SetOutPath "$INSTDIR"

  Call BackupGameFiles

  File /r "files\g2a\*.*"
  File /r "files\union\*.*"

SectionEnd

;--------------------------------
;Installer Function

Function BackupGameFiles
  ;Create .backup_union folder
  CreateDirectory "$INSTDIR\.backup_union"
  SetFileAttributes "$INSTDIR\.backup_union" HIDDEN

  ;Backup dinput.dll file if present
  ${If} ${FileExists} "$INSTDIR\System\dinput.dll"
    CopyFiles /SILENT "$INSTDIR\System\dinput.dll" "$INSTDIR\.backup_union\dinput.dll"
  ${EndIf}

  ;Backup Shw32.dll file if present
  ${If} ${FileExists} "$INSTDIR\System\Shw32.dll"
    CopyFiles /SILENT "$INSTDIR\System\Shw32.dll" "$INSTDIR\.backup_union\Shw32.dll"
  ${EndIf}

  ;Backup Vdfs32g.dll file if present
  ${If} ${FileExists} "$INSTDIR\System\Vdfs32g.dll"
    CopyFiles /SILENT "$INSTDIR\System\Vdfs32g.dll" "$INSTDIR\.backup_union\Vdfs32g.dll"
  ${EndIf}

  ;Backup Gothic.ini file if present
  ${If} ${FileExists} "$INSTDIR\System\Gothic.ini"
    CopyFiles /SILENT "$INSTDIR\System\Gothic.ini" "$INSTDIR\.backup_union\Gothic.ini"
  ${EndIf}

  ;Backup SystemPack.ini file if present
  ${If} ${FileExists} "$INSTDIR\System\SystemPack.ini"
    CopyFiles /SILENT "$INSTDIR\System\SystemPack.ini" "$INSTDIR\.backup_union\SystemPack.ini"
  ${EndIf}
FunctionEnd

;--------------------------------
;Installer Callbacks

Function .onInit

  InitPluginsDir

  File /oname=$PLUGINSDIR\splash.bmp "resources\splash.bmp"
	splash::show 2000 $PLUGINSDIR\splash

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

Function .onVerifyInstDir

  ${If} ${FileExists} "$INSTDIR\System\Gothic.exe"
    HashInfo::GetFileCryptoHash "MD5" "$INSTDIR\System\Gothic.exe"
    Pop $0
  ${ElseIf} ${FileExists} "$INSTDIR\System\Gothic2.exe"
    HashInfo::GetFileCryptoHash "MD5" "$INSTDIR\System\Gothic2.exe"
    Pop $0
  ${ElseIf} ${FileExists} "$INSTDIR\System\Vdfs32g.dll"
    StrCpy $0 ""
  ${Else}
    Abort
  ${EndIf}

  ${If} $0 == "114733F02A2F22387BF58EABC7AB0607"
  ${OrIf} $0 == "637355358D4B8A9BF2EB7E6E1C0F4B9E"
  ${OrIf} $0 == "E0144B8B8CC690CD2E416E473D94D0A8"
    StrCpy $1 ${SectionG1}
  ${ElseIf} $0 == "03E7FF0AF0AC2308E3D7226855B7A512"
  ${OrIf} $0 == "DDFB9070229EAD0C3444E3E2BD60A66F"
    StrCpy $1 ${SectionG1A}
  ${ElseIf} $0 == "BED9A6BB63760BEB6A093AA42A36AAB8"
  ${OrIf} $0 == "6B3F46EC4DF7E6D6367DD93575D09A1D"
    StrCpy $1 ${SectionG2}
  ${ElseIf} $0 == "3C436BD199CAAAA64E9736E3CC1C9C32"
  ${OrIf} $0 == "E4171F54947DA42CED47E2CF21F356A5"
  ${OrIf} $0 == "6706198A79022BF704412D6B72DFB45A"
    StrCpy $1 ${SectionG2A}
  ${Else}
    StrCpy $1 ""
  ${EndIf}

  ${If} $1 != ""
    SectionSetFlags ${SectionG1} ${SF_RO}
    SectionSetFlags ${SectionG1A} ${SF_RO}
    SectionSetFlags ${SectionG2} ${SF_RO}
    SectionSetFlags ${SectionG2A} ${SF_RO}
    SectionSetFlags $1 ${SF_SELECTED}|${SF_RO}
  ${Else}
    SectionSetFlags ${SectionG1} 0
    SectionSetFlags ${SectionG1A} 0
    SectionSetFlags ${SectionG2} 0
    SectionSetFlags ${SectionG2A} 0
  ${Endif}

FunctionEnd

Function .onSelChange
  !insertmacro StartRadioButtons $1
    !insertmacro RadioButton ${SectionG1}
    !insertmacro RadioButton ${SectionG1A}
    !insertmacro RadioButton ${SectionG2}
    !insertmacro RadioButton ${SectionG2A}
  !insertmacro EndRadioButtons
FunctionEnd

;--------------------------------
;Descriptions
  
  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SectionG1} "Union modification for: Gothic 1"
  !insertmacro MUI_DESCRIPTION_TEXT ${SectionG1A} "Union modification for: Gothic Sequel"
  !insertmacro MUI_DESCRIPTION_TEXT ${SectionG2} "Union modification for: Gothic 2 Classic"
  !insertmacro MUI_DESCRIPTION_TEXT ${SectionG2A} "Union modification for: Gothic 2 Night of the Raven"
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------