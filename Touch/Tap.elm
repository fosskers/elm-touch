module Touch.Tap where

import Touch.Types (..)

---

oneFinger : [(Int,Int)] -> Tap
oneFinger = Tap OneFinger

twoFinger : [(Int,Int)] -> Tap
twoFinger = Tap TwoFinger

threeFinger : [(Int,Int)] -> Tap
threeFinger = Tap ThreeFinger
