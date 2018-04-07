# Written by Rolando Muñoz A. (28 March 2018)
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
beginPause: "Rename tier (do all)"
  comment: "Input:"
  comment: "The directory where your TextGrid files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  comment: "Rename tier(s)..."
  sentence: "Tier name", ""
  word: "Rename as", ""
  comment: "Output:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", ""
clicked = endPause: "Continue", "Quit", 1

if clicked=2
  exitScript()
endif

@config.setField: "textgrid_dir", textgrid_folder$

str_tierList= Create Strings as tokens: tier_name$, " ,"
n_tierList= Get number of strings

fileList= Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
n_fileList= Get number of strings

tierCounter = 0
fileCounter = 0
for iFile to n_fileList
  for j to n_tierList
    str_tier$ = object$[str_tierList, j]
    getTierNumber.return[str_tier$]= 0
  endfor
  
  tg$ = object$[fileList, iFile]
  tg = Read from file: textgrid_folder$ + "/" +tg$
  @getTierNumber
  
  for j to n_tierList
    str_tier$ = object$[str_tierList, j]
    tier= getTierNumber.return[str_tier$]
    if tier
      tierCounter+=1
      Set tier name: tier, rename_as$
    endif
  endfor
  Save as text file: save_in$ + "/" + tg$
  removeObject: tg
endfor

removeObject: str_tierList, fileList
writeInfoLine: "Rename tiers..."
appendInfoLine: "Number of modified tiers: ", tierCounter

