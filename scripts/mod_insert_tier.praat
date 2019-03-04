# Written by Rolando Munoz A. (04 March 2019)
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

form Insert tier
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search 0
  comment Insert tier...
  sentence All_tier_names Mary John bell
  sentence Which_of_these_are_point_tiers bell
endform

# Check dialogue box
if tgFolder$ == ""
  writeInfoLine: "The field 'TextGrid folder' is empty."
  exitScript()
elsif all_tier_names$ == ""
  writeInfoLine: "The field 'All tier names' is empty."
  exitScript()
endif

# Find directories
@createStringAsFileList: "fileList", tgFolder$ + "/*TextGrid", recursive_search

fileList= selected("Strings")
n_fileList= Get number of strings

modifiedFileCounter = 0

# Open each file
for i to n_fileList
  tgPath$ = tgFolder$ + "/" + object$[fileList, i]
  if fileReadable(tgPath$)
    tg = Read from file: tgPath$
    modifiedFileCounter+=1
    runScript: "_add_tiers.praat", all_tier_names$, which_of_these_are_point_tiers$
    Save as text file: tgPath$
    removeObject: tg
  endif
endfor
removeObject: fileList

# Print info
writeInfoLine: "Add tier"
appendInfoLine: "Input:"
appendInfoLine: "  All tier names: ", all_tier_names$
appendInfoLine: "  Which of these are point tiers: ", which_of_these_are_point_tiers$
appendInfoLine: "Ouput:"
appendInfoLine: "  Files (total): ", modifiedFileCounter
# appendInfoLine: "  Modfied files (total): ", modifiedFileCounter
