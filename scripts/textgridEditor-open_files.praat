# Open one by one, all the audio files and their TextGrids in the specified directory
#
# Written by Rolando Muñoz A. (24 April 2018 -17 Oct 2018)
# Modified on 2023-Feb-13 by Rolando Muñoz
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
    text Folder_with_annotation_files /home/rolando/corpus
    word Annotation_file_extension TextGrid
    text Folder_with_audio_files .
    word Sound_file_extension wav
    text SpellingChecker_path
    boolean Recursive_search 0
    boolean Adjust_volume 1
endform

textgrid_dir$ = folder_with_annotation_files$
sound_dir$ = folder_with_audio_files$
spelling_checker_path$ = spellingChecker_path$
textgrid_extension$ = annotation_file_extension$
sound_extension$ = sound_file_extension$

file_number = 1
volume = 0.99
pause = 1
spelling_checker = 0
button_choice = 1
relative_path = if startsWith(sound_dir$, ".") then 1 else 0 fi

# Find directories
@createStringAsFileList: "fileList", textgrid_dir$ + "/*.'textgrid_extension$'", recursive_search
file_list_id = selected("Strings")
main_objects# = {file_list_id}
nFiles = Get number of strings

if not nFiles
    pause = 0
    writeInfoLine: "Open TextGrid & Sound"
    appendInfoLine: "No files in the specified directory"
endif

if fileReadable(spelling_checker_path$)
    spelling_checker_id = Read from file: spelling_checker_path$
    spelling_checker = 1
    main_objects# = {file_list_id, spelling_checker_id}
endif

## Main
while pause
    file_number = if file_number > nFiles then 1 else file_number fi

    tg_relative_path$ = object$[file_list_id, file_number]
    textgrid_path_$ = textgrid_dir$ + "/" + tg_relative_path$
    textgrid_path$ = replace$(textgrid_path_$, "\", "/", 0)

    textgrid_name$ = replace_regex$(textgrid_path$, "(.+)/(.+)", "\2", 1)
    sound_name$ = textgrid_name$ - textgrid_extension$ + sound_extension$

    if relative_path
        sound_path$ = textgrid_path$ + "/../" + sound_dir$ + "/" + sound_name$
    else
        sound_path$ = sound_dir$ + "/" + sound_name$
    endif

    textgrid_id = Read from file: textgrid_path$

    if fileReadable(sound_path$)
        # Open a Sound file from the list
        if adjust_volume
            sound_id = Read from file: sound_path$
            Scale peak: volume
        else
            sound_id = Open long sound file: sound_path$
        endif
        object_list# = {sound_id, textgrid_id}
    else
        object_list# = {textgrid_id}
    endif

    selectObject: object_list#
    if spelling_checker
        plusObject: object_list#, spelling_checker_id
    endif

    View & Edit
    editor: textgrid_id

    beginPause: "file browser"
        comment: "Case: 'file_number'/'nFiles'"
        natural: "Next file",  if (file_number + 1) > nFiles then 1 else file_number + 1 fi
        if adjust_volume
            real: "Volume", volume
        endif
    clicked_pause = endPause: "Save", "Jump", "Quit", button_choice
    endeditor

    button_choice = clicked_pause
    if clicked_pause = 1
        selectObject: textgrid_id
        Save as text file: textgrid_path$
    endif

    removeObject: object_list#
    file_number = next_file

    if clicked_pause = 3
        pause = 0
    endif
endwhile

if spelling_checker
    selectObject: spelling_checker_id
    Save as text file: spelling_checker_path$
endif

removeObject: main_objects#

include ../procedures/list_recursive_path.proc