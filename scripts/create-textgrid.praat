# Written by Rolando Munoz A. (20 April 2018)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
include ../procedures/list_recursive_path.proc

form Sound to TextGrid
  comment Folder with sound files:
  text sd_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment Folder with annotation files:
  text tg_folder .
  #(= relative path to sound files)
  comment To TextGrid...
  sentence All_tier_names Mary John bell
  sentence Which_of_these_are_point_tiers bell
endform

sound_extension$= ".wav"
tg_folder$ = if tg_folder$ == "" then "." else tg_folder$ fi
relative_path = if startsWith(tg_folder$, ".") then  1 else 0 fi

# Find directories
@createStringAsFileList: "fileList", sd_folder$ + "/*'sound_extension$'", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings
pauseScript()
newFileCounter= 0

# Open each file
for i to n_fileList
  sdPath$ = sd_folder$ + "/" + object$[fileList, i]
  sd$ = replace_regex$(sdPath$, ".*/", "", 1)
  basename$ =  sd$ - sound_extension$

  if relative_path
    tgPath$ = sdPath$ - sd$ + "/" + tg_folder$ + "/" + basename$ + ".TextGrid"
  else
    tgPath$ = tg_folder$ + "/" + basename$ + ".TextGrid"
  endif
  
  if not fileReadable(tgPath$)
    sd = Read from file: sdPath$
    tg = To TextGrid: all_tier_names$, which_of_these_are_point_tiers$
    Save as text file: tgPath$
    removeObject: tg, sd
    newFileCounter+=1
  endif
endfor
removeObject: fileList

# Print info
writeInfoLine: "Create TextGrid (from audio files)"
appendInfoLine: "Input:"
appendInfoLine: "  All tier names: ",  all_tier_names$
appendInfoLine: "  Which of these are point tiers: ", which_of_these_are_point_tiers$
appendInfoLine: "Ouput:"
appendInfoLine: "  New files (total): ", newFileCounter