# Open one by one, all the audio files and their TextGrids in the specified directory
# If the TextGrid does not exist, then create a new one
#
# Written by Rolando Munoz A. (24 April 2018)
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

beginPause: "View & Edit when"
  comment: "The directories where your files are stored..."
  sentence: "Audio folder", config.init.return$["run_plugin.audio_dir"]
  sentence: "Textgrid folder", config.init.return$["run_plugin.textgrid_dir"]
  boolean: "Recursive search", number(config.init.return$["run_plugin.recursive_search"])
  comment: "View & Edit files..."
  optionMenu: "When", 1
    option: "TextGrid is empty"
    option: "tier is empty"
    option: "TextGrid does not contain"
    option: "TextGrid contains"
    sentence: "Tier names", ""
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

writeInfoLine: "View & Edit when:"
appendInfoLine: "Sorry, this command is not available yet."
exitScript()

# Save the values from the dialogue box
@config.setField: "run_plugin.audio_dir", audio_folder$
@config.setField: "run_plugin.textgrid_dir", textgrid_folder$

# Check dialogue box
if textgrid_folder$ == ""
  pauseScript: "The field 'Textgrid folder' is empty. Please complete it"
  runScript: "run_plugin.praat"
  exitScript()
elsif
  pauseScript: "The field 'All tier names$' is empty. Please complete it"
  runScript: "run_plugin.praat"
  exitScript()
endif

# Get audio preferences from preferences.txt
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
@createStringAsFileList: "fileList", audio_folder$ + "/*'audio_extension$'", recursive_search
fileList= selected("Strings")

file_number = 1
volume = 1
pause = 1

writeInfoLine: "Sorry, this command is not available yet."
exitScript()
## Create corpus table
while pause
  file_number = if file_number > number_of_files then 1 else file_number fi
  sdPath$= object$[fileList, file_number]
  
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
  if annotation
    # Open the TextGrid
    tg = Read from file: tgPath$
  endif
  
  selectObject: sd
  if annotation
    plusObject: tg
  endif
  View & Edit
  
  editor: tg
  if default_values
    Spectrogram settings: min_range, max_range, view_lenght, dynamic_range
    Show analyses: "yes", show_pitch, show_intensity, show_formants, show_pulse, 10
  endif
  
  beginPause: "Audio transcriber"
    comment: "Status: 'status$'"
    comment: "Case: 'file_number'/'number_of_files'"
    natural: "Next file",  if (file_number + 1) > number_of_files then 1 else file_number + 1 fi
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
    removeObject: tb_corpus
    pause = 0
  endif
endwhile

if clicked = 2
  runScript: "run_plugin.praat"
endif
