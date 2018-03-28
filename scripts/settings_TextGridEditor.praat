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

beginPause: "TextGridEditor settings"
  comment: "Apply these settings to EACH FILE?"
  boolean: "Yes", number(config.init.return$["textGridEditor.default_values"])
  comment: "Spectrogram settings..."
  real: "Minimal range", number(config.init.return$["spectrogram.min_range"])
  real: "Maximal range", number(config.init.return$["spectrogram.max_range"])
  real: "Dynamic range", number(config.init.return$["spectrogram.dynamic_range"])
  real: "View length", number(config.init.return$["spectrogram.view_lenght"])
  comment: "Show analyses..."
  boolean: "Show pitch", number(config.init.return$["analysis.pitch"])
  boolean: "Show intensity", number(config.init.return$["analysis.intensity"])
  boolean: "Show formants", number(config.init.return$["analysis.formants"])
  boolean: "Show pulse", number(config.init.return$["analysis.pulse"])
clicked = endPause: "Continue", "Quit", 1

if clicked =2
  exitScript()
endif

@config.setField: "textGridEditor.default_values", string$(yes)
@config.setField: "spectrogram.min_range", string$(minimal_range)
@config.setField: "spectrogram.max_range", string$(maximal_range)
@config.setField: "spectrogram.dynamic_range", string$(dynamic_range)
@config.setField: "spectrogram.view_lenght", string$(view_length)
@config.setField: "analysis.pitch", string$(show_pitch)
@config.setField: "analysis.intensity", string$(show_intensity)
@config.setField: "analysis.formants", string$(show_formants)
@config.setField: "analysis.pulse", string$(show_pulse)