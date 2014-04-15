module Touch.Screen where

import Touch

---

data Cardinal = Up | UpRight | Right | DownRight | Down | DownLeft | Left | UpLeft

{-
-- | Yields a Cardinal relative to a given fixed location.
relative : (Int,Int) -> Signal Cardinal

-- | Yields a Cardinal based off the angle of a swiping Touch.
cardinal : Signal Cardinal
-- Should be based on `swipe`.

swipe : Signal (Radians angle representation?)
-- Based on `touches`.
-- Can there not just be `touch` that yields the latest Touch, like
-- Keyboard.arrows does?
-- Note that `taps` also exists (shouldn't it be `tap`?) meaning that single
-- (non-list) outputs are possible.
-}
