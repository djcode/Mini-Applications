#include <GUIConstantsEx.au3>
#include <ListboxConstants.au3>

Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
$mainwindow = GUICreate("USB Virus Protector", 200, 200)
GUICtrlCreateLabel("Select Drive", 10, 2)
$drv_combo = GUICtrlCreateCombo( "", 10, 22, 180, 20)

; 	One day, I will have the "Refresh Drives" feature working.
;	$btn_rfrsh = GUICtrlCreateButton("P", 135, 22, 20, 20)
;	GUISetOnEvent($btn_rfrsh, "UpdateDrives")
;	GUICtrlSetFont($btn_rfrsh, 12, 800, 0, "Wingdings 3")
	UpdateDrives()

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

$btn_prtct = GUICtrlCreateButton("Protect", 70, 50, 60, 30)
GUICtrlSetOnEvent($btn_prtct, "FixDrive")

$lst_actions = GUICtrlCreateList("", 10, 90, 180, 100, $LBS_NOSEL)

GUISetState(@SW_SHOW)

While 1
  Sleep(1000)  ; Idle around
WEnd

Func UpdateDrives()
	GUICtrlSetData ($drv_combo, "")
	$get_drvs = DriveGetDrive("REMOVABLE")
	$drv_list = "|"
	For $i = 1 to $get_drvs[0]
       $drv_list &= $get_drvs[$i]&"|"
	Next
	GUICtrlSetData ($drv_combo, StringUpper($drv_list),$get_drvs[1])
EndFunc	

Func FixDrive()
	$drv = GUICtrlRead($drv_combo)
	$ar = $drv&"\autorun.inf"
	GUICtrlSetData($lst_actions, "|")
	If FileExists($ar) Then
		GUICtrlSetData($lst_actions, "autorun.inf found!|")
		Sleep(100)
		GUICtrlSetData($lst_actions, "Removing attributes (if any)...|")
		Sleep(100)
		FileSetAttrib($ar,"-HRS")
		Sleep(100)
		GUICtrlSetData($lst_actions, "Deleting autorun.inf...|")
		Sleep(100)
		FileDelete($ar)
	EndIf
	GUICtrlSetData($lst_actions, "Creating folder autorun.inf|")
	DirCreate($ar)
	Sleep(100)
	GUICtrlSetData($lst_actions, "Setting attributes...|")
	FileSetAttrib($ar,"+HRS",1)
	Sleep(100)
	GUICtrlSetData($lst_actions, "DONE!|")
EndFunc

Func CLOSEClicked()
  Exit
EndFunc