# Written by Rolando Munoz A. (2018-2019)
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
include ../procedures/list_recursive_path.proc

form Sound to TextGrid (silences)
  comment Folder with sound files:
  text sdFolder /home/rolando/corpus
  boolean Recursive_search 0
  comment Folder with annotation files:
  text tgFolder .
  #(= relative path to sound files)
  comment To TextGrid (silences)...
  comment Parameters for the intensity analysis
  real Minimum_pitch_(Hz) 100
  real Time_step_(s) 0.0
  comment Silent intervals detection
  real Silence_threshold_(dB) -25.0
  real Minimum_silent_interval_duration_(s) 0.1
  real Minimum_sounding_interval_duration_(s) 0.1
  word Silent_interval_label silent
  word Sounding_interval_label sounding
endform

audio_extension$= ".wav"
tgFolder$ = if tgFolder$ == "" then "." else tgFolder$ fi
relative_path = if startsWith(tgFolder$, ".") then 1 else 0 fi

# Find directories
@createStringAsFileList: "fileList", sdFolder$ + "/*'audio_extension$'", recursive_search
fileList= selected("Strings")
n_fileList= Get number of strings

newFileCounter= 0

# Open each file
for i to n_fileList
  sdPath$ = sdFolder$ + "/" + object$[fileList, i]
  sd$ = replace_regex$(sdPath$, ".*/", "", 1)
  basename$ =  sd$ - audio_extension$

  if relative_path
    tgPath$ = sdPath$ - sd$ + "/" + tgFolder$ + "/" + basename$ + ".TextGrid"
  else
    tgPath$ = tgFolder$ + "/" + basename$ + ".TextGrid"
  endif
  
  if not fileReadable(tgPath$)
    sd = Read from file: sdPath$
    tg = To TextGrid (silences): minimum_pitch, time_step, silence_threshold, minimum_silent_interval_duration, minimum_sounding_interval_duration, silent_interval_label$, sounding_interval_label$

    Save as text file: tgPath$
    removeObject: tg, sd
    newFileCounter+=1
  endif
endfor
removeObject: fileList

writeInfoLine: "Create TextGrid (silences)"
appendInfoLine: "Output"
appendInfoLine: "  New files (total): ", newFileCounter