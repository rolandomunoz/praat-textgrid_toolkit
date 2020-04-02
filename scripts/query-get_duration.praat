# Written by Rolando Munoz (2018-10-19)

include ../procedures/list_recursive_path.proc

form Report duration
  comment Folder with annotation files:
  text tgFolder /home/rolando/corpus
  boolean Recursive_search
  comment Search:
  word Tier_name word
  word Search 
  optionmenu Mode 2
  option is equal to
  option is not equal to
  option contains
  option does not contain
  option matches (regex)
endform

@createStringAsFileList: "fileList", tgFolder$ + "/*.TextGrid", recursive_search
fileList = selected("Strings")
nFiles = Get number of strings

tb_main = Create Table with column names: "table", 0, "tmin tier text tmax filename"

# Read Table
for iFile to nFiles
  tg$ = object$[fileList, iFile]
  tg_fullPath$ = tgFolder$ + "/" + tg$
  tg = Read from file: tg_fullPath$
  tb_temp = Down to Table: "no", 6, "yes", "no"
  Append column: "filename"
  Formula: "filename", ~ tg$
  
  tb_mainTemp = tb_main
  selectObject: tb_temp, tb_mainTemp
  tb_main = Append
  removeObject: tg, tb_mainTemp, tb_temp
endfor

selectObject: tb_main
tb_tier = nowarn Extract rows where column (text): "tier", "is equal to", tier_name$
tb_interval = nowarn Extract rows where column (text): "text", mode$, search$
Rename: "duration"

Append column: "duration"
Formula: "duration", ~self["tmax"] - self["tmin"]

tb_groupReport = Collapse rows: "filename", "duration", "", "", "", ""
groupReport$ = List: 0

# Get total duration
totalDuration = 0
n = object[tb_interval].nrow
for row to n
  totalDuration+= object[tb_interval, row, "duration"]
endfor

# 
q1 = Get quantile: "duration", 0.25
q2 = Get quantile: "duration", 0.5
q3 = Get quantile: "duration", 0.75
min = Get minimum: "duration"
max = Get maximum: "duration"
mean = Get mean: "duration"
sd = Get standard deviation: "duration"

writeInfoLine: "Duration report"
appendInfoLine: "Tier name: ", tier_name$
appendInfoLine: "Search: ", search$
appendInfoLine: "Mode: ", mode$
appendInfoLine: ""
appendInfoLine: "Duration:"
appendInfoLine: "Total duration (s): ", totalDuration
appendInfoLine: "Total duration (m): ", totalDuration div 60, ":" , round(totalDuration mod 60)
appendInfoLine: ""
appendInfoLine: "Summary:"
appendInfoLine: "Min.", tab$, "1st Qu.", tab$, "Median", tab$, "Mean", tab$, "3rd Qu.", tab$, "Max.", tab$, "Sd", tab$, "N"
  appendInfoLine: fixed$(min, 2), tab$, fixed$(q1, 2), tab$, fixed$(q2, 2), tab$, fixed$(mean, 2), tab$, fixed$(q3, 2), tab$, fixed$(max, 2), tab$, fixed$(sd, 2), tab$, n

appendInfoLine: ""
appendInfoLine: "Duration by group:"
appendInfoLine: groupReport$

removeObject: fileList, tb_tier, tb_main, tb_groupReport
selectObject: tb_interval
