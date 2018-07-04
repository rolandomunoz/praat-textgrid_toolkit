# Create a Table named Corpus which includes a detailed list of all audio and annotation files
# Written by Rolando Munoz A. (29 March 2018)
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

form Create corpus table
  comment The directories where your files are stored...
  sentence Audio_folder
  sentence Textgrid_folder
  boolean Recursive_search
  word Audio_extension .wav
  comment Search inside textgrids?
  sentence All_tier_names
  boolean Yes
endform

textgrid_folder$ = if textgrid_folder$ == "" then "." else textgrid_folder$ fi
relative_path = if startsWith(textgrid_folder$, ".") then  1 else 0 fi

# List all files in a Strings object, then build a Table corpus
@createStringAsFileList: "fileList", audio_folder$ + "/*'audio_extension$'", recursive_search
fileList= selected("Strings")
nFiles= Get number of strings

## Create Corpus table
tbCorpus= Create Table with column names: "corpus", nFiles, "audio_file annotation all_tiers audio_path annotation_path"

if !nFiles
  removeObject: fileList
  selectObject: tbCorpus
  writeInfoLine: "No audio files in the audio folder"
  exitScript()
endif

deepSearch= if yes then 1 else 0 fi
deepSearch= if all_tier_names$ == "" then 0 else 1 fi
if deepSearch
  strTiers= Create Strings as tokens: all_tier_names$, " "
  str_nTiers= Get number of strings
endif

for i to nFiles
  sdPath$ = audio_folder$ + "/" + object$[fileList, i]
  sd$ = replace_regex$(sdPath$, ".*/", "", 1)
  basename$ =  sd$ - audio_extension$

  if relative_path
    tgPath$ = (sdPath$ - sd$) + textgrid_folder$ + "/" + basename$ + ".TextGrid"
  else
    tgPath$ = textgrid_folder$ + "/" + basename$ + ".TextGrid"
  endif
  
  isAnnotation = if fileReadable(tgPath$) then 1 else 0 fi
  isAllTier= 0
  
  if isAnnotation
    if deepSearch
      tg= Read from file: tgPath$
      @_isAnyMissingTier: strTiers, str_nTiers
      isAllTier= if '_isAnyMissingTier.return' then 0 else 1 fi
      removeObject: tg
    endif
  endif
  
  selectObject: tbCorpus
  Set string value: i, "audio_file", sd$
  Set numeric value: i, "annotation", isAnnotation
  Set numeric value: i, "all_tiers", isAllTier
  Set string value: i, "audio_path", sdPath$
  Set string value: i, "annotation_path", tgPath$
endfor

if deepSearch
  removeObject: strTiers
endif
removeObject: fileList

procedure _isAnyMissingTier: .stringsID, .strings_n
  .n_tgTiers= Get number of tiers
  .tier= 1
  .counter= 0
  for .i to .strings_n
    .strTier$= object$[.stringsID, .i]
    for .j from .tier to .n_tgTiers
      .tgTier$= Get tier name: .j
      if .strTier$ == .tgTier$
        .tier= .j
        .j= .n_tgTiers
        .counter+=1
      endif
    endfor
  endfor
  .return= if .counter = .strings_n then 0 else 1 fi
endproc
