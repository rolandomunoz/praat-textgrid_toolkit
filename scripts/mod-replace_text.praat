# Written by Rolando Munoz A. (2018-2020)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#

form Replace tier text
  comment Folder with annotation files:
  text tgFolderPath /home/rolando/corpus
  boolean Recursive_search 0
  comment Replace text...
  word Tier_name phrase
  sentence Search a
  sentence Replace a
  optionmenu Mode 1
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
    option Literals
    option Matches (regex)
endform

@createStringAsFileList: "fileList", tgFolderPath$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

mode$= if mode = 1 then "Literals" else "Regular Expressions" fi
mode_mod$= if mode = 1 then "contains" else "matches (regex)" fi
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

counter = 0
missing_tier_list$ = ""
missing_tier_list = 0

for iFile to n_fileList
  tg$ = object$[fileList, iFile]
  tg_full_path$ = tgFolderPath$ + "/" +tg$
  
  tg = Read from file: tg_full_path$
  @index_tiers
  @get_tier_position: tier_name$
  tier = get_tier_position.return
  
  if tier
    @count_item_where: tier, mode_mod$, search$
    is_text = count_item_where.return
    if is_text
      counter+=1
      @replace_item_texts: tier, 1, 0, search$, replace$, mode$
      Save as text file: tg_full_path$
    endif
  else
    missing_tier_list += 1
    missing_tier_list$ += tg_full_path$ + newline$
  endif
  removeObject: tg
endfor

removeObject: fileList

# Print info
writeInfoLine: "Replace tier name"
appendInfoLine: "Input:"
appendInfoLine: "  Tier name: ", tier_name$
appendInfoLine: "  Search: ", search$
appendInfoLine: "  Replace: ", replace$
appendInfoLine: "  Mode: ", mode$
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", n_fileList
appendInfoLine: "  Modified files (total): ", counter

if not missing_tier_list$ == ""
  message1$ = "'newline$'WARNING: TextGrid files does not contain the tier ""'tier_name$'"""
  message2$ = "'newline$'WARNING: The tier ""'tier_name$'"" was not found in 'missing_tier_list' TextGrid files. 'newline$''newline$''missing_tier_list$'"
  
  info$ = if missing_tier_list == n_fileList then message1$ else message2$ fi
  appendInfo: info$ 
endif

include ../procedures/qtier.proc
include ../procedures/intervalpoint.proc
include ../procedures/list_recursive_path.proc
