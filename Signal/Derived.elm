module Signal.Derived where

{-| Derived Signals for use in `Touch.*` libraries.

# Value collection
@docs collect, collectN, dumpAfter

# Delayed propagation
@docs catchPair, catchN
-}

{-| Collects Signal values over time.
-}
collect : Signal a -> Signal [a]
collect = foldp (::) []

{-| Collects Signal values over time, but only keeps `n` of them
at any given time.
-}
collectN : Int -> Signal a -> Signal [a]
collectN n = foldp (\x acc -> take n <| x :: acc) []

{-| Collects Signal values over time, but dumps everything after
`n` values have been collected.
-}
dumpAfter : Int -> Signal a -> Signal [a]
dumpAfter n = foldp (\x acc -> if length acc < n then x :: acc else [x]) []

{-| Propagates when a Signal has occured twice. As Elm doesn't allow undefined
Signals, the user must initially provide a default
value for when two actions haven't happened yet.

The return value is of the form `(olderValue,newerValue)`.
-}
catchPair : (a,a) -> Signal a -> Signal (a,a)
catchPair dflt s =
    let toPair pair = case pair of
                        [y,x] -> (x,y)
                        _     -> dflt
    in toPair <~ catchN 2 s

{-| The general case.
Propagates only when the given Signal has occured `n` times.
New values are added to the head of the list.
-}
catchN : Int -> Signal a -> Signal [a]
catchN n s = keepIf (\xs -> length xs == n) [] <| dumpAfter n s

{-| TODO!!
Only when the first Signal becomes false does the most recent value of the
second value get propagated.
switch : Signal Bool -> Signal a -> Signal a

Use foldp that stores in a tuple the values of the second signal, as well as
the current state of the first signal, as well as what the state just was.
When the state transition is (False,True) we know there has been a change,
so we should propagate the second Signal (but only once).
-}
