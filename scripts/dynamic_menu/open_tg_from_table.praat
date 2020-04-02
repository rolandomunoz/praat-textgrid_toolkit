form To TextGridEditor
  comment Folder with annotation files:
  text tgFolder 
  comment Folder with sound files:
  text audioFolder . (= Relative path)
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
relative_path = if startsWith(audioFolder$, ".") then 1 else 0 fi
audioFolder$ = if audioFolder$ == ". (= Relative path)" then "." else audioFolder$ fi
tg_ext$ = "TextGrid"
audio_ext$ = "wav"
volume = 0.99
pause = 1
buttonChoice = 3

while pause
  file_number = if file_number > n_files then 1 else file_number fi
  
  # Read from table
  tg$ = object$[tb, file_number, filename]
  
  # Get tg and sd fullpaths
  tgFullpath$ = tgFolder$ + "/" + tg$
  path$ = replace_regex$(tgFullpath$, "(.+)/(.+)", "\1", 1)
  basename$ = replace_regex$(tgFullpath$, "(.+)/(.+)", "\2", 1)
  sd$ = basename$ - tg_ext$ + audio_ext$

  if relative_path
    sdFullpath$ = path$ + "/" + audioFolder$ + "/" + sd$
  else
    sdFullpath$ = audioFolder$ + "/" + sd$
  endif
  
  tg = Read from file: tgFullpath$
  
  open_with_sound = if fileReadable(sdFullpath$) then 1 else 0 fi
  if open_with_sound
    if adjust_volume
      sd = Read from file: sdFullpath$
      Scale peak: volume
    else
      sd = Open long sound file: sdFullpath$
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
    dur_10 = dur*0.10
    dur_10 = if dur_10 == 0 then 0.1 fi
    Zoom: tmin - dur_10, tmax + dur_10
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
    Save as text file: tgFullpath$
  endif
  
  removeObject: objectList#
  file_number = next_file

  if clicked_pause = 3
    pause = 0
  endif
endwhile

selectObject: tb
