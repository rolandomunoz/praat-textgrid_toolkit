# Checks if the boundaries from a tier exists in other tiers.
# Outputs a Table
#
# Written by Rolando Munoz A. (2020)
# 
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

form Check boundary alignments
  comment Get the mismatched boundaries of the source tier in target tiers
  comment Folder with annotation files:
  text Textgrid_folder /home/rolando/corpus
  boolean Recursive_search 0
  sentence Target_tiers segment syllable
  word Source_tier word
  optionmenu Mode 1
    option Diff boundaries table
#    option View and Edit
#    option Insert boundaries
endform

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_file_list= Get number of strings

target_tier_names = Create Strings as tokens: target_tiers$, " "
n_target_tiers = Get number of strings

tb = Create Table with column names: "tier_info", 0, "time tier filename"

missing_source_tier_list$ = ""
missing_source_tier_list = 0

for i to n_target_tiers
  target_tier$ = object$[target_tier_names, i]
  missing_target_tier_list$[target_tier$] = ""
  missing_target_tier_list[target_tier$] = 0
endfor

# Open one-by-one all the TextGrids
for i to n_file_list
  # Read all the tiers from the TextGrid
  tg$ = object$[fileList, i]
  tg_full_path$ = textgrid_folder$ + "/" + tg$
  tg = Read from file: tg_full_path$
  @index_tiers
  @get_tier_position: source_tier$
  source_tier = get_tier_position.return

  # Checking if target tiers exist. Print info at the end of the script
  if source_tier == 0
    missing_source_tier_list$ += tg_full_path$ + newline$
    missing_source_tier_list +=1
  endif
  
  for j to n_target_tiers
    target_tier$ = object$[target_tier_names, j]
    @get_tier_position: target_tier$
    target_tier = get_tier_position.return
    if target_tier == 0
      missing_target_tier_list$[target_tier$] += tg_full_path$ + newline$
      missing_target_tier_list[target_tier$] += 1
    endif
  endfor
  
  # Compute diff
  if source_tier > 0
    for j to n_target_tiers
      selectObject: tg
      target_tier$ = object$[target_tier_names, j]
      @get_tier_position: target_tier$
      target_tier = get_tier_position.return
      if target_tier > 0
        @diff_times: source_tier, target_tier
        current_tb = selected("Table")
        Append column: "tier"
        Append column: "filename"
        Formula: "tier", ~target_tier
        Formula: "filename", ~tg_full_path$
        # Combine tables
        selectObject: tb, current_tb
        new_tb = Append
        removeObject: tb, current_tb
        tb = new_tb
      endif
    endfor
  endif
  removeObject: tg
endfor
selectObject: tb
Rename: "diff boundaries"

# Print info
writeInfoLine: "Check boundary alignments"
appendInfoLine: "Input:"
appendInfoLine: "  Textgrid folder: ", textgrid_folder$
appendInfoLine: "  Recursive search: ", recursive_search
appendInfoLine: "  Target_tiers: ", target_tiers$
appendInfoLine: "  Source_tier: ", source_tier$
appendInfoLine: "  Mode: ", mode$
appendInfoLine: "Output:"
appendInfoLine: "  Files (total): ", n_file_list

if missing_source_tier_list$ != ""
  message1$ = "'newline$'WARNING: TextGrid files does not contain the SOURCE TIER ""'source_tier$'"""
  message2$ = "'newline$'WARNING: The SOURCE TIER ""'source_tier$'"" was not found in 'missing_source_tier_list' TextGrid files. 'newline$''newline$''missing_source_tier_list$'"
  
  info$ = if missing_source_tier_list == n_file_list then message1$ else message2$ fi
  appendInfo: info$ 
endif

for i to n_target_tiers
  target_tier$ = object$[target_tier_names, i]
  missing_target_tier_list$ = missing_target_tier_list$[target_tier$]
  missing_target_tier_list = missing_target_tier_list[target_tier$]
  
  if missing_target_tier_list$ != ""
    message1$ = "'newline$'WARNING: TextGrid files does not contain the TARGET TIER ""'target_tier$'"""
    message2$ = "'newline$'WARNING: The TARGET TIER ""'target_tier$'"" was not found in 'missing_target_tier_list' TextGrid files. 'newline$''newline$''missing_target_tier_list$'"
    info$ = if missing_target_tier_list == n_file_list then message1$ else message2$ fi
    appendInfo: info$ 
  endif
endfor

removeObject: target_tier_names, fileList

include ../procedures/list_recursive_path.proc
include ../procedures/intervalpoint.proc
include ../procedures/qtier.proc
