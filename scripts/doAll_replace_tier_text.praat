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
beginPause: "Replace tier text (do all)"
  comment: "Input:"
  comment: "The directory where your TextGrid files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  comment: "Replace text..."
  word: "Tier name", ""
  sentence: "Search", ""
  sentence: "Replace", ""
  optionMenu: "Mode", 1
#    option: "is equal to"
#    option: "is not equal to"
#    option: "contains"
#    option: "does not contain"
#    option: "starts with"
#    option: "does not start with"
#    option: "ends with"
#    option: "does not end with"
#    option: "contains a word equal to"
#    option: "does not contain a word equal to"
#    option: "contains a word starting with"
    option: "Literals"
    option: "Matches (regex)"
  comment: "Output:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", ""
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked=1
  exitScript()
endif

@config.setField: "textgrid_dir", textgrid_folder$

str_tierList= Create Strings as tokens: tier_name$, " ,"
n_tierList= Get number of strings

fileList= Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
n_fileList= Get number of strings

mode$= if mode = 1 then "Literals" else "Regular Expressions" fi

# mode$ = "Regular Expressions"
# if mode = 1
#   replace$= replace$
# elsif mode = 2
#   replace$= replace$
# elsif mode = 3
#   replace$= replace$
#   mode$ = "Literals"
# elsif mode = 4
#   replace$= replace$
# elsif mode = 5
#   replace$= replace$
# elsif mode = 6
#   replace$= replace$
# elsif mode = 7
#   replace$= replace$
# elsif mode = 8
#   replace$= replace$
# elsif mode = 9
#   replace$= replace$
# elsif mode = 10
#   replace$= replace$
# elsif mode = 11
#   replace$= replace$
# elsif mode = 12
#   replace$= replace$
# elsif mode = 13
#   replace$= replace$
# endif

tierCounter = 0
getTierNumber.return[tier_name$]= 0

for iFile to n_fileList
  tg$ = object$[fileList, iFile]
  tg = Read from file: textgrid_folder$ + "/" +tg$
  @getTierNumber
  tier= getTierNumber.return[tier_name$]
  
  if tier
    tierCounter+=1
    isInterval= Is interval tier: tier
    if isInterval
      Replace interval text: tier, 0, 0, search$, replace$, mode$
    else
      Replace point text: tier, 0, 0, search$, replace$, mode$
    endif
    Save as text file: save_in$ + "/" + tg$
  endif
  removeObject: tg
endfor

removeObject: str_tierList, fileList
writeInfoLine: "Replace tier name"
appendInfoLine: "Number of files: ", n_fileList
appendInfoLine: "Number of modified TextGrids: ", tierCounter

if clicked=2
  runScript: "doAll_replace_tier_text.praat"
endif
