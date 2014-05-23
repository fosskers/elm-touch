module Touch.Swipe where

{-| Conversion to, and construction of, Swipe values.
Swipe values should never be made via their Type constructor found
in `Touch.Types`, as internal implementation may change.
Instead, they should be made through the functions found below.

# Swipe Construction
@docs oneFinger, twoFinger, threeFinger

# Conversion
@docs fromTouches
-}

import Touch (Touch)
import Touch.Types (..)
import Touch.Util as Util

---

oneFinger : [LineSeg] -> Swipe
oneFinger = Swipe OneFinger

twoFinger : [LineSeg] -> Swipe
twoFinger = Swipe TwoFinger

threeFinger : [LineSeg] -> Swipe
threeFinger = Swipe ThreeFinger

fromTouches : [Touch] -> Swipe
fromTouches ts = let a t  = ((t.x0,t.y0),(t.x,t.y))
                     dflt = [{x=0, y=0, id=0, x0=0, y0=0, t0=0}]
                 in case length ts of
                      0 -> oneFinger   <| map a dflt
                      1 -> oneFinger   <| map a ts
                      2 -> twoFinger   <| map a ts
                      _ -> threeFinger <| take 3 <| map a ts
