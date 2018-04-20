include ../procedures/list_recursive_path.proc

dir$ = "/home/rolando/Documents/shared/assignment_3"
recursive_search = 1

if recursive_search
  @findFiles: dir$, "/*.TextGrid"
  fileList = selected("Strings")
else
  fileList = Create Strings as file list: "fileList", dir$ + "/*.TextGrid"
endif
n_fileList = Get number of strings

tb= Create Table with column names: "tier summary", 0, "tier tier_counter interval_counter duplicated"
infoDuplicated$ = ""
isAnyDuplicatedTier = 0

# Open one-by-one all the TextGrids
for i to n_fileList
  #
  selectObject: tb
  Formula: "duplicated", "0"

  # Read all the tiers from the TextGrid  
  tg$ = object$[fileList, i]
  tg = Read from file: dir$ + "/" + tg$
  n_tiers= Get number of tiers

  for j to n_tiers
    selectObject: tg
    tier$ = Get tier name: j
    nIntervals = Count intervals where: j, "is not equal to", ""

    # Search inside the table Tier Summary if the tier name exists or not. Then complete the table.
    selectObject: tb
    row = Search column: "tier", tier$

    if row
       # Add an occurrence to the existing tier
       tier_counter= object[tb, row, "tier_counter"] + 1
       duplicated= object[tb, row, "duplicated"] + 1
       nIntervals = object[tb, row, "interval_counter"] + nIntervals

       Set numeric value: row, "tier_counter", tier_counter
       Set numeric value: row, "duplicated", duplicated
       Set numeric value: row, "interval_counter", nIntervals

       if object[tb, row, "duplicated"] > 1
         isAnyDuplicatedTier= 1
         infoDuplicated$ = infoDuplicated$ + "tier: " + tier$ + newline$ + "number of duplications: " +  string$(object[tb, row, "duplicated"]) + newline$ + "file: " + "'dir$'/'tg$'"+ newline$ + newline$
       endif
    else
      # Add an entry to the Table and initialize the occurrence counter
      Append row
      row = object[tb].nrow
      Set string value: row, "tier", tier$
      Set numeric value: row, "tier_counter", 1
      Set numeric value: row, "duplicated", 1
      Set numeric value: row, "interval_counter", nIntervals
   endif
  endfor
  removeObject: tg
endfor

# Print report
selectObject: tb
Remove column: "duplicated"

info$ = List: "no"

writeInfoLine: "Tier summary:"

appendInfoLine: "___________________________________________________________________"
appendInfoLine: "Tier list:"
for i to object[tb].nrow
  appendInfoLine: i, tab$, object$[tb, i, "tier"]
endfor

appendInfoLine: "___________________________________________________________________"
appendInfoLine: "Detailed tier list:"
appendInfoLine: ""
info$ = replace$(info$, "tier	tier_counter	interval_counter" + newline$, "",  1)
info$ = replace_regex$(info$, "^(.*)\t(.*)\t(.*)$", "tier: \1\nnumber of tiers: \2\nnumber of intervals: \3\n",  0)
appendInfo: info$ - newline$

if isAnyDuplicatedTier
  appendInfoLine: "___________________________________________________________________"
  appendInfoLine: "WARNING 1: These TextGrids contain two or more tiers with the same name"
  appendInfoLine: ""
  appendInfoLine: infoDuplicated$ - newline$ - newline$
endif

removeObject: fileList, tb
