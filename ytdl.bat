@ECHO OFF
REM BFCPEOPTIONSTART
REM Advanced BAT to EXE Converter www.BatToExeConverter.com
REM BFCPEEXE=C:\Users\ntrid\OneDrive\Desktop\youtube-dl\ytdl.exe
REM BFCPEICON=C:\Users\ntrid\Downloads\ytdl2.ico
REM BFCPEICONINDEX=3
REM BFCPEEMBEDDISPLAY=0
REM BFCPEEMBEDDELETE=1
REM BFCPEADMINEXE=0
REM BFCPEINVISEXE=0
REM BFCPEVERINCLUDE=1
REM BFCPEVERVERSION=1.0.0.0
REM BFCPEVERPRODUCT=YouTube Downloader
REM BFCPEVERDESC=Downloads YouTube videos using terminal.
REM BFCPEVERCOMPANY=karonboi - R. Garcia - F. Bellard
REM BFCPEVERCOPYRIGHT=(c) 2021
REM BFCPEOPTIONEND
@ECHO ON
@echo off
title YouTube Downloader

:getlocation
< bin\savepath (
set /p result=
)
goto getlastdl

:getlastdl
< history\lastsave.txt (
set /p last=
)
goto menu

:menu
cls
echo YouTube Downloader (v1.0)
echo (C) 2006 - 2021 Ricardo Garcia [youtube-dl]
echo (C) 2000 - 2021 Fabrice Bellard [FFmpeg]
echo (C) 2021 karonboi [YouTube Downloader]
echo.
echo Paste the video key and press Enter:
echo [E] View "Usage Warning"
echo [P] Change savepath [%result%]
echo [H] History [last download: %last%]
set /p link=
if %link% == E goto uw
if %link% == e goto uw
if %link% == P goto changelocation
if %link% == p goto changelocation
if %link% == H goto history
if %link% == h goto history
if not %link% == E goto select_type
if not %link% == e goto select_type
if not %link% == P goto select_type
if not %link% == p goto select_type
if not %link% == H goto select_type
if not %link% == h goto select_type
goto getlocation

:history
notepad history\download_history.txt
goto menu

:uw
start bin\vb-scripts\uw.vbs
goto menu

:changelocation
echo.
rem BrowseFolder
goto save_path

:save_path
echo %result%>bin\savepath
start bin\vb-scripts\ps.vbs
goto getlocation

:select_type
cls
echo Now, select a file type:
echo (video: mp4, amv, avi, etc.)
echo (audio: mp3, wav, ogg, etc.)
echo [Q] Go back
set /p type=
if %type% == Q goto menu
if %type% == q goto menu
if %type% == Q goto set
if %type% == q goto set
goto set

:set
set time_start=%time%
set date_start=%date%
goto save

:save
del history\lastsave.txt
echo [%time_start%, %date_start%] %link% >> history\download_history.txt
echo %link% at %time_start%, %date_start%>history\lastsave\lastsave.txt
goto download

:download
cls
title YouTube Downloader [youtube-dl] [Downloading the video]
bin\youtube-dl https://youtu.be/%link%
goto ren_webm

:ren_webm
ren *.webm input.webm
ren *.mkv input.mkv
ren *.mp4 output.mp4
goto ifexist_download

:ifexist_download
if exist input.webm goto verify_changetype
if not exist input.webm goto ifexist_download_mkv
goto ifexist_download

:ifexist_download_mkv
if exist input.mkv goto verify_changetype_mkv
if not exist input.mkv goto ifexist_download_mp4
goto ifexist_download_mkv

:ifexist_download_mp4
if exist output.mp4 goto copy_mp4
if not exist output.mp4 goto ftd
goto ifexist_download_mp4

:ftd
start bin\vb-scripts\ftd.vbs
echo.
echo YouTube Downloader [Stopped]
echo Download aborted.
echo Press any key to return to menu.
pause >nul
goto menu

:verify_changetype
if %type% == mp4 goto convert_mp4
if not %type% == mp4 goto convert
goto verify_changetype

:verify_changetype_mkv
if %type% == mp4 goto convert_mp4_mkv
if not %type% == mp4 goto convert_mkv
goto verify_changetype_mkv


:convert
title YouTube Downloader [FFmpeg] [Converting to %type%]
bin\ffmpeg -i input.webm %link%.%type%
goto copy_type

:convert_mkv
title YouTube Downloader [FFmpeg] [Converting to %type%]
bin\ffmpeg -i input.mkv %link%.%type%
goto copy_type

:convert_mp4
title YouTube Downloader [FFmpeg] [Shifting to mp4]
bin\ffmpeg -i input.webm output.mp4
goto copy_mp4

:convert_mp4_mkv
title YouTube Downloader [FFmpeg] [Shifting to mp4]
bin\ffmpeg -i input.mkv output.mp4
goto copy_mp4

:copy_mp4
copy output.mp4 %result%\%link%.mp4
del output.mp4
goto done

:copy_type
copy %link%.%type% %result%\%link%.%type%
del input.webm
del input.mkv
del %link%.%type%
goto done

:done
title YouTube Downloader [Finished]
echo Finished downloading.
echo File saved at %result%
echo Press any key to return to the menu.
pause >nul
goto getlocation