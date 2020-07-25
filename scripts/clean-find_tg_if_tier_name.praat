# Written by Rolando Munoz Aramburu (2019)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form Find TextGrid files if tier name
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search 0
  comment TextGrids
  optionmenu Find_TextGrid_which 1
  option contains
  option does not contain
  sentence All_tier_names word phrase
#  sentence Which_of_these_are_point_tiers?
endform

tb= Create Table with column names: "fileList", 0, "filename"

# Check dialogue box
tierList = Create Strings as tokens: all_tier_names$, " "
nSearchTier = Get number of strings
Sort
wordListTier = To WordList

# Find files
@createStringAsFileList: "fileList", tgFolder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
nList = Get number of strings

for iFile to nList
  tgName$ = object$[fileList, iFile]
  tgPath$ = tgFolder$ + "/" + tgName$
  tg = Read from file: tgPath$
  nTgTiers = Get number of tiers
  tierCounter = 0

  for i_tier to nTgTiers
    selectObject: tg
    tier_name$ = Get tier name: i_tier
    
    selectObject: wordListTier
    isTier = Has word: tier_name$
    tierCounter = if isTier then tierCounter + 1 else tierCounter fi
  endfor

  selectObject: tb
  
  if find_TextGrid_which == 1
    if nSearchTier == tierCounter
      Append row
      row = object[tb].nrow
      Set string value: row, "filename", tgPath$
    endif
  elsif find_TextGrid_which == 2
    if nSearchTier > tierCounter
      Append row
      row = object[tb].nrow
      Set string value: row, "filename", tgPath$
    endif
  endif
  removeObject: tg
endfor
removeObject: fileList, wordListTier, tierList

include ../procedures/list_recursive_path.proc
