include ../procedures/list_recursive_path.proc
include ../procedures/get_tier_number.proc

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
nList = Get number of strings

# Collect database
tbDatabase = Create Table with column names: "first", 0, "tmin text tmax filename"

for iFile to nList
  tgName$ = object$[fileList, iFile]
  tgFullPath$ = tg_folder$ + "/" + tgName$
  tg = Read from file: tgFullPath$
  getTierNumber.return[tier_name$] = 0
  @getTierNumber
  tier = getTierNumber.return[tier_name$]
  
  if tier
    tgTier = Extract one tier: tier
    tbTier = Down to Table: "no", 16, "no", "no"
    Append column: "filename"
    Formula: "filename", ~tgName$

    tbTemp = tbDatabase
    selectObject: tbTemp, tbTier
    tbDatabase = Append
    removeObject: tbTier, tbTemp
  endif
  removeObject: tg, tgTier 
endfor
removeObject: fileList

selectObject: tbDatabase
Rename: "corpus"

# Build corpus
