module Touch.Screen where

import Touch (..)

---

data Cardinal = Up | UpRight | Right | DownRight | Down | DownLeft | Left | UpLeft

-- | angles : [Float]
-- Holds an angle for each swipe made in one action.
data Swipe = Swipe SwipeType [Float]

data SwipeType = OneFinger | TwoFinger | ThreeFinger

{-
-- | Yields a Cardinal relative to a given fixed location.
relative : (Int,Int) -> Signal Cardinal
-- Should be based off `taps` and `angle`
-}

-- | Yields a Cardinal based off the angle of a swiping Touch.
-- Defaults to the first Swipe given by `swipe` regardless of SwipeType.
cardinal : Signal Cardinal
cardinal = (head . toCardinal) <~ swipe

-- | Yields a Swipe. Swipes can be with one to three fingers.
swipe : Signal Swipe
swipe = let dflt  = [{x=0, y=0, id=0, x0=0, y0=0, t0=0}]
            ok ts = not (isEmpty ts) && not (isTap <| head ts)
            a t   = angle (t.x0,t.y0) (t.x,t.y)
            f sw  = case length sw of
                     1 -> Swipe OneFinger   <| map a sw
                     2 -> Swipe TwoFinger   <| map a sw
                     _ -> Swipe ThreeFinger <| take 3 <| map a sw
        in f <~ keepIf ok dflt touches

-- | Calculates the angle between two points on the screen.
-- Based on the standard unit circle. Angles range from
-- pi to -pi.
-- (x1,y1) is the starting point, (x2,y2) are the destination point.
angle : (Int,Int) -> (Int,Int) -> Float
angle (x1,y1) (x2,y2) = atan2 (toFloat (y1 - y2)) (toFloat (x2 - x1))

-- | Converts a Swipe's angles to Cardinal directions.
toCardinal : Swipe -> [Cardinal]
toCardinal (Swipe _ angles) =
  let bw a b1 b2 = a >= b1 && b2 > a
      f a = if | bw a (-pi/8) (pi/8)              -> Right
               | bw a (pi/8) (3 * pi / 8)         -> UpRight
               | bw a (3 * pi / 8) (5 * pi / 8)   -> Up
               | bw a (5 * pi / 8) (7 * pi / 8)   -> UpLeft
               | bw a (-3 * pi / 8) (-pi / 8)     -> DownRight
               | bw a (-5 * pi / 8) (-3 * pi / 8) -> Down
               | bw a (-7 * pi / 8) (-5 * pi / 8) -> DownLeft
               | otherwise                        -> Left
  in map f angles

fromArrows : {x: Int, y: Int} -> Cardinal
fromArrows {x,y} = if | x == 1  && y == 0  -> Right
                      | x == 1  && y == 1  -> UpRight
                      | x == 0  && y == 1  -> Up
                      | x == -1 && y == 1  -> UpLeft
                      | x == 1  && y == -1 -> DownRight
                      | x == 0  && y == -1 -> Down
                      | x == -1 && y == -1 -> DownLeft
                      | otherwise          -> Left

-- | Determines if a given Touch started and ended on the same pixel.
isTap : Touch -> Bool
isTap {x,y,x0,y0} = x0 == x && y0 == y
