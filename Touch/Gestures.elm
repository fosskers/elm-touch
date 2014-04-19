module Touch.Gestures where

{-| A library for touch gestures one can make on a mobile device.

# Swipe Gestures
@docs slide, swipe, ray

# Taps
@docs tap, relative
-}

import Mouse
import Touch
import Touch.Types (..)
import Touch.Tap as Tap
import Touch.Util as Util
import Touch.Swipe as Swipe
import Touch.Cardinal as Cardinal

---

{-| An on-going Swipe action. Updates as the user's finger moves.
Can be performed with up to three fingers.
-}
slide : Signal Swipe
slide = let dflt  = [{x=0, y=0, id=0, x0=0, y0=0, t0=0}]
            ok ts = not (isEmpty ts) && not (Util.isTap <| head ts)
        in Swipe.fromTouches <~ keepIf ok dflt Touch.touches

{-| A single Swipe action. Activates when the user has finished their swipe
and released their finger from the screen.
-}
swipe : Signal Swipe
swipe = let dflt   = Swipe.oneFinger [((0,0),(1,1))]
--            action = foldp (\s _ -> s) dflt <| keepWhen Mouse.isDown dflt slide
        in keepWhen (not <~ Mouse.isDown) dflt slide

{-| Yields a Cardinal Direction based off the angle of a Swipe.
Defaults to the first Swipe given by `swipe` regardless of fingers used.
-}
ray : Signal Cardinal.Direction
ray = (head . Cardinal.fromSwipe) <~ swipe

{-| A standard, one finger tap action.
-}
tap : Signal Tap
tap = (\{x,y} -> Tap.oneFinger [(x,y)]) <~ Touch.taps

-- multiTap : Signal Tap
-- multiTap = ... -- Depends on tap timing. Based on `Touch.touches`

{-| Yields a Cardinal Direction relative to a given fixed location.
-}
relative : (Int,Int) -> Signal Cardinal.Direction
relative fixed = (\{x,y} -> Cardinal.fromAngle <| Util.angle fixed (x,y)) <~ Touch.taps
