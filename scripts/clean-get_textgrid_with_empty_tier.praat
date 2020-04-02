include ../procedures/list_recursive_path.proc

form "Get TextGrid report"
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search 0
  word Tier_name
endform

@createStringAsFileList: "fileList", tgFolder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

#tb= Create Table with column names: "Empty tier", 0, "file"

# Open one-by-one all the TextGrids
for i to n_fileList
  #
  selectObject: tb
  Formula: "duplicated", "0"

  # Read all the tiers from the TextGrid  
  tg$ = object$[fileList, i]
  tg = Read from file: tgFolder$ + "/" + tg$
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
