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
  comment: "The directories where your files are stored..."
  sentence: "Audio folder", config.init.return$["audio_dir"]
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  comment: "Insert tier..."
  sentence: "All tier names", config.init.return$["insert_tier.all_tier_names"]
  sentence: "Which of these are point tiers", config.init.return$["insert_tier.point_tiers"]
  comment: "CREATE a TextGrid if not found?"
  boolean: "Yes", number(config.init.return$["insert_tier.create_textgrid"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

audio_extension$= config.init.return$["audio_extension"]

# Save the values from the dialogue box
@config.setField: "audio_dir", audio_folder$
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "insert_tier.all_tier_names", all_tier_names$
@config.setField: "insert_tier.point_tiers", which_of_these_are_point_tiers$
@config.setField: "insert_tier.create_textgrid", string$(yes)

# Check dialogue box
if textgrid_folder$ == ""
  pauseScript: "The field 'Textgrid folder' is empty. Please complete it"
  runScript: "doAll_insert_tier.praat"
  exitScript()
elsif all_tier_names$ == ""
  pauseScript: "The field 'All tier names' is empty. Please complete it"
  runScript: "doAll_insert_tier.praat"
  exitScript()
endif

fileList= Create Strings as file list: "fileList", audio_folder$ + "/*" + audio_extension$
n_fileList= Get number of strings

newFileCounter= 0
modifiedFileCounter = 0
for i to n_fileList
  sd$= object$[fileList, i]
  tg$= sd$ - audio_extension$ + ".TextGrid"
  if fileReadable(textgrid_folder$ + "/" +tg$)
    modifiedFileCounter+=1
    tg= Read from file: textgrid_folder$ + "/" +tg$
    runScript: "add_tiers.praat", all_tier_names$, which_of_these_are_point_tiers$
    Save as text file: textgrid_folder$ + "/" + tg$
    removeObject: tg
  else
    if yes
      newFileCounter+=1
      sd = Open long sound file: audio_folder$ + "/" +sd$
      tg = To TextGrid: all_tier_names$, which_of_these_are_point_tiers$
      Save as text file: textgrid_folder$ + "/" + tg$
      removeObject: sd, tg
    endif
  endif
endfor
removeObject: fileList

writeInfoLine: "Add tier..."
appendInfoLine: "Number of modified files: ", modifiedFileCounter
appendInfoLine: "Number of new files: ", newFileCounter

if clicked = 2
  runScript: "doAll_insert_tier.praat"
endif