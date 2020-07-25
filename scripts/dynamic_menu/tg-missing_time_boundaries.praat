# Written by Rolando Muñoz (2020-07-24)
# This script checks if the boundaries from a tier exists in other tiers.
# When a boundary is not found, a Table with this information is created.

form Missing (interval or point) time boundaries
  comment Report the mismatching boundaries of Source tier in  Destiny tier
  natural Source_tier 1
  natural Destiny_tier 2
endform
 
tg = selected("TextGrid")

@diff_times: source_tier, destiny_tier

include ../../procedures/intervalpoint.proc
