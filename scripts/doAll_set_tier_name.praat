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
include ../procedures/get_tier_number.proc
include ../procedures/list_recursive_path.proc

@config.init: "../preferences.txt"
beginPause: "Set tier name (do all)"
  comment: "The directory where your TextGrid files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  boolean: "Recursive search", number(config.init.return$["set_tier_name.recursive_search"])
  comment: "Set tier(s)..."
  sentence: "Tier name", config.init.return$["set_tier_name.tier_name"]
  word: "New name", config.init.return$["set_tier_name.new_name"]
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save the values from the dialogue box
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "set_tier_name.tier_name", tier_name$
@config.setField: "set_tier_name.new_name", new_name$
@config.setField: "set_tier_name.recursive_search", string$(recursive_search)

# Check dialogue box
if textgrid_folder$ == ""
  pauseScript: "The field 'Textgrid folder' is empty. Please complete it"
  runScript: "doAll_set_tier_name.praat"
  exitScript()
endif

str_tierList= Create Strings as tokens: tier_name$, " ,"
n_tierList= Get number of strings


@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

counter = 0
for iFile to n_fileList
  for j to n_tierList
    str_tier$ = object$[str_tierList, j]
    getTierNumber.return[str_tier$]= 0
  endfor
  
  tg$ = object$[fileList, iFile]
  tg = Read from file: textgrid_folder$ + "/" +tg$
  @getTierNumber
  
  for j to n_tierList
    str_tier$ = object$[str_tierList, j]
    tier= getTierNumber.return[str_tier$]
    if tier
      counter+=1
      Set tier name: tier, new_name$
      Save as text file: textgrid_folder$ + "/" + tg$
      j = n_tierList
    endif
  endfor
  removeObject: tg
endfor

removeObject: str_tierList, fileList

# Print info
writeInfoLine: "Set tier name"
appendInfoLine: "Input:"
appendInfoLine: "  Tier name: ",  tier_name$
appendInfoLine: "  New name: ",  new_name$
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", n_fileList
appendInfoLine: "  Modified files (total): ", counter

if clicked = 2
  runScript: "doAll_set_tier_name.praat"
endif
