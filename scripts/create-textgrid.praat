# Written by Rolando Munoz A. (20 April 2018)
# Last Modified on 2023-02-13
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form Sound to TextGrid
  text Folder_with_sound_files /home/rolando/corpus
  boolean Recursive_search 0
  text Folder_with_annotation_files {sound_dir}
  comment To TextGrid...
  sentence All_tier_names Mary John bell
  sentence Which_of_these_are_point_tiers bell
endform

# Global variables
sound_extension$= ".wav"

# Rename variables
sound_dir$ = folder_with_sound_files$
textgrid_dir$ = folder_with_annotation_files$
textgrid_dir$ = replace$(textgrid_dir$, "{sound_dir}", sound_dir$, 0)

# Find directories
@createStringAsFileList: "fileList", sound_dir$ + "/*'sound_extension$'", recursive_search
fileList = selected("Strings")
n_fileList= Get number of strings

new_file_counter= 0

# Open each file
for i to n_fileList
  sound_path$ = sound_dir$ + "/" + object$[fileList, i]
  sound_basename$ = replace_regex$(sound_path$, ".*/", "", 1)
  stem$ =  sound_basename$ - sound_extension$
  textgrid_path$ = "'textgrid_dir$'/'stem$'.TextGrid"

  if not fileReadable(textgrid_path$)
    sound_id = Read from file: sound_path$
    textgrid_id = To TextGrid: all_tier_names$, which_of_these_are_point_tiers$
    Save as text file: textgrid_path$
    removeObject: sound_id, textgrid_id
    new_file_counter+=1
  endif
endfor
removeObject: fileList

# Print info
writeInfoLine: "Create TextGrid (from audio files)"
appendInfoLine: "Input:"
appendInfoLine: "  All tier names: ",  all_tier_names$
appendInfoLine: "  Which of these are point tiers: ", which_of_these_are_point_tiers$
appendInfoLine: "Ouput:"
appendInfoLine: "  New files (total): ", new_file_counter

include ../procedures/list_recursive_path.proc