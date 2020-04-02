# Written by Rolando Munoz Aramburu (1 April 2020)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
include ../procedures/list_recursive_path.proc

form Covert
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search 0
  optionmenu Mode 1
  option Convert to Unicode
  option Convert to backslash tripgraphs
endform

@createStringAsFileList: "filelist", "'tgFolder$'/*.TextGrid", 1
fileList= selected("Strings")
nStrings = Get number of strings

for i to nStrings
  tgName$= object$[fileList, i]
  tgPath$ = tgFolder$ + "/" + tgName$
  tg = Read from file: tgPath$
  if mode == 1
    Convert to Unicode
  elif mode == 2
    Convert to backslash trigraphs
  endif
  Save as text file: tgPath$
  removeObject: tg
endfor

removeObject: fileList
writeInfoLine: "Convert annotation files..."
appendInfoLine: "Mode: 'mode$'"
appendInfoLine: "Number of files: 'nStrings'"
