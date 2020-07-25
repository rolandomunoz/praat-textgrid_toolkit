# Open one by one, all the audio files and their TextGrids in the specified directory
#
# Written by Rolando Munoz A. (2019)
# 
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
include ../procedures/list_recursive_path.proc

form Summarize tiers
  comment Folder with annotation files:
  text Textgrid_folder /home/rolando/corpus
  boolean Recursive_search 0
endform

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

tb = Create Table with column names: "tier_info", 0, "tier tier_counter n_labels duplicate"
tb_tier_template= Create Table with column names: "tier template", 0, "all_tier_names counter"
tb_check_tier_spelling = Create Table with column names: "check_tier_spelling", 0, "tier_name file"
tb_duplicate = Create Table with column names: "check_duplication", 0, "tier_name total file"


# Open one-by-one all the TextGrids
for i to n_fileList
  selectObject: tb
  Formula: "duplicate", "0"

  # Read all the tiers from the TextGrid
  tg$ = object$[fileList, i]
  tgFullPath$ = textgrid_folder$ + "/" + tg$
  tg = Read from file: tgFullPath$ 
  nTiers= Get number of tiers

  all_tier_names$ = ""
  for j to nTiers
    selectObject: tg
    tier$ = Get tier name: j
    all_tier_names$ = all_tier_names$ + tier$ + " "
    isInterval= Is interval tier: j
    if isInterval
      nTargets = Count intervals where: j, "is not equal to", ""
    else
      nTargets = Count points where: j, "is not equal to", ""
    endif

    # Check tier name spelling
    isAnywhiteSpace = index(tier$, " ")
    if isAnywhiteSpace
      selectObject: tb_check_tier_spelling
      Append row
      row = object[tb_check_tier_spelling].nrow
      Set string value: row, "tier_name", tier$
      Set string value: row, "file", tgFullPath$
    endif

    # Search inside the table Tier info if the tier name exists or not. Then complete the table.
    selectObject: tb
    row = Search column: "tier", tier$

    if row
      # Add an occurrence to the existing tier
      tier_counter= object[tb, row, "tier_counter"] + 1
      duplicate= object[tb, row, "duplicate"] + 1
      nTargets = object[tb, row, "n_labels"] + nTargets

      Set numeric value: row, "tier_counter", tier_counter
      Set numeric value: row, "duplicate", duplicate
      Set numeric value: row, "n_labels", nTargets
    else
      # Add an entry to the Table and initialize the occurrence counter
      Append row
      row = object[tb].nrow
      Set string value: row, "tier", tier$
      Set numeric value: row, "tier_counter", 1
      Set numeric value: row, "duplicate", 1
      Set numeric value: row, "n_labels", nTargets
    endif
  endfor

  # Report duplicate tier names within TextGrid files
  for row to object[tb].nrow
    if object[tb, row, "duplicate"] > 1
      selectObject: tb_duplicate
      Append row
      jrow = object[tb_duplicate].nrow
      nDuplication = object[tb, row, "duplicate"]
      Set string value: jrow, "tier_name", tier$
      Set string value: jrow, "file", tgFullPath$
      Set numeric value: jrow, "total", nDuplication
    endif
  endfor

  # Report tier template within TextGrid files
  all_tier_names$ = all_tier_names$ - " "
  selectObject: tb_tier_template
  row = Search column: "all_tier_names", all_tier_names$
  if row
    counter= object[tb_tier_template, row, "counter"] + 1
    Set numeric value: row, "counter", counter
  else
    Append row
    row = object[tb_tier_template].nrow
    Set string value: row, "all_tier_names", all_tier_names$
    Set numeric value: row, "counter", 1
  endif

  removeObject: tg
endfor

# Print report
selectObject: tb
Remove column: "duplicate"
info$ = List: "yes"

writeInfoLine: "Tier summary:"
appendInfoLine: "___________________________________________________________________"
appendInfoLine: "Tier list:"
for i to object[tb].nrow
  appendInfo: i, tab$, object$[tb, i, "tier"] + tab$
  appendInfo: "(total= ", object$[tb, i, "tier_counter"], ", "
  appendInfoLine: "labels= ", object$[tb, i, "n_labels"], ")"
endfor

appendInfoLine: "___________________________________________________________________"
appendInfoLine: "Tier template:"
for i to object[tb_tier_template].nrow
  appendInfo: i, tab$, object$[tb_tier_template, i, "all_tier_names"] + tab$
  appendInfoLine: "(total= ", object$[tb_tier_template, i, "counter"], ")"
endfor

## WARNING
warningCounter = 0

selectObject: tb_check_tier_spelling
info$ = List: 1
if object[tb_check_tier_spelling].nrow
  warningCounter += 1
  appendInfoLine: "___________________________________________________________________"
  appendInfoLine: "WARNING 'warningCounter': Ill-formed tier name"
  appendInfoLine: ""
  appendInfo: info$
endif

selectObject: tb_duplicate
info$ = List: 1
if object[tb_duplicate].nrow
  warningCounter += 1
  appendInfoLine: "___________________________________________________________________"
  appendInfoLine: "WARNING 'warningCounter': These TextGrids contain two or more tiers with the same name"
  appendInfoLine: ""
  appendInfo: info$
endif

removeObject: fileList, tb, tb_tier_template, tb_check_tier_spelling, tb_duplicate
