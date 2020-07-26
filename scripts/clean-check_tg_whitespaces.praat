# Open one by one, all the audio files and their TextGrids in the specified directory
#
# Written by Rolando Munoz Aramburu (2020)
# 
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

form Check whitespaces
  comment Folder with annotation files:
  text Textgrid_folder /home/rolando/corpus
  boolean Recursive_search 0
  optionmenu Mode 1
  option Only summary
  option Create a report Table
  option Remove whitespaces
endform

if mode == 3
  beginPause: "Remove whitespaces"
  comment: "Do you want to keep 1 space character between words?"
  boolean: "Yes", 1
  clicked = endPause: "Cancel", "Ok", 2
  if clicked == 1
    exitScript()
  else
    keep_one_space_characters = yes
  endif
endif

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

# Objects
if mode == 2
  tb = Create Table with column names: "whitespaces", 0, "error error_id tier_name tier filename"
endif

# Variables
number_of_errors = 7
row = 0
count_mod = 0

error_name$[1] = "Horizontal tabs"
error_name$[2] = "Vertical tabs"
error_name$[3] = "New line"
error_name$[4] = "Only space characters"
error_name$[5] = "Space character at the end"
error_name$[6] = "Space character at the start"
error_name$[7] = "More than two space characters together"

error_pattern$[1] = "\t"
error_pattern$[2] = "\v"
error_pattern$[3] = "\n"
error_pattern$[4] = "^ +$"
error_pattern$[5] = " +$"
error_pattern$[6] = "^ +"
error_pattern$[7] = "  +"

if mode == 3
  error_replace$[1] = " "
  error_replace$[2] = " "
  error_replace$[3] = " "
  error_replace$[4] = ""
  error_replace$[5] = ""
  error_replace$[6] = ""
  error_replace$[7] = if keep_one_space_characters then " " else "" fi
endif

## Initialize variables
for i_error to number_of_errors
  total_errors[i_error] = 0
endfor

# Open one-by-one all the TextGrids
for i to n_fileList
  # Read all the tiers from the TextGrid
  tg$ = object$[fileList, i]
  basename$ = replace_regex$(tg$, "(.+/)(.+)", "\2", 0)
  tg_path$ = textgrid_folder$ + "/" + tg$
  tg = Read from file: tg_path$
  n_tiers = Get number of tiers
  save_tg = 0
  for i_tier to n_tiers
    selectObject: tg
    tier_name$ = Get tier name: i_tier
    
    for i_error to number_of_errors
      @count_item_where: i_tier, "matches (regex)", error_pattern$[i_error]
      current_error[i_error] = count_item_where.return
      total_errors[i_error] += current_error[i_error]
      if current_error[i_error] > 0
        if mode == 2
          selectObject: tb
          Append row
          row+= 1
          Set string value: row, "error", error_name$[i_error]
          Set string value: row, "tier_name", tier_name$
          Set numeric value: row, "tier", i_tier
          Set numeric value: row, "error_id", i_error
          Set string value: row, "filename", tg_path$
        endif
        
        selectObject: tg
        if mode == 3
          @replace_item_texts: i_tier, 1, 0, error_pattern$[i_error], error_replace$[i_error], "Regular Expressions"
          save_tg = 1
        endif
      endif
    endfor
  endfor
  if save_tg
    Save as text file: tg_path$
    count_mod +=1
  endif
  removeObject: tg
endfor
removeObject: fileList

if mode == 1
  writeInfoLine: "Check whitespaces'newline$'_______________________Summary_______________________________'newline$'"
  error_count = 0
  for i_error to number_of_errors
    if total_errors[i_error] > 0
      appendInfoLine: error_name$[i_error], ": ", total_errors[i_error]
      error_count+=1
    endif
  endfor
  if error_count == 0
    appendInfoLine: "Everything is ok!"
  endif
elif mode == 2
  selectObject: tb
  Append column: "tmin"
  Append column: "tmax"
  for i_row to object[tb].nrow
    filename$ = object$[tb, i_row, "filename"]
    tier = object[tb, i_row, "tier"]
    error_id = object[tb, i_row, "error_id"]
    
    tg =  Read from file: filename$
    @get_number_of_items: tier

    for i_item to get_number_of_items.return
      @get_label_of_item: tier, i_item
      exists = index_regex(get_label_of_item.return$, error_pattern$[error_id])
      if exists
        @get_time_of_item: tier, i_item
        selectObject: tb
        Set numeric value: i_row, "tmin", get_time_of_item.tmin
        Set numeric value: i_row, "tmax", get_time_of_item.tmax
        selectObject: tg
      endif
    endfor
    removeObject: tg
  endfor
  selectObject: tb
elif mode == 3
  writeInfoLine: "Check whitespaces... changes done!'newline$'Modified files: 'count_mod'"
endif

include ../procedures/list_recursive_path.proc
include ../procedures/intervalpoint.proc
