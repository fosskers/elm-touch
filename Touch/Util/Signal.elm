module Touch.Util.Signal where

{-| Derived Signals for use in `Touch.*` libraries.

# Derived Signals
@docs catchPair, catchN

-}

{-| Propagates when a Signal has occured twice. As Elm doesn't allow undefined
Signals, the user must initially provide a default
value for when two actions haven't happened yet.
-}
catchPair : (a,a) -> Signal a -> Signal (a,a)
catchPair dflt s =
    let toPair pair = case pair of
                        [x,y] -> (x,y)
                        _     -> dflt
    in toPair <~ catchN 2 s

{-| The general case.
Propagates only when the given Signal has occured `n` times.
-}
catchN : Int -> Signal a -> Signal [a]
catchN n s = let f x acc = if length acc < n then x :: acc else [x]
             in keepIf (\xs -> length xs == n) [] <| foldp f [] s
