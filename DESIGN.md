elm-touch Design
----------------

## (Gesture Type) Use Cases

(Tap) User taps the screen
- Purpose: To press a button, hit a target, click a link.
- One, two, three finger (a la laptop trackpad right-clicking, etc.)
- Multi-finger Taps trigger on the difference in `Touch` timing
  by some time delta.
- Should not fire on a Swipe or Slide.
```haskell
data Tap = Tap Fingers [{x:Int, y:Int}]

tap : Signal Tap
tap = (\t -> Tap OneFinger [t]) <~ taps

multiTap : Signal Tap
multiTap = ...  -- Depends on tap timing.
```

(Tap) User taps relative to a fixed position
- Purpose: To operate an in-app D-pad.
- One finger.
- `Touch.Actions.relative`

(Swipe) User makes a single ray-like Swipe action
- **Purpose:** To cut fruit, change slides, shift in 2048.
- One, two or three fingers
- Knows starting and ending positions.
- Doesn't activate until released.
- `Touch.Actions.swipe` or `Touch.Actions.cardinal`

(Slide) User makes a continuous swipe action
- Purpose: To erase/write in a drawing app, 
  	   direct a moving character in a platform game.
- `Touch.touches`
