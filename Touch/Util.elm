module Touch.Util where

import Touch
import Touch.Types (Vector)

---

-- | Calculates the angle between two points on the screen.
-- Based on the standard unit circle. Angles range from
-- pi to -pi.
-- (x1,y1) is the starting point, (x2,y2) are the destination point.
angle : (Int,Int) -> (Int,Int) -> Float
angle (x1,y1) (x2,y2) = atan2 (toFloat (y1 - y2)) (toFloat (x2 - x1))

-- | The angle of a Vector.
vectorAngle : Vector -> Float
vectorAngle = uncurry angle

-- | Determines if a given Touch started and ended on the same pixel.
isTap : Touch.Touch -> Bool
isTap {x,y,x0,y0} = x0 == x && y0 == y

{- Calculates the whole-number distance between two points.
-}
distance : (Int,Int) -> (Int,Int) -> Int
distance (x1,y1) (x2,y2) = let a = x2 - x1
                               b = y2 - y1
                           in sqrt <| (a ^ 2) + (b ^ 2)
