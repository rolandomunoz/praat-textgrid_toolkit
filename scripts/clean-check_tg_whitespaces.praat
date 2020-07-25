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
  option Remove white spaces
endform

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

tb = Create Table with column names: "whitespaces", 0, "error tier_name tier interval tmin tmax filename count"

# Open one-by-one all the TextGrids
for i to n_fileList
  # Read all the tiers from the TextGrid
  tg$ = object$[fileList, i]
  basename$ = replace_regex$(tg$, "(.+/)(.+)", "\2", 0)
  tg_path$ = textgrid_folder$ + "/" + tg$
  tg = Read from file: tg_path$
  n_tiers = Get number of tiers
  for i_tier to n_tiers
    selectObject: tg
    tier_name$ = Get tier name: i_tier
    @get_number_of_items: i_tier
    n_positions = get_number_of_items.return
    
    for i_position to n_positions
      selectObject: tg
      @get_label_of_item: i_tier, i_position
      label$ = get_label_of_item.return$
      
      if index_regex(label$, "[ \t\v\n]")
        @get_time_of_item: i_tier, i_position
        tmin = get_time_of_item.tmin
        tmax = get_time_of_item.tmax

        error_name$ = "white space between words"
        if index_regex(label$, "\t")
          error_name$ = "horizontal tab"
        elif index_regex(label$, "\v")
          error_name$ = "vertical tab"
        elif index_regex(label$, "\n")
          error_name$ = "new line"
        elif index_regex(label$, "^ +$")
          error_name$ = "white space label"
        elif index_regex(label$, " +$")
          error_name$ = "white space at the end"
          pattern$ = " +$"
        elif index_regex(label$, "^ +")
          error_name$ = "white space at the start"
          pattern$ = "^ +"
        elif index_regex(label$, "  +")
          error_name$ = "two or more white spaces"
        endif

        selectObject: tb
        Append row
        current_row = object[tb].nrow
        
        Set string value: current_row, "error", error_name$
        Set string value: current_row, "tier_name", tier_name$
        Set numeric value: current_row, "tier", i_tier
        Set numeric value: current_row, "interval", i_position
        Set numeric value: current_row, "tmin", tmin
        Set numeric value: current_row, "tmax", tmax
        Set numeric value: current_row, "count", 1
        Set string value: current_row, "filename", tg_path$
      endif
    endfor
  endfor
  removeObject: tg
endfor
removeObject: fileList

# Start mode
if mode == 1
  # Get info for summary
  selectObject: tb
  Sort rows: "error"
  tb_info = Collapse rows: "error", "count", "", "", "", ""
  info$ = List: 0

  # Print summary
  info$ = replace_regex$(info$, "error\tcount", "\n_______________________Summary_______________________________", 0)
  info$ = replace_regex$(info$, "\t", ": ", 0)
  writeInfoLine: "Check TextGrid content..."
  appendInfoLine: info$
  removeObject: tb, tb_info
elsif mode == 3
  beginPause: "Remove whitespaces"
  comment: "Do you want to keep 1 space character between words?"
  boolean: "Yes", 1
  clicked = endPause: "Cancel", "Ok", 2
  
  if clicked == 2
    for i to object[tb].nrow
      tg_path$ = object$[tb, i, "filename"]
      tg = Read from file: tg_path$
      n_tiers = Get number of tiers
      for i_tier to n_tiers
        selectObject: tg
        @replace_item_texts: i_tier, "[\t\v\n]", " "
        @replace_item_texts: i_tier, "^ +$", ""
        @replace_item_texts: i_tier, " +$", ""
        @replace_item_texts: i_tier, "^ +", ""
        if yes
          @replace_item_texts: i_tier, "  +", " "
        else
          @replace_item_texts: i_tier, " +", ""
        endif
      endfor
      Save as text file: tg_path$
      removeObject: tg
    endfor
    writeInfoLine: "Remove TextGrid white space characters... Done!"
  endif
  removeObject: tb
endif

include ../procedures/list_recursive_path.proc
include ../procedures/intervalpoint.proc
