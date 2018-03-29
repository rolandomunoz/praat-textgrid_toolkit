# Copyright 2017 Rolando Muñoz Aramburú

if praatVersion < 6033
  appendInfoLine: "Plug-in name: Annotation Assistant"
  appendInfoLine: "Warning: This plug-in only works on Praat version above 6.0.32. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif
## Static menu
Add menu command: "Objects", "Goodies", "Annotation assistant", "", 0, ""
Add menu command: "Objects", "Goodies", "Run plug-in...", "Annotation assistant", 1, "scripts/run_plugin.praat"
Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "Audio preferences...", "Audio transcriber", 1, "scripts/settings_Sound.praat"
Add menu command: "Objects", "Goodies", "TextGridEditor preferences...", "Audio transcriber", 1, "scripts/settings_TextGridEditor.praat"
Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "About", "Annotation assistant", 1, "scripts/about.praat"