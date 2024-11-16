@echo off
REM Check if a file was dropped onto the script

echo Running Update.bat...
call "%~dp0%Update.bat" || (
	echo Error occurred Updating.
	pause
	goto :EOF
)

echo Update.bat has finished.
echo Continuing with script1.bat...

if "%~1"=="" (
    echo Please drag and drop an ISO file onto this script.
    pause
    exit /b
)

REM Define the path to WIT Tools and the destination folder
set WIT_PATH="%~dp0Prereqs\wit\wit.exe"
set TRT_PATH="%~dp0Prereqs\szs\wstrt.exe"
set DEST_FOLDER=%~dp0%~n1_extracted
set OUT_FOLDER=%~dp0%out
set BINARY_FOLDER=%~dp0~n1_extracted\DATA\files\Binaries

REM Check if the destination folder exists
if exist "%DEST_FOLDER%" (
    echo Folder "%DEST_FOLDER%" already exists.
    echo Overwriting existing folder...
    rmdir /s /q "%DEST_FOLDER%" || (
        echo Error occurred while trying to delete the existing folder.
        pause
        goto :EOF
    )
)

REM Extract the ISO and handle errors
%WIT_PATH% extract "%~1" --dest "%DEST_FOLDER%" || (
    echo Error occurred during extraction.
    pause
    goto :EOF
)

REM Notify the user that extraction is complete
echo Extraction complete! Files are located in "%DEST_FOLDER%"

:TEST

