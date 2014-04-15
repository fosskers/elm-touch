module Touch.Screen where

import Touch

-- Only for testing
import Mouse as M
import Window as W

---

data Cardinal = Up | UpRight | Right | DownRight | Down | DownLeft | Left | UpLeft

data Swipe = Swipe SwipeType Cardinal

data SwipeType = OneFinger | TwoFinger | ThreeFinger

{-
-- | Yields a Cardinal relative to a given fixed location.
relative : (Int,Int) -> Signal Cardinal
-- Should be based off `taps` and `angle`

-- | Yields a Cardinal based off the angle of a swiping Touch.
cardinal : Signal Cardinal
-- Should be based on `swipe`.

swipe : Signal Float (Radians angle representation?)
-- Based on `touches`.
-- Can there not just be `touch` that yields the latest Touch, like
-- Keyboard.arrows does?
-- Note that `taps` also exists (shouldn't it be `tap`?) meaning that single
-- (non-list) outputs are possible.
-}

-- | Calculates the angle between two points on the screen.
-- Based on the standard unit circle. Angles range from
-- pi to -pi.
angle : (Int,Int) -> (Int,Int) -> Float
angle (x1,y1) (x2,y2) = atan2 (toFloat (y2 - y1)) (toFloat (x1 - x2))

render : (Int,Int) -> (Int,Int) -> Element
render mouse center = asText <| angle mouse center

main : Signal Element
main = render <~ M.position ~ ((\(x,y) -> (x `div` 2, y `div` 2)) <~ W.dimensions)
