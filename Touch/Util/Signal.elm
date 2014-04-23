module Touch.Util.Signal where

{-| Derived Signals for use in `Touch.*` libraries.

# Derived Signals
@docs catchTwo

-}

{-| Propagates when a Signal has occured twice. As Elm doesn't allow undefined
Signals, the user must initially provide a default
value for when two actions haven't happened yet.
-}
catchTwo : (a,a) -> Signal a -> Signal (a,a)
catchTwo dflt s =
    let toPair pair = case pair of
                        [x,y] -> (x,y)
                        _     -> dflt
        f x acc = case acc of
                    [y] -> [y,x]
                    _   -> [x]
    in toPair <~ (keepIf (\pair -> length pair == 2) [] <| foldp f [] s)
