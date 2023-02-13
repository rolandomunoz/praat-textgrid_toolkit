# Written by Rolando Munoz A. (2018-2019)"
# Modified on 2023-02-13
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form Sound to TextGrid (silences)
    text Folder_with_sound_files /home/rolando/corpus
    boolean Recursive_search 0
    text Folder_with_annotation_files {sound_dir}
    comment To TextGrid (silences)...
    comment Parameters for the intensity analysis
    real Minimum_pitch_(Hz) 100
    real Time_step_(s) 0.0
    comment Silent intervals detection
    real Silence_threshold_(dB) -25.0
    real Minimum_silent_interval_duration_(s) 0.1
    real Minimum_sounding_interval_duration_(s) 0.1
    word Silent_interval_label silent
    word Sounding_interval_label sounding
endform

sound_dir$ = folder_with_sound_files$
textgrid_dir$ = folder_with_annotation_files$
textgrid_dir$ = replace$(textgrid_dir$, "{sound_dir}", sound_dir$, 0)
audio_extension$= ".wav"

# Find directories
@createStringAsFileList: "file_list", "'sound_dir$'/*'audio_extension$'", recursive_search
file_list= selected("Strings")
n_file_list= Get number of strings

new_file_counter= 0

# Open each file
for i to n_file_list
    sound_path$ = sound_dir$ + "/" + object$[file_list, i]
    sound_basename$ = replace_regex$(sound_path$, ".*/", "", 1)
    stem$ =  sound_basename$ - audio_extension$

    textgrid_path$ = textgrid_dir$ + "/" + stem$ + ".TextGrid"
    
    if not fileReadable(textgrid_path$)
        sound_id = Read from file: sound_path$
        textgrid_id = To TextGrid (silences): minimum_pitch, time_step, silence_threshold, minimum_silent_interval_duration, minimum_sounding_interval_duration, silent_interval_label$, sounding_interval_label$

        Save as text file: textgrid_path$
        removeObject: textgrid_id, sound_id
        new_file_counter+=1
    endif
endfor
removeObject: file_list

writeInfoLine: "Create TextGrid (silences)"
appendInfoLine: "Output"
appendInfoLine: "  New files (total): ", new_file_counter

include ../procedures/list_recursive_path.proc