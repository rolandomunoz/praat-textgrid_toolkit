# Open one by one, all the audio files and their TextGrids in the specified directory
#
# Written by Rolando Munoz A. (24 April 2018 -17 Oct 2018)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form Open files (TextGridEditor)
    comment Folder with annotation files:
    text tgFolder /home/rolando/corpus
    comment Folder with audio files:
    text audioFolder .
    boolean Recursive_search 0
    boolean Adjust_volume 1
endform

tg_ext$ = ".TextGrid"
audio_ext$ = ".wav"
file_number = 1
volume = 0.99
pause = 1
buttonChoice = 1

relative_path = if startsWith(audioFolder$, ".") then 1 else 0 fi

# Find directories
@createStringAsFileList: "fileList", tgFolder$ + "/*'tg_ext$'", recursive_search
fileList = selected("Strings")
nFiles = Get number of strings

if not nFiles
    pause = 0
    writeInfoLine: "Open TextGrid & Sound"
    appendInfoLine: "No files in the specified directory"
endif

## Create corpus table
while pause
    file_number = if file_number > nFiles then 1 else file_number fi

    tg_relative_path$ = object$[fileList, file_number]
    tg_full_path$ = tgFolder$ + "/" + tg_relative_path$

    path$ = replace_regex$(tg_full_path$, "(.+)/(.+)", "\1", 1)
    basename$ = replace_regex$(tg_full_path$, "(.+)/(.+)", "\2", 1)
    audio_name$ = basename$ - tg_ext$ + audio_ext$

    if relative_path
        audio_full_path$ = path$ + "/" + audioFolder$ + "/" + audio_name$
    else
        audio_full_path$ = audioFolder$ + "/" + audio_name$
    endif

    tg = Read from file: tg_full_path$

    if fileReadable(audio_full_path$)
        # Open a Sound file from the list
        if adjust_volume
            sd = Read from file: audio_full_path$
            Scale peak: volume
        else
            sd = Open long sound file: audio_full_path$
        endif
        objectList# = {sd, tg}
    else
        objectList# = {tg}
    endif

    selectObject: objectList#

    View & Edit
    editor: tg

    beginPause: "file browser"
        comment: "Case: 'file_number'/'nFiles'"
        natural: "Next file",  if (file_number + 1) > nFiles then 1 else file_number + 1 fi
        if adjust_volume
            real: "Volume", volume
        endif
    clicked_pause = endPause: "Save", "Jump", "Quit", buttonChoice
    endeditor

    buttonChoice = clicked_pause
    if clicked_pause = 1
        selectObject: tg
        Save as text file: tg_full_path$
    endif

    removeObject: objectList#
    file_number = next_file

    if clicked_pause = 3
        pause = 0
    endif
endwhile

removeObject: fileList

include ../procedures/list_recursive_path.proc