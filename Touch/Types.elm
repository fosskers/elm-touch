module Touch.Types where

{-| Data types for values used in `Touch.*` libraries.
-}

{-| 2D vector
-}
type Vector2 = (Float, Float)

{-| Represents starting and ending positions of some Swipe.
-}
type LineSeg = ((Int,Int),(Int,Int))

{-| A basic swiping action made on a screen.
Knows how many fingers were involved, and stores a Vector for each finger.
-}
data Swipe = Swipe Fingers [LineSeg]

{-| A more concrete data type than what is provided by `Touch.taps`.
Also knows how many fingers were involved in a multifinger tap.
-}
data Tap = Tap Fingers [(Int,Int)]

data Fingers = OneFinger | TwoFinger | ThreeFinger
