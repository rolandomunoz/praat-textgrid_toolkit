# Written by Rolando Munoz A. (8 October 2018)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
include ../procedures/get_tier_number.proc
include ../procedures/list_recursive_path.proc

form Replace text (dictionary)
  comment Replace dictionary (csv):
  text Dictionary_path ../temp/dictionary.csv
  word Search_column search
  word Replace_column replace
  comment Folder with annotation files:
  text tg_folder_path /home/user/Desktop/corpus
  boolean Recursive_search 0
  comment TextGrid Object:
  word Tier_name phrase
endform

# Check table
dictionary = Read Table from comma-separated file: dictionary_path$
searchColumn = Get column index: search_column$
replaceColumn = Get column index: replace_column$
if not searchColumn or not replaceColumn
  writeInfoLine: "Sorry, column names could not be found. Try again!"
  exitScript()
endif

# Open TextGrids one by one
@createStringAsFileList: "fileList",  tg_folder_path$ + "/*.TextGrid", recursive_search
fileList = selected("Strings")
nFiles = Get number of strings

counter = 0

for iFile to nFiles
  save = 0
  tg$ = object$[fileList, iFile]
  tg = Read from file: tg_folder_path$ + "/" +tg$
  getTierNumber.return[tier_name$]= 0
  @getTierNumber
  tier= getTierNumber.return[tier_name$]
  
  if tier
    replaceTier = tier + 1
    Duplicate tier: tier, replaceTier, replace_column$
    isInterval = Is interval tier: replaceTier
    type$ = if isInterval then "interval" else "point" fi
    nTypes = do("Get number of 'type$'s...", replaceTier)
    for iType to nTypes
      selectObject: tg
      label$ = do$("Get label of 'type$'...", replaceTier, iType)
      if label$ <> ""
        selectObject: dictionary 
        isWord = Search column: search_column$, label$
        save = 1
        if isWord
          selectObject: tg
          row = isWord
          do("Set 'type$' text...", replaceTier, iType, object$[dictionary, row, replace_column$])
        else
          selectObject: tg
          do("Set 'type$' text...", replaceTier, iType, "*'label$'")
        endif
      endif
    endfor
    
    if save
      counter += 1
      Save as text file: tg_folder_path$ + "/" + tg$
    endif
  endif
  removeObject: tg
endfor

selectObject: dictionary

Set column label (label): search_column$, "search"
Set column label (label): replace_column$, "replace"
Save as comma-separated file: "../temp/dictionary.csv"

removeObject: fileList, dictionary

# Print info
writeInfoLine: "Replace tier name"
appendInfoLine: "Input:"
appendInfoLine: "  Tier name: ", tier_name$
appendInfoLine: "  Search column: ", search_column$
appendInfoLine: "  Replace column: ", replace_column$
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", nFiles
appendInfoLine: "  Modified files (total): ", counter
