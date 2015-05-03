module Touch.Types where

{-| Data types for values used in `Touch.*` libraries.
-}

{-| 2D vector
-}
type alias Vector2 = (Float, Float)

{-| Represents starting and ending positions of some Swipe.
-}
type alias LineSeg = ((Int,Int),(Int,Int))

{-| A basic swiping action made on a screen.
Knows how many fingers were involved, and stores a Vector for each finger.
-}
type Swipe = Swipe Fingers (List LineSeg)

{-| A more concrete data type than what is provided by `Touch.taps`.
Also knows how many fingers were involved in a multifinger tap.
-}
type Tap = Tap Fingers (List (Int,Int))

type Fingers = OneFinger | TwoFinger | ThreeFinger
