module Touch.Cardinal where

import Touch.Types (..)
import Touch.Util as Util

---

data Direction = None | Up | UpRight | Right | DownRight | Down | DownLeft | Left | UpLeft

-- | Converts a Swipe's angles to Cardinal directions.
fromSwipe : Swipe -> [Direction]
fromSwipe (Swipe _ vectors) = map (fromAngle . Util.vectorAngle) vectors

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

fromArrows : {x: Int, y: Int} -> Direction
fromArrows {x,y} = if | x == 1  && y == 0  -> right
                      | x == 1  && y == 1  -> upRight
                      | x == 0  && y == 1  -> up
                      | x == -1 && y == 1  -> upLeft
                      | x == 1  && y == -1 -> downRight
                      | x == 0  && y == -1 -> down
                      | x == -1 && y == -1 -> downLeft
                      | x == -1 && y == 0  -> left
                      | otherwise          -> none

none : Direction
none = None

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
