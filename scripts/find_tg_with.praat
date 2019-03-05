include ../procedures/list_recursive_path.proc

form Find TextGrids with...
  comment Folder with annotation files:
  text tg_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment TextGrids
  optionmenu Find_TextGrid_which 1
  option contains
  option does not contain
  sentence All_tier_names word phrase
#  sentence Which_of_these_are_point_tiers?
endform

tb= Create Table with column names: "fileList", 0, "filename"

# Check dialogue box
tierList = Create Strings as tokens: all_tier_names$, " "
nSearchTier = Get number of strings
Sort
wordListTier = To WordList

# Find files
@createStringAsFileList: "fileList", tg_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
nList = Get number of strings

for iFile to nList
  tgName$ = object$[fileList, iFile]
  tgPath$ = tg_folder$ + "/" + tgName$
  tg = Read from file: tgPath$
  nTgTiers = Get number of tiers
  tierCounter = 0

  for iTgTier to nTgTiers
    selectObject: tg
    tierName$ = Get tier name: iTgTier
    
    selectObject: wordListTier
    isTier = Has word: tierName$
    tierCounter = if isTier then tierCounter + 1 else tierCounter fi
  endfor

  selectObject: tb
  
  if find_TextGrid_which == 1
    if nSearchTier == tierCounter
      Append row
      row = object[tb].nrow
      Set string value: row, "filename", tgPath$
    endif
  elsif find_TextGrid_which == 2
    if nSearchTier > tierCounter
      Append row
      row = object[tb].nrow
      Set string value: row, "filename", tgPath$
    endif
  endif
  removeObject: tg
endfor
removeObject: fileList, wordListTier, tierList
