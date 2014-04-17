module Touch.Types where

-- | Represents starting and ending positions of some Swipe.
type Vector = ((Int,Int),(Int,Int))

-- | angles : [Float]
-- Holds the starting and ending positions for each swipe made in one action.
data Swipe = Swipe Fingers [Vector]

data Tap = Tap Fingers [(Int,Int)]

data Fingers = OneFinger | TwoFinger | ThreeFinger
