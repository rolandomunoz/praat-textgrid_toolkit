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
Add menu command: "Objects", "Goodies", "tgToolkit", "", 0, ""

## Do 
Add menu command: "Objects", "Goodies", "Open files (TextGridEditor)...", "tgToolkit", 1, "scripts/textgridEditor_open_files.praat"

## Modify
Add menu command: "Objects", "Goodies", "Create", "tgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Create TextGrid...", "Create", 2, "scripts/create_textgrid.praat"
Add menu command: "Objects", "Goodies", "Create TextGrid (silences)...", "Create", 2, "scripts/create_textgrid_silences.praat"

Add menu command: "Objects", "Goodies", "Modify", "tgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Insert tier...", "Modify", 2, "scripts/mod_insert_tier.praat"
Add menu command: "Objects", "Goodies", "Duplicate tier...", "Modify", 2, "scripts/mod_duplicate_tier.praat"
Add menu command: "Objects", "Goodies", "Remove tier...", "Modify", 2, "scripts/mod_remove_tier.praat"
Add menu command: "Objects", "Goodies", "Set tier name...", "Modify", 2, "scripts/mod_set_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Modify", 2, ""
Add menu command: "Objects", "Goodies", "Replace text...", "Modify", 2, "scripts/mod_replace_text.praat"
Add menu command: "Objects", "Goodies", "Replace text (dictionary)...", "Modify", 2, "scripts/mod_replace_text_from_csv.praat"

Add menu command: "Objects", "Goodies", "Query", "tgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Get info from annotation files...", "Query", 2, "scripts/get_textgrid_report.praat"
Add menu command: "Objects", "Goodies", "Find annotation files with...", "Query", 2, "scripts/find_tg_with.praat"
Add menu command: "Objects", "Goodies", "Report duration...", "Query", 2, "scripts/get_duration.praat"

Add menu command: "Objects", "Goodies", "Corpus", "tgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Create word occurrences corpus...", "Corpus", 2, "scripts/corpus_word_occurrences.praat"
Add menu command: "Objects", "Goodies", "Create child/parent corpus...", "Corpus", 2, "scripts/corpus_child2parent.praat"

Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "About", "tgToolkit", 1, "scripts/about.praat"

# Dynamic menu
Add action command: "TextGrid", 1, "", 0, "", 0, "Report duration...", "Get total duration", 2, "scripts/dynamic_menu/get_duration_by_tier.praat"

Add action command: "Table", 1, "", 0, "", 0, "Annotation tools", "", 0, ""
Add action command: "Table", 1, "", 0, "", 0, "Open annotation files...", "Annotation tools", 1, "scripts/dynamic_menu/open_tg_from_table.praat"
