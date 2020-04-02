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
include ../procedures/list_recursive_path.proc
include ../procedures/intervalpoint.proc

form Check TextGrid whitespaces...
  comment Folder with annotation files:
  text Textgrid_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment Create Table...
  boolean Create_Table_with_detailed_report
endform

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

tb = Create Table with column names: "white_spaces", 0, "error tier_name tier interval tmin tmax filename count"

# Open one-by-one all the TextGrids
for i to n_fileList
  # Read all the tiers from the TextGrid
  tg$ = object$[fileList, i]
  basename$ = replace_regex$(tg$, "(.+/)(.+)", "\2", 0)
  tgPath$ = textgrid_folder$ + "/" + tg$
  tg = Read from file: tgPath$
  nTiers = Get number of tiers
  for iTier to nTiers
    selectObject: tg
    tierName$ = Get tier name: iTier
    @get_number_of_items: iTier
    nPositions= get_number_of_items.return
    

    for iPosition to nPositions
      selectObject: tg
      @get_label_of_item: iTier, iPosition
      label$ = get_label_of_item.return$
      
      if index_regex(label$, "[ \t\v\n]")
        @get_time_of_item: iTier, iPosition
        tmin = get_time_of_item.tmin
        tmax = get_time_of_item.tmax

        errorName$ = "white space between words"
        if index_regex(label$, "\t")
          errorName$ = "horizontal tab"
        elif index_regex(label$, "\v")
          errorName$ = "vertical tab"
        elif index_regex(label$, "\n")
          errorName$ = "new line"
        elif index_regex(label$, "^ +$")
          errorName$ = "white space label"
        elif index_regex(label$, " +$")
          errorName$ = "white space at the end"
          pattern$ = " +$"
        elif index_regex(label$, "^ +")
          errorName$ = "white space at the start"
          pattern$ = "^ +"
        elif index_regex(label$, "  +")
          errorName$ = "two or more white spaces"
        endif

        selectObject: tb
        Append row
        currentRow = object[tb].nrow
        
        Set string value: currentRow, "error", errorName$
        Set string value: currentRow, "tier_name", tierName$
        Set numeric value: currentRow, "tier", iTier
        Set numeric value: currentRow, "interval", iPosition
        Set numeric value: currentRow, "tmin", tmin
        Set numeric value: currentRow, "tmax", tmax
        Set numeric value: currentRow, "count", 1
        Set string value: currentRow, "filename", tgPath$
      endif
    endfor
  endfor
  removeObject: tg
endfor

selectObject: tb
Sort rows: "error"
tb_info = Collapse rows: "error", "count", "", "", "", ""
info$ = List: 0

removeObject: tb_info, fileList
selectObject: tb
if not create_Table_with_detailed_report
  removeObject: tb
endif

info$ = replace_regex$(info$, "error\tcount", "\n_______________________Summary_______________________________", 0)
info$ = replace_regex$(info$, "\t", ": ", 0)
writeInfoLine: "Check TextGrid content..."
appendInfoLine: info$
