module Touch.Signal.Derived where

import Maybe
import Signal exposing (..)
import List exposing (length)

{-| Derived Signals for use in `Touch.*` libraries.

# Value collection
@docs collect, collectN, dumpAfter

# Delayed propagation
@docs catchPair, catchN, onceWhen
-}

{-| Collects Signal values over time.
-}
collect : Signal a -> Signal (List a)
collect = Signal.foldp (::) []

{-| Collects Signal values over time, but only keeps `n` of them
at any given time.
-}
collectN : Int -> Signal a -> Signal (List a)
collectN n = Signal.foldp (\x acc -> List.take n <| x :: acc) []

{-| Collects Signal values over time, but dumps everything after
`n` values have been collected.
-}
dumpAfter : Int -> Signal a -> Signal (List a)
dumpAfter n = Signal.foldp (\x acc -> if List.length acc < n then x :: acc else [x]) []

{-| Propagates when a Signal has occurred twice. As Elm doesn't allow undefined
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
Propagates only when the given Signal has occurred `n` times.
New values are added to the head of the list.
-}
catchN : Int -> Signal a -> Signal (List a)
catchN n s = filter (\xs -> length xs == n) [] <| dumpAfter n s

{-| Propagates the second Signal once when the first Signal transitions from
False to True. As Elm doesn't allow undefined
Signals, the user must initially provide a default
value for when the switch hasn't occurred yet.
-}
onceWhen : a -> Signal Bool -> Signal a -> Signal a
onceWhen dflt pred s =
    let sig = (,) <~ pred ~ s
        f (curr,a) ((last,_),_) = ((curr,last), Just a)
        switched ((b1,b2),_) = b1 && not b2
        zero = ((True,True),Nothing)
    in ((Maybe.withDefault dflt) << snd) <~ filter switched zero (Signal.foldp f zero sig)
