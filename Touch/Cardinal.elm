module Touch.Cardinal where

import Touch.Types (..)

---

-- | Converts a Swipe's angles to Cardinal directions.
fromSwipe : Swipe -> [Cardinal]
fromSwipe (Swipe _ angles) = map fromAngle angles

fromAngle : Float -> Cardinal
fromAngle a = let bw a b1 b2 = a >= b1 && b2 > a
              in if | bw a (-pi/8) (pi/8)              -> right
                    | bw a (pi/8) (3 * pi / 8)         -> upRight
                    | bw a (3 * pi / 8) (5 * pi / 8)   -> up
                    | bw a (5 * pi / 8) (7 * pi / 8)   -> upLeft
                    | bw a (-3 * pi / 8) (-pi / 8)     -> downRight
                    | bw a (-5 * pi / 8) (-3 * pi / 8) -> down
                    | bw a (-7 * pi / 8) (-5 * pi / 8) -> downLeft
                    | otherwise                        -> left

fromArrows : {x: Int, y: Int} -> Cardinal
fromArrows {x,y} = if | x == 1  && y == 0  -> right
                      | x == 1  && y == 1  -> upRight
                      | x == 0  && y == 1  -> up
                      | x == -1 && y == 1  -> upLeft
                      | x == 1  && y == -1 -> downRight
                      | x == 0  && y == -1 -> down
                      | x == -1 && y == -1 -> downLeft
                      | otherwise          -> left

up : Cardinal
up = Up

upRight : Cardinal
upRight = UpRight

right : Cardinal
right = Right

downRight : Cardinal
downRight = DownRight

down : Cardinal
down = Down

downLeft : Cardinal
downLeft = DownLeft

left : Cardinal
left = Left

upLeft : Cardinal
upLeft = UpLeft
