# Written by Rolando Munoz (2018-10-19)

include ../../procedures/list_recursive_path.proc

form Report duration
  natural Tier_number 1
  word Search 
  optionmenu Mode 2
  option is equal to
  option is not equal to
  option contains
  option does not contain
  option matches (regex)
endform

tg = selected("TextGrid")
tier_name$ = Get tier name: tier_number
tg$ = selected$("TextGrid")

tb_tg2tb = Down to Table: "no", 6, "yes", "no"
tb_tier = nowarn Extract rows where column (text): "tier", "is equal to", tier_name$
tb_duration = nowarn Extract rows where column (text): "text", mode$, search$
Rename: "duration"
Append column: "object_name"
Append column: "duration"
Formula: "object_name", ~ tg$
Formula: "duration", ~self["tmax"] - self["tmin"]

selectObject: tb_duration
# Get total duration
totalDuration = 0
n = object[tb_duration].nrow
for row to n
  totalDuration+= object[tb_duration, row, "duration"]
endfor

q1 = Get quantile: "duration", 0.25
q2 = Get quantile: "duration", 0.5
q3 = Get quantile: "duration", 0.75
min = Get minimum: "duration"
max = Get maximum: "duration"
mean = Get mean: "duration"
sd = Get standard deviation: "duration"

writeInfoLine: "Duration report"
appendInfoLine: "Total duration (s):", tab$, totalDuration
appendInfoLine: "Total duration (m):", tab$, totalDuration div 60, "." , round(totalDuration mod 60)
appendInfoLine: ""
appendInfoLine: "Summary:"
appendInfoLine: "Min.", tab$, "1st Qu.", tab$, "Median", tab$, "Mean", tab$, "3rd Qu.", tab$, "Max.", tab$, "sd", tab$, "n"
  appendInfoLine: fixed$(min, 2), tab$, fixed$(q1, 2), tab$, fixed$(q2, 2), tab$, fixed$(mean, 2), tab$, fixed$(q3, 2), tab$, fixed$(max, 2), tab$, fixed$(sd, 2), tab$, n

removeObject: tb_tg2tb, tb_tier, tb_duration
selectObject: tg

