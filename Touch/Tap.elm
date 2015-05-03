module Touch.Tap where

import List exposing (..)

{-| Conversion to, and construction of, Tap values.
Tap values should never be made via their Type constructor found
in `Touch.Types`, as internal implementation may change.
Instead, they should be made through the functions found below.

# Tap Construction
@docs oneFinger, twoFinger, threeFinger

# Conversion
@docs fromPrimTap
-}

import Touch.Types exposing (..)

---

oneFinger : List (Int,Int) -> Tap
oneFinger = Tap OneFinger

twoFinger : List (Int,Int) -> Tap
twoFinger = Tap TwoFinger

threeFinger : List (Int,Int) -> Tap
threeFinger = Tap ThreeFinger

{-| Conversion from a primative `Touch.taps` value.
-}
fromPrimTap : {x:Int, y:Int} -> Tap
fromPrimTap {x,y} = oneFinger [(x,y)]
