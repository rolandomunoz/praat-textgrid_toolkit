# Copyright 2017-2019 Rolando Muñoz Aramburú

include ../procedures/link_intervals.proc
include ../procedures/list_recursive_path.proc

form Create Table parent/child tier
  comment Folder with annotation files:
  text tg_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment TextGrid
  word Child_tier word
  sentence All_parent_tiers gloss
endform

@createStringAsFileList: "fileList", tg_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
nFiles = Get number of strings

first = 1
for i to nFiles
  tg$= object$[fileList, i]
  tgFullPath$= tg_folder$ + "/" + tg$
  tg = Read from file: tgFullPath$

  # Get table from TextGrid
  tbTiers = nowarn Down to Table: "no", 16, "yes", "no"

  # Get tree structure
  @linkIntervals: child_tier$, all_parent_tiers$
  tbTreeCurrent = selected("Table")

  if first == 1
    tbTree = tbTreeCurrent
    first = 0
  else
    tbTemp = tbTree
    selectObject: tbTemp, tbTreeCurrent
    tbTree = Append
    removeObject: tbTemp, tbTreeCurrent 
  endif
  removeObject: tg, tbTiers
endfor

selectObject: tbTree
Rename: "parent_child_corpus"

child_tier$ = replace_regex$(child_tier$, ".+", "&.text", 0)
all_parent_tiers$ = replace_regex$(all_parent_tiers$, ".+", "&.text", 0)

# Get unique values from tiers child and parent
tbTree_unique = Collapse rows: "'child_tier$' 'all_parent_tiers$'" , "", "", "", "", ""
selectObject: tbTree_unique
Rename: "parent_child_unique"

removeObject: fileList
selectObject: tbTree_unique, tbTree
