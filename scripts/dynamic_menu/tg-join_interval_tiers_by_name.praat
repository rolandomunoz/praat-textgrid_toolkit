#Written by Rolando Muñoz (2020)
## Merge tiers with the same name

tg_name$ = selected$("TextGrid")
tg = Copy: tg_name$

n_tiers = Get number of tiers
for i_tier to n_tiers
  tier_name1$ = Get tier name: i_tier
  start_tier = i_tier + 1
  for j_tier from start_tier to n_tiers
    tier_name2$ = Get tier name: j_tier
    if tier_name1$ == tier_name2$
      runScript: "tg-join_interval_tiers.praat", j_tier, i_tier
      Remove tier: j_tier
      j_tier -=1
      n_tiers -=1
    endif
  endfor
endfor
