# Open one by one, all the audio files and their TextGrids in the specified directory
#
# Written by Rolando Munoz Aramburu (2020)
# 
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
include ../procedures/list_recursive_path.proc
include ../procedures/intervalpoint.proc

form Check TextGrid whitespaces...
  comment Folder with annotation files:
  text Textgrid_folder /home/rolando/corpus
  boolean Recursive_search 0
  comment Settings...
  boolean Keep_white_space_between_words 0
endform

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

# Open one-by-one all the TextGrids
for i to n_fileList
  # Read all the tiers from the TextGrid
  tg$ = object$[fileList, i]
  tgPath$ = textgrid_folder$ + "/" + tg$
  tg = Read from file: tgPath$
  nTiers = Get number of tiers
  for iTier to nTiers
    selectObject: tg
    @replace_item_texts: iTier, "[\t\v\n]", " "
    @replace_item_texts: iTier, "^ +$", ""
    @replace_item_texts: iTier, " +$", ""
    @replace_item_texts: iTier, "^ +", ""
    if keep_white_space_between_words
      @replace_item_texts: iTier, "  +", " "
    else
      @replace_item_texts: iTier, " +", ""
    endif
    Save as text file: tgPath$
  endfor
  removeObject: tg
endfor

removeObject: fileList
writeInfoLine: "Remove TextGrid white space characters... Done!"
