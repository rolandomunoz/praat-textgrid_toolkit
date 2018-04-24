# Copyright 2017 Rolando Munoz Aramburú

if praatVersion < 6033
  appendInfoLine: "Plug-in name: Annotation Assistant"
  appendInfoLine: "Warning: This plug-in only works on Praat version above 6.0.32. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

# Static menu
Add menu command: "Objects", "Goodies", "Annotation assistant", "", 0, ""

## Do each
Add menu command: "Objects", "Goodies", "Do each", "Annotation assistant", 1, ""
Add menu command: "Objects", "Goodies", "View & Edit...", "Do each", 2, "scripts/doEach_open_files.praat"
Add menu command: "Objects", "Goodies", "View & Edit (advanced)...", "Do each", 2, "scripts/doEach_open_files_advanced.praat"
Add menu command: "Objects", "Goodies", "View & Edit when...", "Do each", 2, "scripts/doEach_open_files_when.praat"

## Do all
Add menu command: "Objects", "Goodies", "Do all", "Annotation assistant", 1, ""
Add menu command: "Objects", "Goodies", "Create TextGrid...", "Do all", 2, "scripts/doAll_create_textgrid.praat"
Add menu command: "Objects", "Goodies", "Create TextGrid (silences)...", "Do all", 2, "scripts/doAll_create_textgrid_silences.praat"
Add menu command: "Objects", "Goodies", "-", "Do all", 2, ""
Add menu command: "Objects", "Goodies", "Insert tier...", "Do all", 2, "scripts/doAll_insert_tier.praat"
Add menu command: "Objects", "Goodies", "Duplicate tier...", "Do all", 2, "scripts/doAll_duplicate_tier.praat"
Add menu command: "Objects", "Goodies", "Remove tier...", "Do all", 2, "scripts/doAll_remove_tier.praat"
Add menu command: "Objects", "Goodies", "Set tier name...", "Do all", 2, "scripts/doAll_set_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Do all", 2, ""
Add menu command: "Objects", "Goodies", "Replace tier text...", "Do all", 2, "scripts/doAll_replace_tier_text.praat"

Add menu command: "Objects", "Goodies", "Query", "Annotation assistant", 1, ""
Add menu command: "Objects", "Goodies", "Get TextGrid report...", "Query", 2, "scripts/get_textgrid_report.praat"

Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "Audio preferences...", "Audio transcriber", 1, "scripts/settings_Sound.praat"
Add menu command: "Objects", "Goodies", "TextGridEditor preferences...", "Audio transcriber", 1, "scripts/settings_TextGridEditor.praat"
Add menu command: "Objects", "Goodies", "Reset preferences", "Audio transcriber", 1, "scripts/settings_default_preferences.praat"
Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "About", "Annotation assistant", 1, "scripts/about.praat"