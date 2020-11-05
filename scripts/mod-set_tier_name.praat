# Written by Rolando Munoz A. (05 March 2019)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#

form Set tier name
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search 0
  comment Set tier(s)...
  sentence Tier_name
  word New_name
endform

# Check dialogue box
if tgFolder$ == ""
  writeInfoLine: "The field 'TextGrid folder' is empty."
  exitScript()
endif

@createStringAsFileList: "fileList", tgFolder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

counter = 0
for iFile to n_fileList
  tg$ = object$[fileList, iFile]
  tgFullPath$ = tgFolder$ + "/" +tg$

  tg= Read from file: tgFullPath$
  @index_tiers
  @get_tier_position: tier_name$
  tier = get_tier_position.return
  
  if tier
    counter+=1
    Set tier name: tier, new_name$
    Save as text file: tgFullPath$
  endif
  removeObject: tg
endfor

removeObject: fileList

# Print info
writeInfoLine: "Set tier name"
appendInfoLine: "Input:"
appendInfoLine: "  Tier name: ",  tier_name$
appendInfoLine: "  New name: ",  new_name$
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", n_fileList
appendInfoLine: "  Modified files (total): ", counter

include ../procedures/qtier.proc
include ../procedures/list_recursive_path.proc
