# Copyright 2017 Rolando Muñoz Aramburú

if praatVersion < 6033
  appendInfoLine: "Plug-in name: Annotation Assistant"
  appendInfoLine: "Warning: This plug-in only works on Praat version above 6.0.32. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif
## Static menu
Add menu command: "Objects", "Goodies", "Annotation assistant", "", 0, ""
Add menu command: "Objects", "Goodies", "Run...", "Annotation assistant", 1, "scripts/run_plugin.praat"
Add menu command: "Objects", "Goodies", "Do all", "Annotation assistant", 1, ""
Add menu command: "Objects", "Goodies", "Insert tier...", "Do all", 2, "scripts/doAll_insert_tier.praat"
Add menu command: "Objects", "Goodies", "Duplicate tier...", "Do all", 2, "scripts/doAll_duplicate_tier.praat"
Add menu command: "Objects", "Goodies", "Remove tier...", "Do all", 2, "scripts/doAll_remove_tier.praat"
Add menu command: "Objects", "Goodies", "Set tier name...", "Do all", 2, "scripts/doAll_set_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Do all", 2, ""
Add menu command: "Objects", "Goodies", "Replace tier text...", "Do all", 2, "scripts/doAll_replace_tier_text.praat"

#Add menu command: "Objects", "Goodies", "TextGrids report...", "Do all", 2, "scripts/daAll_tg_report.praat"

Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "Audio preferences...", "Audio transcriber", 1, "scripts/settings_Sound.praat"
Add menu command: "Objects", "Goodies", "TextGridEditor preferences...", "Audio transcriber", 1, "scripts/settings_TextGridEditor.praat"
Add menu command: "Objects", "Goodies", "Reset preferences", "Audio transcriber", 1, "scripts/settings_default_preferences.praat"
Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "About", "Annotation assistant", 1, "scripts/about.praat"