module Touch.Util where

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
