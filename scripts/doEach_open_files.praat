# Open one by one, all the audio files and their TextGrids in the specified directory
# If the TextGrid does not exist, then create a new one
#
# Written by Rolando Munoz A. (28 March 2018)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
include ../procedures/config.proc
include ../procedures/list_recursive_path.proc

@config.init: "../preferences.txt"

beginPause: "View & Edit"
  comment: "The directories where your files are stored..."
  sentence: "Audio folder", config.init.return$["run_plugin.audio_dir"]
  sentence: "Textgrid folder", config.init.return$["run_plugin.textgrid_dir"]
  boolean: "Recursive search", number(config.init.return$["run_plugin.recursive_search"])
  comment: "To TextGrid..."
  sentence: "All tier names", config.init.return$["create_textgrid.all_tier_names"]
  sentence: "Which of these are point tiers", config.init.return$["create_textgrid.point_tiers"]
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save the values from the dialogue box
@config.setField: "run_plugin.audio_dir", audio_folder$
@config.setField: "run_plugin.textgrid_dir", textgrid_folder$


# Check dialogue box
if textgrid_folder$ == ""
  pauseScript: "The field 'Textgrid folder' is empty. Please complete it"
  runScript: "doEach_open_files.praat"
  exitScript()
elsif
  pauseScript: "The field 'All tier names$' is empty. Please complete it"
  runScript: "doEach_open_files.praat"
  exitScript()
endif

# Get audio preferences from preferences.txt
textgrid_folder$ = if textgrid_folder$ == "" then "." else textgrid_folder$ fi
relative_path = if startsWith(textgrid_folder$, ".") then  1 else 0 fi
open_as_LongSound= number(config.init.return$["open_as_LongSound"])
adjust_volume= number(config.init.return$["adjust_volume"])
audio_extension$= config.init.return$["audio_extension"]

# Get TextGridEditor preferences from preferences.txt
default_values= number(config.init.return$["textGridEditor.default_values"])
if default_values
  min_range= number(config.init.return$["spectrogram.min_range"])
  max_range= number(config.init.return$["spectrogram.max_range"])
  dynamic_range= number(config.init.return$["spectrogram.dynamic_range"])
  view_lenght= number(config.init.return$["spectrogram.view_lenght"])
  show_pitch= number(config.init.return$["analysis.pitch"])
  show_intensity= number(config.init.return$["analysis.intensity"])
  show_formants= number(config.init.return$["analysis.formants"])
  show_pulse= number(config.init.return$["analysis.pulse"])
endif

# Find directories
if recursive_search
  @findFiles: textgrid_folder$, "/*.TextGrid"
  fileList= selected("Strings")
else
  fileList= Create Strings as file list: "fileList", audio_folder$ + "/*'audio_extension$'"
endif
nFiles= Get number of strings

file_number = 1
volume = 1

if nFiles
  pause = 1
else
  pause = 0
  writeInfoLine: "View & Edit"
  appendInfoLine: "No files in the specified directory"
endif

## Create corpus table
while pause
  status$ = "no changes"
  file_number = if file_number > nFiles then 1 else file_number fi
  sdPath$ = audio_folder$ + "/" + object$[fileList, file_number]
  sd$ = replace_regex$(sdPath$, ".*/", "", 1)
  basename$ =  sd$ - audio_extension$

  if relative_path
    tgPath$ = sdPath$ - sd$ + "/" + textgrid_folder$ + "/" + basename$ + ".TextGrid"
  else
    tgPath$ = textgrid_folder$ + "/" + basename$ + ".TextGrid"
  endif
  
  # Open a Sound file from the list
  if open_as_LongSound
    sd = Open long sound file: sdPath$
  else
    sd = Read from file: sdPath$
    if adjust_volume
      Formula: "self*'volume'"
    endif
  endif
  
  # If the corresponding textgrid exists, then open it. Otherwise, create it
  if fileReadable(tgPath$)
    # Open the TextGrid
    tg = Read from file: tgPath$
  else
    tg = To TextGrid: all_tier_names$, which_of_these_are_point_tiers$
    status$ = "New TextGrid"
  endif
  
  selectObject: sd
  plusObject: tg
  View & Edit
  
  editor: tg
  if default_values
    Spectrogram settings: min_range, max_range, view_lenght, dynamic_range
    Show analyses: "yes", show_pitch, show_intensity, show_formants, show_pulse, 10
  endif
  
  beginPause: ""
    comment: "Status: 'status$'"
    comment: "Case: 'file_number'/'nFiles'"
    natural: "Next file",  if (file_number + 1) > nFiles then 1 else file_number + 1 fi
    if adjust_volume
      real: "Volume", volume
    endif
  clicked_pause = endPause: "Save", "Jump", "Quit", 1
  endeditor

  if clicked_pause = 1
    selectObject: tb_corpus
    Set numeric value: file_number, "annotation", 1
    Set numeric value: file_number, "all_tiers", 1
    selectObject: tg
    Save as text file: tgPath$
  endif

  removeObject: sd, tg
  file_number = next_file

  if clicked_pause = 3
    pause = 0
  endif
endwhile

removeObject: fileList

if clicked = 2
  runScript: "doEach_open_files.praat"
endif
