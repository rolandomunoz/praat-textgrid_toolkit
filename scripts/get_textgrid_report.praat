include ../procedures/list_recursive_path.proc
include ../procedures/config.proc

@config.init: "../preferences.txt"

beginPause: "Get TextGrid report"
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  boolean: "Recursive search", number(config.init.return$["get_textgrid_report.recursive_search"])
  boolean: "Rich report", number(config.init.return$["get_textgrid_report.rich_report"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save the values from the dialogue box
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "get_textgrid_report.recursive_search", string$(recursive_search)
@config.setField: "get_textgrid_report.rich_report", string$(rich_report)

if recursive_search
  @findFiles: textgrid_folder$, "/*.TextGrid"
  fileList = selected("Strings")
else
  fileList = Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
endif
n_fileList = Get number of strings

tb= Create Table with column names: "tier summary", 0, "tier tier_counter target_counter duplicated"
infoDuplicated$ = ""
isAnyDuplicatedTier = 0

# Open one-by-one all the TextGrids
for i to n_fileList
  #
  selectObject: tb
  Formula: "duplicated", "0"

  # Read all the tiers from the TextGrid  
  tg$ = object$[fileList, i]
  tg = Read from file: textgrid_folder$ + "/" + tg$
  nTiers= Get number of tiers

  for j to nTiers
    selectObject: tg
    tier$ = Get tier name: j
    isInterval= Is interval tier: j
    if isInterval
      nTargets = Count intervals where: j, "is not equal to", ""
    else
      nTargets = Count points where: j, "is not equal to", ""
    endif
    # Search inside the table Tier Summary if the tier name exists or not. Then complete the table.
    selectObject: tb
    row = Search column: "tier", tier$

    if row
       # Add an occurrence to the existing tier
       tier_counter= object[tb, row, "tier_counter"] + 1
       duplicated= object[tb, row, "duplicated"] + 1
       nTargets = object[tb, row, "target_counter"] + nTargets

       Set numeric value: row, "tier_counter", tier_counter
       Set numeric value: row, "duplicated", duplicated
       Set numeric value: row, "target_counter", nTargets

       if object[tb, row, "duplicated"] > 1
         isAnyDuplicatedTier= 1
         infoDuplicated$ = infoDuplicated$ + "tier: " + tier$ + newline$ + "number of duplications: " +  string$(object[tb, row, "duplicated"]) + newline$ + "file: " + "'textgrid_folder$'/'tg$'"+ newline$ + newline$
       endif
    else
      # Add an entry to the Table and initialize the occurrence counter
      Append row
      row = object[tb].nrow
      Set string value: row, "tier", tier$
      Set numeric value: row, "tier_counter", 1
      Set numeric value: row, "duplicated", 1
      Set numeric value: row, "target_counter", nTargets
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

if rich_report
  appendInfoLine: "___________________________________________________________________"
  appendInfoLine: "Detailed tier list:"
  appendInfoLine: ""

  info$ = replace$(info$, "tier	tier_counter	target_counter", "tier occurrences targets",  1)
  appendInfoLine: info$
endif

if isAnyDuplicatedTier
  appendInfoLine: "___________________________________________________________________"
  appendInfoLine: "WARNING 1: These TextGrids contain two or more tiers with the same name"
  appendInfoLine: ""
  appendInfoLine: infoDuplicated$ - newline$ - newline$
endif

removeObject: fileList, tb

if clicked = 2
  runScript: "get_textgrid_report.praat"
endif
