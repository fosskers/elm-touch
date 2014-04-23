module Touch.Cardinal where

{-| Conversion to Cardinal.Direction values.
Cardinal Directions represent the eight standard directions one might
find on a compass or map.

# Conversion
@docs fromSwipe, fromAngle, fromArrows

# Directions
@docs nowhere, up, upRight, right, downRight, down, downLeft, left, upLeft
-}

import Touch.Types (..)
import Touch.Util as Util

---

data Direction = Nowhere | Up | UpRight | Right | DownRight | Down | DownLeft | Left | UpLeft

{-| Conversion from a Swipe's vectors' angles to Cardinal directions.
Useful for gestures/actions where only the direction - not the position - of
the gesture matters.

    allDown : Swipe -> Bool
    allDown = and . map (\d -> d == down) . Cardinal.fromSwipe
-}
fromSwipe : Swipe -> [Direction]
fromSwipe (Swipe _ vectors) = map (fromAngle . Util.vectorAngle) vectors

{-| Conversion from a radian angle to a Cardinal Direction.

    angleBetweenPoints : Signal Cardinal.Direction
    angleBetweenPoints = let toTup {x,y} = (x,y)
    (fromAngle . Util.angle) <~ UNFINISHED
-}
fromAngle : Float -> Direction
fromAngle a = let bw a b1 b2 = a >= b1 && b2 > a
              in if | bw a (-pi/8) (pi/8)              -> right
                    | bw a (pi/8) (3 * pi / 8)         -> upRight
                    | bw a (3 * pi / 8) (5 * pi / 8)   -> up
                    | bw a (5 * pi / 8) (7 * pi / 8)   -> upLeft
                    | bw a (-3 * pi / 8) (-pi / 8)     -> downRight
                    | bw a (-5 * pi / 8) (-3 * pi / 8) -> down
                    | bw a (-7 * pi / 8) (-5 * pi / 8) -> downLeft
                    | otherwise                        -> left

{-| Conversion from Keyboard.arrows values.
Note that unlike when dealing with angles in `fromAngle`, where any
angle on the unit circle will yield a Direction, here, an input of
`{x=0, y=0}` is a valid key position, but there is no angle to speak of.
In such a case the functions yields `Nowhere`, the "empty" direction.
-}
fromArrows : {x: Int, y: Int} -> Direction
fromArrows {x,y} = if | x == 1  && y == 0  -> right
                      | x == 1  && y == 1  -> upRight
                      | x == 0  && y == 1  -> up
                      | x == -1 && y == 1  -> upLeft
                      | x == 1  && y == -1 -> downRight
                      | x == 0  && y == -1 -> down
                      | x == -1 && y == -1 -> downLeft
                      | x == -1 && y == 0  -> left
                      | otherwise          -> nowhere

nowhere : Direction
nowhere = Nowhere

up : Direction
up = Up

upRight : Direction
upRight = UpRight

right : Direction
right = Right

downRight : Direction
downRight = DownRight

down : Direction
down = Down

downLeft : Direction
downLeft = DownLeft

left : Direction
left = Left

upLeft : Direction
upLeft = UpLeft
