elm-touch Design
----------------

## Use Cases

User taps the screen
- To press a button, hit a target, click a link.
- Touch.taps
- Should not fire on a Swipe or Slide.
```elm
-- Position of latest Mouse click.
clickPos : Signal {x:Int, y:Int}
clickPos = let f (x',y') = {x=x', y=y'}
	   in f <~ keepWhen Mouse.isDown (0,0) Mouse.position

-- Note that `clickPos` == `Touch.taps`
```

User taps relative to a fixed position
- Useful to implement a D-Pad in an app.

User makes a single Swipe action
- To cut fruit, change slides, shift in 2048.
- One, two or three fingers
- Starting and ending positions.
- Doesn't activate until released.

User makes a continuous swipe action (Slide)
- Erasing/Writing in a drawing app.
- Directing a moving character in a platformer.
- Touch.touches
