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
beginPause: "Insert tier (do all)"
  comment: "Input:"
  comment: "The directories where your files are stored..."
  sentence: "Audio folder", config.init.return$["audio_dir"]
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  comment: "Insert tier..."
  sentence: "All tier names", config.init.return$["all_tier_names"]
  sentence: "Which of these are point tiers", config.init.return$["point_tiers"]
  comment: "Search INSIDE TextGrids?"
  boolean: "Yes", number(config.init.return$["deep_search"])
  comment: "Output:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", ""
clicked = endPause: "Continue", "Quit", 1

if clicked=2
  exitScript()
endif

@config.setField: "audio_dir", audio_folder$
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "all_tier_names", all_tier_names$
@config.setField: "point_tiers", which_of_these_are_point_tiers$

audio_extension$= config.init.return$["audio_extension"]

fileList= Create Strings as file list: "fileList", audio_folder$ + "/*" + audio_extension$
n_fileList= Get number of strings

newFileCounter= 0
modifiedFileCounter = 0
for i to n_fileList
  sd$= object$[fileList, i]
  tg$= sd$ - audio_extension$ + ".TextGrid"
  if fileReadable(textgrid_folder$ + "/" +tg$)
    tg= Read from file: textgrid_folder$ + "/" +tg$
    if yes
      modifiedFileCounter+=1
      runScript: "add_tiers.praat", all_tier_names$, which_of_these_are_point_tiers$
    endif
  else
    newFileCounter+=1
    sd = Open long sound file: audio_folder$ + "/" +sd$
    tg = To TextGrid: all_tier_names$, which_of_these_are_point_tiers$
    removeObject: sd
  endif
  selectObject: tg
  Save as text file: save_in$ + "/" + tg$

  removeObject: tg
endfor
removeObject: fileList

writeInfoLine: "Add tier"
appendInfoLine: "Number of modified TextGrids: ", modifiedFileCounter
appendInfoLine: "Number of created TextGrids: ", newFileCounter
