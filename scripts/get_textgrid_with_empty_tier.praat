include ../procedures/list_recursive_path.proc
include ../procedures/config.proc

@config.init: "../preferences.txt"

beginPause: "Get TextGrid report"
  sentence: "Textgrid folder", config.init.return$["textgrid_dir"]
  word: "Tier name", ""
  boolean: "Recursive search", number(config.init.return$["get_textgrid_report.recursive_search"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save the values from the dialogue box
@config.setField: "textgrid_dir", textgrid_folder$
@config.setField: "get_textgrid_report.recursive_search", string$(recursive_search)

if recursive_search
  @findFiles: textgrid_folder$, "/*.TextGrid"
  fileList = selected("Strings")
else
  fileList = Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
endif
n_fileList = Get number of strings

#tb= Create Table with column names: "Empty tier", 0, "file"

# Open one-by-one all the TextGrids
for i to n_fileList
  #
  selectObject: tb
  Formula: "duplicated", "0"

  # Read all the tiers from the TextGrid  
  tg$ = object$[fileList, i]
  tg = Read from file: textgrid_folder$ + "/" + tg$
  nTiers= Get number of tiers

  selectObject: tg
  tier$ = Get tier name: j
  isInterval= Is interval tier: j
  if isInterval
    nTargets = Count intervals where: j, "is not equal to", ""
  else
    nTargets = Count points where: j, "is not equal to", ""
  endif
endfor