if exist "%DEST_FOLDER%\DATA" (
	rmdir /s /q "%DEST_FOLDER%\CHANNEL" || (
        echo Error occurred while trying to delete the existing folder.
        pause
        goto :EOF
    )

	for /f "delims=" %%D in ('dir "%DEST_FOLDER%\DATA"\.svn /ad /b /s 2^>nul') do (
    	echo Found: %%D
    	rd /s /q "%%D" && echo Deleted: %%D || echo Failed to delete: %%D
	)

	XCOPY /y /s "%DEST_FOLDER%\DATA" "%DEST_FOLDER%" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y /s /t /e "%DEST_FOLDER%\DATA" "%DEST_FOLDER%" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	rmdir /s /q "%DEST_FOLDER%\DATA" || (
        echo Error occurred while trying to delete the existing folder.
        pause
        goto :EOF
    )
	
	REM Patch main.dol (assuming main.dol exists in the extracted folder)
	%WIT_PATH% dolpatch "%DEST_FOLDER%\sys\main.dol" xml="%~dp0Prereqs\Patches.xml" --source "%~dp0Patches\Binaries"

	REM Notify the user that main.dol has been patched
	echo main.dol patched!

	REM Copy Files
	if exist "%BINARY_FOLDER%" (
		echo Binary folder already exists!
	) else (
		mkdir "%DEST_FOLDER%\files\Binaries" || (
			echo Error occurred making the Binary Directory.
			pause
			goto :EOF
		)
	)

	XCOPY /y "%~dp0Patches\Binaries" "%DEST_FOLDER%\files\Binaries" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\rel\E\StaticR.rel" "%DEST_FOLDER%\files\rel\StaticR.rel" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Tracks" "%DEST_FOLDER%\files\Race\Course" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Assets" "%DEST_FOLDER%\files" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\strm" "%DEST_FOLDER%\files\sound\strm" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\UI" "%DEST_FOLDER%\files\Scene\UI" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Minus\Race" "%DEST_FOLDER%\files\Race" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Minus\sound" "%DEST_FOLDER%\files\sound" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Custom Music" "%DEST_FOLDER%\files\sound\strm" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Character Mods\Race Kart" "%DEST_FOLDER%\files\Race\Kart" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Character Mods\Scene Kart" "%DEST_FOLDER%\files\Scene\Model\Kart" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)
	
	XCOPY /y "%~dp0Patches\Character Mods\Model" "%DEST_FOLDER%\files\Scene\Model" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)
	
	XCOPY /y "%~dp0Patches\Demo" "%DEST_FOLDER%\files\Demo" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	%TRT_PATH% patch "%DEST_FOLDER%\sys\main.dol" --add-section "%~dp0Patches\codes\RMCE01.gct"

	echo main.dol patched with cheat codes!

	if exist "%OUT_FOLDER%" (
		echo out folder already exists!
	) else (
		mkdir "%~dp0out" || (
			echo Error occurred making the Binary Directory.
			pause
			goto :EOF
			goto :EOF
		)
	)


	if exist "%OUT_FOLDER%\MKMinus.iso" (
		echo iso already exists!
		
		del "%OUT_FOLDER%\MKMinus.iso" || (
			echo Error occurred while trying to delete the existing folder.
			pause
			goto :EOF
		)
	)

	REM Rebuild ISO
	%WIT_PATH% copy "%DEST_FOLDER%" --dest "%~dp0out\MKMinus.iso"

	REM Remove Extracted Files
	rmdir /s /q "%DEST_FOLDER%" || (
			echo Error occurred while trying to delete the existing folder.
			pause
			goto :EOF
	)


	echo Patching Complete! You May Now Close This Window!

	pause
) else (
	REM Patch main.dol (assuming main.dol exists in the extracted folder)
	%WIT_PATH% dolpatch "%DEST_FOLDER%\sys\main.dol" xml="%~dp0Prereqs\Patches.xml" --source "%~dp0Patches\Binaries"

	REM Notify the user that main.dol has been patched
	echo main.dol patched!

	REM Copy Files
	if exist "%BINARY_FOLDER%" (
		echo Binary folder already exists!
	) else (
		mkdir "%DEST_FOLDER%\files\Binaries" || (
			echo Error occurred making the Binary Directory.
			pause
			goto :EOF
		)
	)

	XCOPY /y "%~dp0Patches\Binaries" "%DEST_FOLDER%\files\Binaries" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\rel\E\StaticR.rel" "%DEST_FOLDER%\files\rel\StaticR.rel" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Tracks" "%DEST_FOLDER%\files\Race\Course" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Assets" "%DEST_FOLDER%\files" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\strm" "%DEST_FOLDER%\files\sound\strm" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\UI" "%DEST_FOLDER%\files\Scene\UI" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Minus\Race" "%DEST_FOLDER%\files\Race" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Minus\sound" "%DEST_FOLDER%\files\sound" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Custom Music" "%DEST_FOLDER%\files\sound\strm" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Character Mods\Race Kart" "%DEST_FOLDER%\files\Race\Kart" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	XCOPY /y "%~dp0Patches\Character Mods\Scene Kart" "%DEST_FOLDER%\files\Scene\Model\Kart" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)
	
	XCOPY /y "%~dp0Patches\Character Mods\Model" "%DEST_FOLDER%\files\Scene\Model" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)
	
	XCOPY /y "%~dp0Patches\Demo" "%DEST_FOLDER%\files\Demo" || (
		echo Error occurred copying files.
		pause
		goto :EOF
	)

	%TRT_PATH% patch "%DEST_FOLDER%\sys\main.dol" --add-section "%~dp0Patches\codes\RMCE01.gct"

	echo main.dol patched with cheat codes!

	if exist "%OUT_FOLDER%" (
		echo out folder already exists!
	) else (
		mkdir "%~dp0out" || (
			echo Error occurred making the Binary Directory.
			pause
			goto :EOF
			goto :EOF
		)
	)


	if exist "%OUT_FOLDER%\MKMinus.iso" (
		echo iso already exists!
		
		del "%OUT_FOLDER%\MKMinus.iso" || (
			echo Error occurred while trying to delete the existing folder.
			pause
			goto :EOF
		)
	)

	REM Rebuild ISO
	%WIT_PATH% copy "%DEST_FOLDER%" --dest "%~dp0out\MKMinus.iso"

	REM Remove Extracted Files
	rmdir /s /q "%DEST_FOLDER%" || (
			echo Error occurred while trying to delete the existing folder.
			pause
			goto :EOF
	)


	echo Patching Complete! You May Now Close This Window!

	pause
)

:EOF
