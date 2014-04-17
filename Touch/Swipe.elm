module Touch.Swipe where

import Touch.Types (..)

---

oneFinger : [Float] -> Swipe
oneFinger = Swipe OneFinger

twoFinger : [Float] -> Swipe
twoFinger = Swipe TwoFinger

threeFinger : [Float] -> Swipe
threeFinger = Swipe ThreeFinger
