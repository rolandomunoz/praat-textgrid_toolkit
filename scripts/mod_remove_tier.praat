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
include ../procedures/list_recursive_path.proc

form Remove tier
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search 0
  comment Remove tiers...
  word Tier_name
  comment If remove all tiers, then DELETE TextGrid?
  boolean Yes 0
endform

str_tier$ = tier_name$

# Check dialogue box
if tgFolder$ == ""
  writeInfoLine: "The field 'TextGrid folder' is empty."
  exitScript()
endif

# Find directories
@createStringAsFileList: "fileList", tgFolder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

modifiedCounter = 0
deletedFileCounter = 0

for iFile to n_fileList
  tg$ = object$[fileList, iFile]
  tgFullPath$ = tgFolder$ + "/" +tg$

  tg = Read from file: tgFullPath$
  nTiers= Get number of tiers

  saveFile= 0

  for iTier to nTiers
    tg_tier$ = Get tier name: iTier
    if tg_tier$ = str_tier$
      if nTiers = 1
        saveFile= 0
        if yes
          deleteFile: tgFullPath$
          deletedFileCounter+=1
        endif
      else
        saveFile= 1
        Remove tier: iTier
      endif
      iTier = nTiers
    endif
  endfor
  
  if saveFile
    modifiedCounter+=1
    Save as text file: tgFullPath$
  endif
  removeObject: tg
endfor
removeObject: fileList

# Print info
writeInfoLine: "Remove tiers"
appendInfoLine: "Input:"
appendInfoLine: "  Tier name: ",  tier_name$
appendInfoLine: "  Delete TextGrid: ", if yes then "yes" else "no" fi
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", n_fileList
appendInfoLine: "  Modified files (total): ", modifiedCounter
appendInfoLine: "  Deleted files (total): ", deletedFileCounter
