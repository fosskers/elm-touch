module Touch.Tap where

{-| Conversion to, and construction of, Tap values.
Tap values should never be made via their Type constructor found
in `Touch.Types`, as internal implementation may change.
Instead, they should be made through the functions found below.

# Tap Construction
@docs oneFinger, twoFinger, threeFinger

# Conversion
@docs fromPrimTap
-}

import Touch.Types (..)

---

oneFinger : [(Int,Int)] -> Tap
oneFinger = Tap OneFinger

twoFinger : [(Int,Int)] -> Tap
twoFinger = Tap TwoFinger

threeFinger : [(Int,Int)] -> Tap
threeFinger = Tap ThreeFinger

{-| Conversion from a primative `Touch.taps` value.
-}
fromPrimTap : {x:Int, y:Int} -> Tap
fromPrimTap {x,y} = oneFinger [(x,y)]
