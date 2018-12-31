# This script modify the tiers in a TextGrid, so it moves them or creates
# new ones.
#
# Written by Rolando Munoz A. (28 March 2018)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form Add tiers
  sentence Add_tiers
  sentence Which_of_these_are_point_tiers
endform

tg= selected()
n_tgTiers= Get number of tiers

strTiers= Create Strings as tokens: add_tiers$, " "
n_strTiers= Get number of strings

strPointTiers= Create Strings as tokens: which_of_these_are_point_tiers$, " "
nPointTiers= Get number of strings
Sort
wordPointTiers= To WordList

newPosition= 0
oldPosition= 0


selectObject: tg
for i to n_strTiers
  isName= 0
  strTier$= object$[strTiers, i]
  
  # Match name 
  for j to n_tgTiers
    tgTier$= Get tier name: j
    if strTier$= tgTier$
      isName= 1
      newPosition= j
      j= n_tgTiers
    endif
  endfor

  if isName
    if newPosition < oldPosition
      Duplicate tier: newPosition, oldPosition+1, strTier$
      Remove tier: newPosition
      newPosition= oldPosition
    endif
  else
    selectObject: wordPointTiers
    isInterval= Has word: strTier$
    
    selectObject: tg
    newPosition+=1
    if isInterval
      Insert point tier: newPosition, strTier$
    else
      Insert interval tier: newPosition, strTier$
    endif
    n_tgTiers+=1
  endif
  oldPosition= newPosition
endfor

removeObject: strTiers, strPointTiers, wordPointTiers