# Copyright 2017 Rolando Muñoz
# Set the default values for the TextGridEditor
#
# Written by Rolando Muñoz A. (24 Sep 2017)
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

@config.init: "../preferences.txt"

beginPause: "Audio settings"
  word: "Audio extension", config.init.return$["audio_extension"]
  boolean: "Adjust volume", number(config.init.return$["adjust_volume"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

@config.setField: "audio_extension", audio_extension$
@config.setField: "adjust_volume", string$(adjust_volume)
open_as_LongSound= if adjust_volume then 0 else 1 fi
@config.setField: "open_as_LongSound", string$(open_as_LongSound)

if clicked = 2
  runScript: "settings_Sound.praat"
endif