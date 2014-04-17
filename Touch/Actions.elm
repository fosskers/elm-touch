module Touch.Actions where

import Touch
import Touch.Types (..)
import Touch.Tap as Tap
import Touch.Swipe as Swipe
import Touch.Cardinal as Cardinal

---

-- | Yields a Cardinal Direction relative to a given fixed location.
relative : (Int,Int) -> Signal Cardinal.Direction
relative fixed = (\{x,y} -> Cardinal.fromAngle <| angle fixed (x,y)) <~ Touch.taps

-- | Yields a Cardinal Direction based off the angle of a swiping Touch.
-- Defaults to the first Swipe given by `swipe` regardless of SwipeType.
cardinal : Signal Cardinal.Direction
cardinal = (head . Cardinal.fromSwipe) <~ swipe

-- | Yields a Swipe. Swipes can be with one to three fingers.
swipe : Signal Swipe
swipe = let dflt  = [{x=0, y=0, id=0, x0=0, y0=0, t0=0}]
            ok ts = not (isEmpty ts) && not (isTap <| head ts)
            a t   = angle (t.x0,t.y0) (t.x,t.y)
            f sw  = case length sw of
                     1 -> Swipe.oneFinger   <| map a sw
                     2 -> Swipe.twoFinger   <| map a sw
                     _ -> Swipe.threeFinger <| take 3 <| map a sw
        in f <~ keepIf ok dflt Touch.touches

-- | A standard, one finger tap action.
tap : Signal Tap
tap = (\{x,y} -> Tap.oneFinger [(x,y)]) <~ Touch.taps

-- multiTap : Signal Tap
-- multiTap = ... -- Depends on tap timing. Based on `Touch.touches`

-- | Calculates the angle between two points on the screen.
-- Based on the standard unit circle. Angles range from
-- pi to -pi.
-- (x1,y1) is the starting point, (x2,y2) are the destination point.
angle : (Int,Int) -> (Int,Int) -> Float
angle (x1,y1) (x2,y2) = atan2 (toFloat (y1 - y2)) (toFloat (x2 - x1))

-- | Determines if a given Touch started and ended on the same pixel.
isTap : Touch.Touch -> Bool
isTap {x,y,x0,y0} = x0 == x && y0 == y
