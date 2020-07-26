form Create Table word occurrences...
  comment Folder with annotation files:
  text tg_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment TextGrids
  sentence Tier_name word
endform

tbWordOccurrencesCorpus= Create Table with column names: "word_ocurrences", 0, "word tmin text tmax filename"
runScript: "_collect_text_from_one_tier.praat", tg_folder$, recursive_search, tier_name$
tbCorpus = selected("Table")
if object[tbCorpus].nrow == 0
  removeObject: tbCorpus
  selectObject: tbWordOccurrencesCorpus
  exitScript()
endif

#Unique words
textAll$ = ""
for row to object[tbCorpus].nrow
  text$ = object$[tbCorpus, row, "text"]
  textAll$ = textAll$ + text$ + " "
endfor
wordList = Create Strings as tokens: textAll$, " "
categories = To Categories
uniqCategories = To unique Categories
uniqWordList = To Strings

selectObject: uniqWordList
nWords = Get number of strings
for iWord to nWords
  word$ = object$[uniqWordList, iWord]
  selectObject: tbCorpus
  tbWordOccurrences = nowarn Extract rows where column (text): "text", "contains ink equal to", word$
  Insert column: 1, "word"
  Formula: "word", ~word$
  tbTemp = tbWordOccurrencesCorpus
  selectObject: tbTemp, tbWordOccurrences
  tbWordOccurrencesCorpus= Append
  removeObject: tbTemp, tbWordOccurrences
endfor

# Table layout
selectObject: tbWordOccurrencesCorpus
Rename: "word_ocurrences_corpus"
Set column label (label): "tmin", "tmin_temp"
Insert column: 4, "tmin"
Formula: "tmin", ~fixed$(self["tmin_temp"], 16)
Remove column: "tmin_temp"

removeObject: uniqCategories, categories, wordList, uniqWordList, tbCorpus
