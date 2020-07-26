# Written by Rolando Munoz A. (8 October 2018)
# Last modified on 26 July 2020
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#

form Replace text (dictionary)
  comment Folder with annotation files:
  text tg_folder_path /home/user/Desktop/corpus
  boolean Recursive_search 0
  comment TextGrid Object:
  word Tier_name phrase
  optionmenu Track_changes 1
  option no
  option matched items
  option mismatched items
  comment Dictionary file path (a csv file):
  text Dictionary_path ../temp/dictionary.csv
  word Search_column search
  word Replace_column replace
endform

# Check table
dictionary = Read Table from comma-separated file: dictionary_path$
searchColumn = Get column index: search_column$
replaceColumn = Get column index: replace_column$
if not searchColumn or not replaceColumn
  writeInfoLine: "Sorry, column names could not be found. Try again!"
  exitScript()
endif

# Open TextGrids one by one
@createStringAsFileList: "fileList",  tg_folder_path$ + "/*.TextGrid", recursive_search
fileList = selected("Strings")
n_file_list = Get number of strings

number_of_modified_files = 0
number_of_modifier_items = 0
number_of_mismatching_items = 0
missing_tier_list = 0
missing_tier_list$ = ""

for i_file to n_file_list
  save_tg = 0

  tg$ = object$[fileList, i_file]
  tg_full_path$ =  tg_folder_path$ + "/" +tg$
  tg = Read from file: tg_full_path$
  @index_tiers
  @get_tier_position: tier_name$
  tier = get_tier_position.return
  
  if tier
    @get_number_of_items: tier
    
    # Search and replace labels
    for i_position to get_number_of_items.return
      selectObject: tg
      @get_label_of_item: tier, i_position
      label$ = get_label_of_item.return$
      if label$ != ""
        selectObject: dictionary
        is_word = Search column: search_column$, label$
        selectObject: tg
        
        if is_word
          save_tg = 1
          number_of_modifier_items += 1
          row = is_word
          replace_text$ = object$[dictionary, row, replace_column$]
          replace_text$ = if track_changes == 2 then "*" + replace_text$ else replace_text$ fi
          @set_item_text: tier, i_position, replace_text$
        else
          number_of_mismatching_items +=1
          if track_changes == 3
            save_tg = 1
            replace_text$ = "*" + label$
            @set_item_text: tier, i_position, replace_text$
          endif
        endif
      endif
    endfor
    
    # If any change, then save the TextGrid
    if save_tg
      number_of_modified_files += 1
      Save as text file: tg_folder_path$ + "/" + tg$
    endif
  else
    missing_tier_list += 1
    missing_tier_list$ += tg_full_path$ + newline$
  endif
  removeObject: tg
endfor

selectObject: dictionary

Set column label (label): search_column$, "search"
Set column label (label): replace_column$, "replace"
Save as comma-separated file: "../temp/dictionary.csv"

removeObject: fileList, dictionary

# Print info
writeInfoLine: "Replace tier name"
appendInfoLine: "Input:"
appendInfoLine: "  Tier name: ", tier_name$
appendInfoLine: "  Search column: ", search_column$
appendInfoLine: "  Replace column: ", replace_column$
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", n_file_list
appendInfoLine: "  Modified files (total): ", number_of_modified_files

if number_of_modified_files > 0
  appendInfoLine: "  Modified intervals or points (total): ", number_of_modifier_items
  appendInfoLine: "  Mismatched intervals or points (total): ", number_of_mismatching_items
endif

if not missing_tier_list$ == ""
  message1$ = "'newline$'WARNING: TextGrid files does not contain the tier ""'tier_name$'"""
  message2$ = "'newline$'WARNING: The tier ""'tier_name$'"" was not found in 'missing_tier_list' TextGrid files. 'newline$''newline$''missing_tier_list$'"
  
  info$ = if missing_tier_list == n_file_list then message1$ else message2$ fi
  appendInfo: info$ 
endif

include ../procedures/qtier.proc
include ../procedures/intervalpoint.proc
include ../procedures/list_recursive_path.proc
