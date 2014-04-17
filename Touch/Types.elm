module Touch.Types where

data Cardinal = Up | UpRight | Right | DownRight | Down | DownLeft | Left | UpLeft

-- | angles : [Float]
-- Holds an angle for each swipe made in one action.
data Swipe = Swipe Fingers [Float]

data Fingers = OneFinger | TwoFinger | ThreeFinger
