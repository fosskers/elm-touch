module Touch.Swipe where

import List exposing (..)

{-| Conversion to, and construction of, Swipe values.
Swipe values should never be made via their Type constructor found
in `Touch.Types`, as internal implementation may change.
Instead, they should be made through the functions found below.

# Swipe Construction
@docs oneFinger, twoFinger, threeFinger

# Conversion
@docs fromTouches
-}

import Touch exposing (Touch)
import Touch.Types exposing (..)
import Touch.Util as Util

---

oneFinger : List LineSeg -> Swipe
oneFinger = Swipe OneFinger

twoFinger : List LineSeg -> Swipe
twoFinger = Swipe TwoFinger

threeFinger : List LineSeg -> Swipe
threeFinger = Swipe ThreeFinger

fromTouches : List Touch -> Swipe
fromTouches ts = let a t  = ((t.x0,t.y0),(t.x,t.y))
                     dflt = [{x=0, y=0, id=0, x0=0, y0=0, t0=0}]
                 in case length ts of
                      0 -> oneFinger   <| map a dflt
                      1 -> oneFinger   <| map a ts
                      2 -> twoFinger   <| map a ts
                      _ -> threeFinger <| take 3 <| map a ts
