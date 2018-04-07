# Written by Rolando Muñoz A. (7 April 2018)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
include ../procedures/config.proc
include ../procedures/get_tier_number.proc

@config.init: "../preferences.txt"
beginPause: "Duplicate tier (do all)"
  comment: "Input:"
  comment: "The directory where your TextGrid files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  comment: "Duplicate tier..."
  word: "Tier name", ""
  word: "After tier", ""
  word: "New tier name", ""
  comment: "Output:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", ""
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

@config.setField: "textgrid_dir", textgrid_folder$

str_tierList= Create Strings as tokens: tier_name$, " ,"
n_tierList= Get number of strings

fileList= Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
n_fileList= Get number of strings

if tier_name$ == new_tier_name$
  new_tier_name$ = new_tier_name$ + ".dup"
endif

tierCounter = 0
getTierNumber.return[tier_name$]= 0
getTierNumber.return[after_tier$]= 0

for iFile to n_fileList
  tg$ = object$[fileList, iFile]
  tg = Read from file: textgrid_folder$ + "/" +tg$
  @getTierNumber
  tier= getTierNumber.return[tier_name$]
  position= getTierNumber.return[after_tier$] + 1
  
  if tier
    tierCounter+=1
    Duplicate tier: tier, position, new_tier_name$
    Save as text file: save_in$ + "/" + tg$
  endif
  removeObject: tg
endfor

removeObject: str_tierList, fileList
writeInfoLine: "Duplicate tier"
appendInfoLine: "Number of files: ", n_fileList
appendInfoLine: "Number of modified TextGrids: ", tierCounter

if clicked = 2
  runScript: "doAll_duplicate.praat"
endif
