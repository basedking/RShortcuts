@echo off
setlocal enabledelayedexpansion
set LF=^


echo Select a Victoria 2 exe:


set /a count=0
for %%f in (v2game*.exe) do (
    set /a count+=1
    set "file[!count!]=%%~nf"
    echo [!count!] %%~nf
)

if %count% equ 0 (
    echo No Victoria 2 executable file found.
    echo Press Enter to close this window.
    pause > nul
    exit
)
if %count% equ 1 (
    set "exe_file=!file[1]!.exe"
    echo One Victoria 2 executable file. Selected automatically: !exe_file!
) else (
    Echo Enter the corresponding number to select file: 
    set /p "choice= "
    set "exe_file="
    for /L %%i in (1,1,%count%) do (
        if !choice! equ %%i (
            set "exe_file=!file[%%i]!.exe"
            goto :found
        )
    )
    :found
    if defined exe_file (
        echo Selected file: !exe_file!
    ) else (
        echo Invalid choice: !choice!
    )
)




echo Select the .mod files from the mod folder (use space to select multiple files):

set /a count_mod=0
for %%f in (mod\*.mod) do (
	set /a count_mod+=1
	set "file[!count_mod!]=%%~nf"
	echo [!count_mod!] %%~nf
)

echo Enter the corresponding numbers to select files:
set "selected_files="
set /p "choices= "
for %%i in (%choices%) do (
	if %%i geq 1 if %%i leq !count_mod! (
		set "selected_files=!selected_files! -mod=mod/!file[%%i]!.mod"
	) else (
		echo Invalid choice: %%i
	)
)

set "RESULT=cd /d %~dp0!LF!start !exe_file!!selected_files!!LF!echo Victoria 2 is launching...!LF!timeout /T 5"
echo Enter the filename to save the result:
set /p "filename="
if not exist "mod/1_RShortcuts" mkdir "mod/1_RShortcuts"
echo !RESULT! > "mod/1_RShortcuts/%filename%.bat"
echo File "%filename%.bat" in folder mod/1_RShortcuts created with content: !RESULT!. !LF!Launch it to play.

set /P "create_shortcut=Do you want to create a desktop link to the file? (Y/N): "
set "directory=%~dp0mod\1_RShortcuts\%filename%.bat"
set "icon=%~dp0RShortcuts.ico"
if /i "%create_shortcut%"=="Y" (
    (
    echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)
    echo DesktopPath = WshShell.SpecialFolders^("Desktop"^)
    echo ShortcutPath = DesktopPath ^& "\\" ^& "%filename%.lnk"
    echo Set oShortcut = WshShell.CreateShortcut^(ShortcutPath^)
    echo oShortcut.TargetPath = "%directory%"
    echo oShortcut.IconLocation = "%icon%,0"
    echo oShortcut.Save
    ) > CreateShortcut.vbs
    cscript //nologo CreateShortcut.vbs
    del CreateShortcut.vbs
) else ( 
    echo Your shortcut is in mod/1_RShortcuts 
)

echo Press Enter to close this window.
pause > nul
exit


endlocal
