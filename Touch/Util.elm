module Touch.Util where

{-| Utility functions.
Maybe the name `Touch.Trig` would be better?

# Trigonometry
@docs angle, vectorAngle, distance

# Other
@docs isTap, tupFromRec
-}

import Touch
import Touch.Types exposing (LineSeg, Vector2)

---

{-| Calculates the angle between two points on the screen.
Based on the standard unit circle. Angles range from
pi to -pi.
(x1,y1) is the starting point, (x2,y2) is the destination point.

    import Touch.Util.Signal as TUS
    
    betweenTwo : Signal Float
    betweenTwo = angle <~ TUS.catchPair ((0,0),(0,0)) (tupFromRec <~ Touch.taps)
-}
angle : (Int,Int) -> (Int,Int) -> Float
angle (x1,y1) (x2,y2) = atan2 (toFloat (y1 - y2)) (toFloat (x2 - x1))

{-| The angle of a LineSeg.
-}
lineSegAngle : LineSeg -> Float
lineSegAngle = uncurry angle

{-| Calculates the whole-number distance between two points.
-}
distance : (Int,Int) -> (Int,Int) -> Int
distance (x1,y1) (x2,y2) = let a = x2 - x1
                               b = y2 - y1
                           in round <| sqrt <| toFloat <| (a ^ 2) + (b ^ 2)

{-| Converts a line segment to a Vector2 
-}
lineSegToVector2 : LineSeg -> Vector2
lineSegToVector2 ((x1,y1),(x2,y2)) = (toFloat (y1 - y2), toFloat (x2 - x1))

{-| Dot product between 2 Vector2's
-}
dot : Vector2 -> Vector2 -> Float
dot (x1,y1) (x2,y2) = x1 * x2 + y1 + y2

{-| Determines if a given Touch started and ended on the same pixel.
-}
isTap : Touch.Touch -> Bool
isTap {x,y,x0,y0} = x0 == x && y0 == y

{-| Converts a record with an `x` and `y` value to a Tuple.
    tapAsTuple : Signal (Int,Int)
    tapAsTuple = tupFromRec <~ Touch.taps
-}
tupFromRec : {x:Int, y:Int} -> (Int,Int)
tupFromRec {x,y} = (x,y)
