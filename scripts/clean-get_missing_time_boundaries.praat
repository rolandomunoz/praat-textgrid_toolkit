# Checks if the boundaries from a tier exists in other tiers.
# Outputs a Table
#
# Written by Rolando Munoz A. (2020)
# 
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

form Get mismatched boundaries
  comment Folder with annotation files:
  text Textgrid_folder /home/rolando/corpus
  boolean Recursive_search 0
  sentence Target_tiers segment syllable
  word Source_tier word
  optionmenu Mode 1
    option Create Table
#    option View and Edit
#    option Insert boundaries
endform

@createStringAsFileList: "fileList", textgrid_folder$ + "/*TextGrid", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

target_tier_names = Create Strings as tokens: target_tiers$, " "
n_target_tiers = Get number of strings

tb = Create Table with column names: "tier_info", 0, "time tier filename"

# Open one-by-one all the TextGrids
for i to n_fileList
  # Read all the tiers from the TextGrid
  tg$ = object$[fileList, i]
  tgFullPath$ = textgrid_folder$ + "/" + tg$
  tg = Read from file: tgFullPath$
  @getTierNumber
  @isTierName: source_tier$
  if isTierName.return
    for j to n_target_tiers
      target_tier$ = object$[target_tier_names, j]
      @isTierName: source_tier$
      if isTierName.return
        src_tier = getTierNumber.return[source_tier$]
        target_tier = getTierNumber.return[target_tier$]
        @diff_times: src_tier, target_tier
        current_tb = selected("Table")
        Append column: "tier"
        Append column: "filename"
        Formula: "tier", ~target_tier
        Formula: "filename", ~tgFullPath$
        # Combine tables
        selectObject: tb, current_tb
        new_tb = Append
        removeObject: tb, current_tb
        tb = new_tb
      endif
    endfor
  endif
  removeObject: tg
endfor
removeObject: target_tier_names, fileList
selectObject: tb
Rename: "Mismatched boundaries"

include ../procedures/list_recursive_path.proc
include ../procedures/intervalpoint.proc
include ../procedures/get_tier_number.proc
