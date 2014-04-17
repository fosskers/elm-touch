module Touch.Types where

-- | angles : [Float]
-- Holds an angle for each swipe made in one action.
data Swipe = Swipe Fingers [Float]

data Tap = Tap Fingers [(Int,Int)]

data Fingers = OneFinger | TwoFinger | ThreeFinger
