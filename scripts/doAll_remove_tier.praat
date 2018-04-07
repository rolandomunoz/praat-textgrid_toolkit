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

@config.init: "../preferences.txt"
beginPause: "Remove tier (do all)"
  comment: "Input:"
  comment: "The directory where your TextGrid files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  comment: "Remove tiers..."
  sentence: "All tier names", ""
  comment: "Output:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", ""
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

@config.setField: "textgrid_dir", textgrid_folder$

str_tierList= Create Strings as tokens: all_tier_names$, " ,"
n_tierList= Get number of strings

fileList= Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
n_fileList= Get number of strings

modifiedCounter = 0
deletedFileCounter = 0
for iFile to n_fileList
  tg$= object$[fileList, iFile]
  tg= Read from file: textgrid_folder$ + "/" +tg$
  deleteFile= 0
  
  for iTierList to n_tierList
    str_tier$= object$[str_tierList, iTierList]
    nTiers= Get number of tiers
    for iTier to nTiers
      tg_tier$ = Get tier name: iTier
      if tg_tier$ = str_tier$
        if nTiers = 1
          deleteFile: save_in$ + "/" + tg$
          deleteFile= 1
          deletedFileCounter+=1
        else
          Remove tier: iTier
          modifiedCounter+=1
        endif
        iTier = nTiers
      endif
    endfor
  endfor
  
  if !deleteFile
    Save as text file: save_in$ + "/" + tg$
  endif
  removeObject: tg
endfor
removeObject: str_tierList, fileList
writeInfoLine: "Remove tiers"
appendInfoLine: "Number of files: ", n_fileList
appendInfoLine: "Number of modified TextGrids: ", modifiedCounter
appendInfoLine: "Number of deleted TextGrids: ", deletedFileCounter

if clicked
  runScript: "doAll_remove_tier.praat"
endif
