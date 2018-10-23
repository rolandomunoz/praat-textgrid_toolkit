# Copyright 2017 Rolando Munoz Aramburú

if praatVersion < 6033
  appendInfoLine: "Plug-in name: Annotation Assistant"
  appendInfoLine: "Warning: This plug-in only works on Praat version above 6.0.32. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

if not fileReadable("preferences.txt")
  preferences$ = readFile$("preferences_default.txt")
  writeFile: "preferences.txt", preferences$
endif

# Static menu
Add menu command: "Objects", "Goodies", "Annotation Tools", "", 0, ""

## Do 
Add menu command: "Objects", "Goodies", "Open files (TextGridEditor)...", "Annotation Tools", 1, "scripts/textgridEditor_open_files.praat"

## Modify
Add menu command: "Objects", "Goodies", "Create", "Annotation Tools", 1, ""
Add menu command: "Objects", "Goodies", "Create TextGrid...", "Create", 2, "scripts/doAll_create_textgrid.praat"
Add menu command: "Objects", "Goodies", "Create TextGrid (silences)...", "Create", 2, "scripts/doAll_create_textgrid_silences.praat"

Add menu command: "Objects", "Goodies", "Modify", "Annotation Tools", 1, ""
Add menu command: "Objects", "Goodies", "Insert tier...", "Modify", 2, "scripts/doAll_insert_tier.praat"
Add menu command: "Objects", "Goodies", "Duplicate tier...", "Modify", 2, "scripts/doAll_duplicate_tier.praat"
Add menu command: "Objects", "Goodies", "Remove tier...", "Modify", 2, "scripts/doAll_remove_tier.praat"
Add menu command: "Objects", "Goodies", "Set tier name...", "Modify", 2, "scripts/doAll_set_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Modify", 2, ""
Add menu command: "Objects", "Goodies", "Replace text...", "Modify", 2, "scripts/doAll_replace_text.praat"
Add menu command: "Objects", "Goodies", "Replace text (dictionary)...", "Modify", 2, "scripts/doAll_replace_text_from_csv.praat"

Add menu command: "Objects", "Goodies", "Query", "Annotation Tools", 1, ""
Add menu command: "Objects", "Goodies", "Get TextGrid report...", "Query", 2, "scripts/get_textgrid_report.praat"
Add menu command: "Objects", "Goodies", "Report duration...", "Query", 2, "scripts/get_duration.praat"

Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "About", "Annotation Tools", 1, "scripts/about.praat"

# Dynamic menu
Add action command: "TextGrid", 1, "", 0, "", 0, "Report duration...", "Get total duration", 2, "scripts/dynamic_menu/get_duration_by_tier.praat"
