form To TextGridEditor
  comment Folder with annotation files:
  text tgFolder 
  comment Folder with sound files:
  text soundFolder . (= Relative path)
  boolean Adjust_volume 1
  comment Table columns:
  word Filename filename
  word Start_time tmin
  word End_time tmax
endform

tb = selected()
filename = Get column index: filename$
start_time = Get column index: start_time$
end_time = Get column index: end_time$

n_files = object[tb].nrow
file_number = 1
relative_path = if startsWith(soundFolder$, ".") then 1 else 0 fi
sd_subpath$ = if soundFolder$ == ". (= Relative path)" then "." else soundFolder$ fi
tg_ext$ = "TextGrid"
audio_ext$ = ".wav"
volume = 0.99
pause = 1
buttonChoice = 3
pattern$ = "(.+)/(.+)(\..+)"

while pause
  file_number = if file_number > n_files then 1 else file_number fi
  
  # Read from table
  tg$ = object$[tb, file_number, filename]
  tg_norm$ = replace$(tg$, "\", "/", 0)

  # Get tg and sd fullpaths
  tgPath$ = if tgFolder$ == "" then tg_norm$ else tgFolder$ + "/" + tg_norm$ fi
  path$ = replace_regex$(tgPath$, pattern$, "\1", 0)
  basename$ = replace_regex$(tgPath$, pattern$, "\2", 0)

  sd$ = basename$ + audio_ext$
  
  if relative_path
    sdPath$ = path$ + "/" + sd_subpath$ + "/" + sd$
  else
    sdPath$ = sd_subpath$ + "/" + sd$
  endif

  tg = Read from file: tgPath$
  
  if fileReadable(sdPath$)
    if adjust_volume
      sd = Read from file: sdPath$
      Scale peak: volume
    else
      sd = Open long sound file: sdPath$
    endif
    objectList# = {sd, tg}
  else
    objectList# = {tg}
  endif

  selectObject: objectList#
  View & Edit
  editor: tg
  if start_time != 0 and end_time != 0
    tmin = object[tb, file_number, start_time]
    tmax = object[tb, file_number, end_time]

    dur = tmax - tmin
    margin = if dur == 0 then 0.05 else dur*0.1 fi
    Zoom: tmin - margin, tmax + margin
    Select: tmin, tmax
  endif
  
  beginPause: "File browser"
    comment: "Case: 'file_number'/'n_files'"
    natural: "Next file",  if (file_number + 1) > n_files then 1 else file_number + 1 fi
    if adjust_volume
      real: "Volume", volume
    endif
  clicked_pause = endPause: "Save", "Jump", "Quit", buttonChoice
  endeditor

  buttonChoice = clicked_pause 
  if clicked_pause = 1
    selectObject: tg
    Save as text file: tgPath$
  endif
  
  removeObject: objectList#
  file_number = next_file

  if clicked_pause = 3
    pause = 0
  endif
endwhile

selectObject: tb
