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

@config.init: "../preferences.txt"
beginPause: "Remove tier (do all)"
  comment: "The directory where your TextGrid files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  comment: "Remove tiers..."
  sentence: "All tier names", config.init.return$["remove_tier.all_tier_names"]
  comment: "If remove all tiers, then DELETE TextGrid?"
  boolean: "Yes", number(config.init.return$["remove_tier.delete_textgrid"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save the values from the dialogue box
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "remove_tier.all_tier_names", all_tier_names$

# Check dialogue box
if textgrid_folder$ == ""
  pauseScript: "The field 'Textgrid folder' is empty. Please complete it"
  runScript: "doAll_remove_tier.praat"
  exitScript()
endif

str_tierList= Create Strings as tokens: all_tier_names$, " ,"
n_tierList= Get number of strings

fileList= Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
n_fileList= Get number of strings

modifiedCounter = 0
deletedFileCounter = 0

for iFile to n_fileList
  tg$ = object$[fileList, iFile]
  tg = Read from file: textgrid_folder$ + "/" +tg$
  saveFile= 0
  
  for iTierList to n_tierList
    nTiers= Get number of tiers
    str_tier$= object$[str_tierList, iTierList]
    
    for iTier to nTiers
      tg_tier$ = Get tier name: iTier
      if tg_tier$ = str_tier$
        if nTiers = 1
          saveFile= 0
          if yes
            deleteFile: textgrid_folder$ + "/" + tg$
            deletedFileCounter+=1
          endif
        else
          saveFile= 1
          Remove tier: iTier
        endif
        iTier = nTiers
      endif
    endfor
  endfor
  
  if saveFile
    modifiedCounter+=1
    Save as text file: textgrid_folder$ + "/" + tg$
  endif
  removeObject: tg
endfor
removeObject: str_tierList, fileList
writeInfoLine: "Remove tiers..."
appendInfoLine: "Number of files: ", n_fileList
appendInfoLine: "Number of modified files: ", modifiedCounter
appendInfoLine: "Number of deleted files: ", deletedFileCounter

if clicked
  runScript: "doAll_remove_tier.praat"
endif
