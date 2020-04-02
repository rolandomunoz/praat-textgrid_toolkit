# Copyright 2017-2019 Rolando Munoz Aramburú

if praatVersion < 6033
  appendInfoLine: "Plug-in name: Annotation Assistant"
  appendInfoLine: "Warning: This plug-in only works on Praat version above 6.0.32. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

# Static menu
Add menu command: "Objects", "Goodies", "TgToolkit", "", 0, ""

## Do 
Add menu command: "Objects", "Goodies", "Open files (TextGridEditor)...", "TgToolkit", 1, "scripts/textgridEditor-open_files.praat"

## Modify
Add menu command: "Objects", "Goodies", "Create", "TgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Sound to TextGrid...", "Create", 2, "scripts/create-textgrid.praat"
Add menu command: "Objects", "Goodies", "Sound to TextGrid (silences)...", "Create", 2, "scripts/create-textgrid_silences.praat"

Add menu command: "Objects", "Goodies", "Modify", "TgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Convert...", "Modify", 2, "scripts/mod-convert.praat"
Add menu command: "Objects", "Goodies", "-", "Modify", 2, ""
Add menu command: "Objects", "Goodies", "Insert tier...", "Modify", 2, "scripts/mod-insert_tier.praat"
Add menu command: "Objects", "Goodies", "Duplicate tier...", "Modify", 2, "scripts/mod-duplicate_tier.praat"
Add menu command: "Objects", "Goodies", "Remove tier...", "Modify", 2, "scripts/mod-remove_tier.praat"
Add menu command: "Objects", "Goodies", "Set tier name...", "Modify", 2, "scripts/mod-set_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Modify", 2, ""
Add menu command: "Objects", "Goodies", "Replace text...", "Modify", 2, "scripts/mod-replace_text.praat"
Add menu command: "Objects", "Goodies", "Replace text (dictionary)...", "Modify", 2, "scripts/mod-replace_text_from_csv.praat"

Add menu command: "Objects", "Goodies", "Query", "TgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Report duration...", "Query", 2, "scripts/query-get_duration.praat"
Add menu command: "Objects", "Goodies", "-", "Query", 2, ""
Add menu command: "Objects", "Goodies", "Create Table word occurrences...", "Query", 2, "scripts/corpus-word_occurrences.praat"
Add menu command: "Objects", "Goodies", "Create Table child/parent...", "Query", 2, "scripts/corpus-child2parent.praat"

Add menu command: "Objects", "Goodies", "Clean", "TgToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Check TextGrid tiers...", "Clean", 2, "scripts/clean-check_tg_tiers.praat"
Add menu command: "Objects", "Goodies", "Check TextGrid white spaces...", "Clean", 2, "scripts/clean-check_tg_whitespaces.praat"
Add menu command: "Objects", "Goodies", "Find TextGrid files if tier name...", "Clean", 2, "scripts/clean-find_tg_if_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Clean", 2, ""
Add menu command: "Objects", "Goodies", "Remove TextGrid white spaces...", "Clean", 2, "scripts/clean-remove_tg_whitespace.praat"

Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "About", "TgToolkit", 1, "scripts/about.praat"

# Dynamic menu
Add action command: "Table", 1, "", 0, "", 0, "TgToolkit", "", 0, ""
Add action command: "Table", 1, "", 0, "", 0, "To TextGridEditor", "TgToolkit", 0, "scripts/dynamic_menu/open_tg_from_table.praat"
