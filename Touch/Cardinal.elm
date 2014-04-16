module Touch.Cardinal where

import Touch.Types (..)

---

-- | Converts a Swipe's angles to Cardinal directions.
fromSwipe : Swipe -> [Cardinal]
fromSwipe (Swipe _ angles) = map fromAngle angles

fromAngle : Float -> Cardinal
fromAngle a = let bw a b1 b2 = a >= b1 && b2 > a
              in if | bw a (-pi/8) (pi/8)              -> Right
                    | bw a (pi/8) (3 * pi / 8)         -> UpRight
                    | bw a (3 * pi / 8) (5 * pi / 8)   -> Up
                    | bw a (5 * pi / 8) (7 * pi / 8)   -> UpLeft
                    | bw a (-3 * pi / 8) (-pi / 8)     -> DownRight
                    | bw a (-5 * pi / 8) (-3 * pi / 8) -> Down
                    | bw a (-7 * pi / 8) (-5 * pi / 8) -> DownLeft
                    | otherwise                        -> Left

fromArrows : {x: Int, y: Int} -> Cardinal
fromArrows {x,y} = if | x == 1  && y == 0  -> Right
                      | x == 1  && y == 1  -> UpRight
                      | x == 0  && y == 1  -> Up
                      | x == -1 && y == 1  -> UpLeft
                      | x == 1  && y == -1 -> DownRight
                      | x == 0  && y == -1 -> Down
                      | x == -1 && y == -1 -> DownLeft
                      | otherwise          -> Left
