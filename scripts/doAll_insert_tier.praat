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
beginPause: "Insert tier (do all)"
  comment: "The directories where your files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  boolean: "Recursive search", number(config.init.return$["insert_tier.recursive_search"])
  comment: "Insert tier..."
  sentence: "All tier names", config.init.return$["insert_tier.all_tier_names"]
  sentence: "Which of these are point tiers", config.init.return$["insert_tier.point_tiers"]
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save the values from the dialogue box
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "insert_tier.all_tier_names", all_tier_names$
@config.setField: "insert_tier.point_tiers", which_of_these_are_point_tiers$
@config.setField: "insert_tier.recursive_search", string$(recursive_search)

# Check dialogue box
if textgrid_folder$ == ""
  pauseScript: "The field 'TextGrid folder' is empty. Please complete it"
  runScript: "doAll_insert_tier.praat"
  exitScript()
elsif
  pauseScript: "The field 'All tier names' is empty. Please complete it"
  runScript: "doAll_insert_tier.praat"
  exitScript()
endif

# Find directories
if recursive_search
  @findFiles: textgrid_folder$, "/*.TextGrid"
  fileList= selected("Strings")
else
  fileList= Create Strings as file list: "fileList", audio_folder$ + "/*.'audio_extension$'"
endif
n_fileList= Get number of strings

modifiedFileCounter = 0

# Open each file
for i to n_fileList
  tgPath$ = textgrid_folder$ + "/" + object$[fileList, i]
  
  if fileReadable(tgPath$)
    tg = Read from file: tgPath$
    modifiedFileCounter+=1
    runScript: "add_tiers.praat", all_tier_names$, which_of_these_are_point_tiers$
    Save as text file: tgPath$
    removeObject: tg
  endif
endfor
removeObject: fileList

writeInfoLine: "Add tier..."
appendInfoLine: "Number of modified files: ", modifiedFileCounter

if clicked = 2
  runScript: "doAll_insert_tier.praat"
endif