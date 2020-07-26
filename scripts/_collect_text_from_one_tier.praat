form Build corpus...
  comment Folder with annotation files:
  text tg_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment TextGrids
  sentence Tier_name word
endform

# Find files
@createStringAsFileList: "fileList", tg_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
nFiles = Get number of strings

# Collect database
tbDatabase = Create Table with column names: "first", 0, "tmin text tmax filename"

for iFile to nFiles
  tgName$ = object$[fileList, iFile]
  tgFullPath$ = tg_folder$ + "/" + tgName$
  tg = Read from file: tgFullPath$
  @index_tiers
  @get_tier_position: tier_name$
  tier = get_tier_position.return
  
  if tier
    tgTier = Extract one tier: tier
    tbTier = Down to Table: "no", 16, "no", "no"
    Append column: "filename"
    Formula: "filename", ~tgName$

    tbTemp = tbDatabase
    selectObject: tbTemp, tbTier
    tbDatabase = Append
    removeObject: tbTier, tbTemp, tgTier
  endif
  removeObject: tg 
endfor
removeObject: fileList

selectObject: tbDatabase
Rename: "corpus"

include ../procedures/list_recursive_path.proc
include ../procedures/qtier.proc
