module Touch.Gestures where

{-| A library for touch gestures one can make on a mobile device.

# Swipes
@docs slide, swipe, ray

# Taps
@docs tap, relative, relativeWithin
-}

import Touch
import Touch.Types (..)
import Touch.Tap as Tap
import Touch.Util as Util
import Touch.Swipe as Swipe
import Touch.Cardinal as Cardinal
import Touch.Signal.Derived as Derived

---

{-| An on-going Swipe action. Updates as the user's finger moves.
Can be performed with up to three fingers.
-}
slide : Signal Swipe
slide = let ok ts = not (isEmpty ts) && not (Util.isTap <| head ts)
        in Swipe.fromTouches <~ keepIf ok [] Touch.touches

swipePred : Signal Bool
swipePred = (\ts -> length ts == 0) <~ Touch.touches

{-| A single Swipe action. Activates when the user has finished their swipe
and released their finger from the screen.
-}
swipe : Signal Swipe
swipe = Swipe.fromTouches <~ keepWhen swipePred [] Touch.touches

data TouchDragState = Dragging | TouchJustStarted | TouchJustFinished | DragJustFinished Swipe | NotDragging

processTouchDragging :  [Touch.Touch] -> (TouchDragState, [Touch.Touch]) -> (TouchDragState, [Touch.Touch])
processTouchDragging ts (prevState, prevTouches) = 
  let
    touching = length ts > 0
  in
    if touching then
      case prevState of
        NotDragging -> (TouchJustStarted, ts)
        TouchJustFinished -> (TouchJustStarted, ts)
        TouchJustStarted -> (Dragging, ts)
        Dragging -> (Dragging, ts)
        DragJustFinished _ -> (TouchJustStarted, ts)
   else
     case prevState of
        NotDragging -> (NotDragging, [])
        TouchJustFinished -> (NotDragging, [])
        TouchJustStarted -> (TouchJustFinished, [])
        Dragging -> (DragJustFinished (Swipe.fromTouches prevTouches), [])
        DragJustFinished _ -> (NotDragging, [])
       
touchDragState : Signal (TouchDragState, [Touch.Touch])
touchDragState = foldp processTouchDragging (NotDragging, []) Touch.touches

{-| Yields a Cardinal Direction based off the angle of a Swipe.
Defaults to the first Swipe given by `swipe` regardless of fingers used.
-}
ray : Signal Cardinal.Direction
ray = (head . f) <~ touchDragState

f : (TouchDragState, [Touch.Touch]) -> [Cardinal.Direction]
f (tds, _) = 
  case tds of
    DragJustFinished sw -> Cardinal.fromSwipe sw
    _ -> [Cardinal.Nowhere]


{-| A standard, one finger tap action.
-}
tap : Signal Tap
tap = (\{x,y} -> Tap.oneFinger [(x,y)]) <~ Touch.taps

-- multiTap : Signal Tap
-- multiTap = ... -- Depends on tap timing. Based on `Touch.touches`

{-| Yields a Cardinal Direction relative to a given fixed location.
-}
relative : (Int,Int) -> Signal Cardinal.Direction
relative fixed = relativeImp fixed . (\{x,y} -> (x,y)) <~ Touch.taps

relativeImp : (Int,Int) -> (Int,Int) -> Cardinal.Direction
relativeImp (xf, yf) (x,y) = Cardinal.vector2ToCardinal <| Util.lineSegToVector2 ((xf,yf), (x,y))

{-| Yields a Cardinal Direction relative to a given fixed location,
but only within a certain distance. Can be used to implement
a D-Pad in an app with a certain "area of effectiveness". That is,
clicks that are too far away from the D-Pad (say, hitting other buttons)
won't activate the D-Pad.
-}
relativeWithin : Int -> (Int,Int) -> Signal Cardinal.Direction
relativeWithin dis ((xf, yf) as fixed) =
    let ok {x,y}    = Util.distance fixed (x,y) <= dis
        cardinal {x,y} = relativeImp fixed (x,y)
    in cardinal <~ keepIf ok {x=0,y=0} Touch.taps
