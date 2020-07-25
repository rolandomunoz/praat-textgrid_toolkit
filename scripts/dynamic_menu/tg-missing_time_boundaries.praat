# Written by Rolando Muñoz (2020-07-24)
# Checks if the boundaries from a tier exists in other tiers. Outputs a Table object.

form Tabulate bad aligments
  comment Get the mismatched boundaries of the source tier in target tier
  natural Target_tier 2
  natural Source_tier 1
endform
 
tg = selected("TextGrid")

@diff_times: source_tier, target_tier

include ../../procedures/intervalpoint.proc
