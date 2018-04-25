# Written by Rolando Munoz A. (28 March 2018)
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
include ../procedures/list_recursive_path.proc

@config.init: "../preferences.txt"
beginPause: "Remove tier (do all)"
  comment: "The directory where your TextGrid files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  boolean: "Recursive search", number(config.init.return$["remove_tier.recursive_search"])
  comment: "Remove tiers..."
  word: "Tier name", config.init.return$["remove_tier.all_tier_names"]
  comment: "If remove all tiers, then DELETE TextGrid?"
  boolean: "Yes", number(config.init.return$["remove_tier.delete_textgrid"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

str_tier$ = tier_name$

# Save the values from the dialogue box
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "remove_tier.all_tier_names", tier_name$
@config.setField: "remove_tier.recursive_search", string$(recursive_search)

# Check dialogue box
if textgrid_folder$ == ""
  pauseScript: "The field 'Textgrid folder' is empty. Please complete it"
  runScript: "doAll_remove_tier.praat"
  exitScript()
endif

# Find directories
if recursive_search
  @findFiles: textgrid_folder$, "/*.TextGrid"
  fileList= selected("Strings")
else
  fileList= Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
endif
n_fileList= Get number of strings

modifiedCounter = 0
deletedFileCounter = 0

for iFile to n_fileList
  tgPath$ = textgrid_folder$ + "/" + object$[fileList, iFile]
  tg = Read from file: tgPath$
  nTiers= Get number of tiers

  saveFile= 0

  for iTier to nTiers
    tg_tier$ = Get tier name: iTier
    if tg_tier$ = str_tier$
      if nTiers = 1
        saveFile= 0
        if yes
          deleteFile: tgPath$
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
    Save as text file: tgPath$
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

if clicked
  runScript: "doAll_remove_tier.praat"
endif
