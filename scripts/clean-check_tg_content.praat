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

form Check TextGrid whitespaces...
  comment Folder with annotation files:
  text Textgrid_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment Do...
  boolean Create_Table_with_detailed_report
  boolean Remove_white_space_characters 0
endform

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

tb = Create Table with column names: "white_spaces", 0, "error tier interval filename count"

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
        selectObject: tb
        Append row
        currentRow = object[tb].nrow

        if index_regex(label$, "\t")
          errorName$ = "Horizontal tab"
        elif index_regex(label$, "\v")
          errorName$ = "Vertical tab"
        elif index_regex(label$, "\n")
          errorName$ = "New line"
        elif index_regex(label$, "^ +$")
          errorName$ = "White space label"
        elif index_regex(label$, " +$")
          errorName$ = "White space at end"
          pattern$ = " +$"
        elif index_regex(label$, "^ +")
          errorName$ = "White space at start"
          pattern$ = "^ +"
        elif index_regex(label$, " +")
          errorName$ = "White spaces"
          pattern$ = " +"
        endif

        Set string value: currentRow, "error", errorName$
        Set numeric value: currentRow, "tier", iTier
        Set numeric value: currentRow, "interval", iPosition
        Set numeric value: currentRow, "count", 1
        Set string value: currentRow, "filename", tgPath$

        label$ = replace_regex$(label$, "[\t\v\n]", " ", 0)
        label$ = replace_regex$(label$, "^ +$", "", 0)
        label$ = replace_regex$(label$, " +$", "", 0)
        label$ = replace_regex$(label$, "^ +", "", 0)
        label$ = replace_regex$(label$, " +", " ", 0)
        
        if remove_white_space_characters
          selectObject: tg
          @set_item_text: iTier, iPosition, label$
        endif

      endif
    endfor
  endfor
  removeObject: tg
endfor

selectObject: tb
tb_info = Collapse rows: "error", "count", "", "", "", ""
info$ = List: 0

removeObject: tb_info, fileList

if not create_Table_with_detailed_report
  removeObject: tb
endif

info$ = replace_regex$(info$, "error\tcount", "\n_______________________Summary_______________________________", 0)
info$ = replace_regex$(info$, "\t", ": ", 0)
writeInfoLine: "Check TextGrid content..."
appendInfoLine: info$

procedure set_item_text: .tier, .position, .text$
  isIntervalTier = Is interval tier: .tier
    if isIntervalTier
      Set interval text: .tier, .position, .text$
    else
      Set point text: .tier, .position, .text$
    endif
endproc

procedure get_number_of_items: .tier
  isIntervalTier = Is interval tier: .tier
    if isIntervalTier
      .return = Get number of intervals: .tier
    else
      .return = Get number of points: .tier
    endif
endproc

procedure get_label_of_item: .tier, .position
  isIntervalTier = Is interval tier: .tier
    if isIntervalTier
      .return$ = Get label of interval: .tier, .position
    else
      .return$ = Get label of point: .tier, .position
    endif
endproc
