# Written by Rolando Munoz A. (20 April 2018)
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
beginPause: "Create TextGrid (from audio files) (do all)"
  comment: "The directories where your files are stored..."
  sentence: "Audio folder", config.init.return$["audio_dir"]
  sentence: "Textgrid folder", config.init.return$["insert_tier.recursive_search.textgrid_dir"]
  boolean: "Recursive search", number(config.init.return$["insert_tier.recursive_search"])
  comment: "To TextGrid..."
  sentence: "All tier names", config.init.return$["insert_tier.all_tier_names"]
  sentence: "Which of these are point tiers", config.init.return$["insert_tier.point_tiers"]
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save the values from the dialogue box
@config.setField: "audio_dir", audio_folder$
@config.setField: "create_textgrid.recursive_search.textgrid_dir", textgrid_folder$
@config.setField: "create_textgrid.all_tier_names", all_tier_names$
@config.setField: "create_textgrid.point_tiers", which_of_these_are_point_tiers$
@config.setField: "create_textgrid.recursive_search", string$(recursive_search)

audio_extension$= config.init.return$["audio_extension"]
textgrid_folder$ = if textgrid_folder$ == "" then "." else textgrid_folder$ fi
relative_path = if startsWith(textgrid_folder$, ".") then  1 else 0 fi

# Check dialogue box
if all_tier_names$ == ""
  pauseScript: "The field 'All tier names' is empty. Please complete it."
  runScript: "doAll_insert_tier.praat"
  exitScript()
endif

# Find directories
if recursive_search
  @findFiles: audio_folder$, "/*'audio_extension$'"
  fileList= selected("Strings")
else
  fileList= Create Strings as file list: "fileList", audio_folder$ + "/*'audio_extension$'"
endif
n_fileList= Get number of strings

newFileCounter= 0

# Open each file
for i to n_fileList
  sdPath$ = audio_folder$ + "/" + object$[fileList, i]
  sd$ = replace_regex$(sdPath$, ".*/", "", 1)
  basename$ =  sd$ - audio_extension$

  if relative_path
    tgPath$ = sdPath$ - sd$ + "/" + textgrid_folder$ + "/" + basename$ + ".TextGrid"
  else
    tgPath$ = textgrid_folder$ + "/" + basename$ + ".TextGrid"
  endif
  
  if not fileReadable(tgPath$)
    sd = Read from file: sdPath$
    tg = To TextGrid: all_tier_names$, which_of_these_are_point_tiers$
    Save as text file: tgPath$
    removeObject: tg, sd
    newFileCounter+=1
  endif
endfor
removeObject: fileList

writeInfoLine: "Create TextGrid (from audio files)..."
appendInfoLine: "Number of new files: ", newFileCounter

if clicked = 2
  runScript: "doAll_create_textgrid.praat"
endif