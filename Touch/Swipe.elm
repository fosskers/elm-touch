module Touch.Swipe where

import Touch (Touch)
import Touch.Types (..)
import Touch.Util as Util

---

oneFinger : [Vector] -> Swipe
oneFinger = Swipe OneFinger

twoFinger : [Vector] -> Swipe
twoFinger = Swipe TwoFinger

threeFinger : [Vector] -> Swipe
threeFinger = Swipe ThreeFinger

fromTouches : [Touch] -> Swipe
fromTouches ts = let a t = ((t.x0,t.y0),(t.x,t.y))
                 in case length ts of
                      1 -> oneFinger   <| map a ts
                      2 -> twoFinger   <| map a ts
                      _ -> threeFinger <| take 3 <| map a ts
