# Written by Rolando Munoz A. (5 March 2019)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form Duplicate tier
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search 0
  comment Duplicate tier...
  word Tier_name
  word After_tier
  word New_tier_name
endform

# Check dialogue box
if tgFolder$ == ""
  writeInfoLine: "The field 'TextGrid folder' is empty."
  exitScript()
endif

# Find files
@createStringAsFileList: "file_list", tgFolder$ + "/*TextGrid", recursive_search
file_list= selected("Strings")
n_fileList= Get number of strings

# Do not duplicate tiers!
if tier_name$ == new_tier_name$
  new_tier_name$ = new_tier_name$ + ".dup"
endif

counter = 0

for iFile to n_fileList
  tg$ = object$[file_list, iFile]
  tg_full_path$ = tgFolder$ + "/" +tg$
  
  tg = Read from file: tg_full_path$
  @index_tiers
  @get_tier_position: tier_name$
  tier = get_tier_position.return
  @get_tier_position: after_tier$
  position = get_tier_position.return + 1
  
  if tier
    counter+=1
    Duplicate tier: tier, position, new_tier_name$
    Save as text file: tg_full_path$
  endif
  removeObject: tg
endfor

removeObject: file_list

# Print info
writeInfoLine: "Duplicate tier"
appendInfoLine: "Input:"
appendInfoLine: "  Tier name: ",  tier_name$
appendInfoLine: "  After tier: ", after_tier$
appendInfoLine: "  New tier name: ", new_tier_name$
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", n_fileList
appendInfoLine: "  Modified files (total): ", counter

include ../procedures/qtier.proc
include ../procedures/list_recursive_path.proc
