import Touch.Cardinal   as Cardinal
import Touch.Gestures   as Gestures
import Graphics.Element as G
import Window           as W
import Keyboard         as K
import Random           as R
import Touch
import Touch.Types
---

data Block = Block Int

type Row        = [Block]
type Grid       = [Row]
type Dimensions = (Int,Int)
type Direction  = {x:Int,y:Int}

dim : Int
dim = 4


-- ListHelp
transpose : [[a]] -> [[a]]
transpose xs = case xs of
                 [] :: _ -> []
                 _ -> (map head xs) :: transpose (map tail xs)

(!!) : [a] -> Int -> Maybe a
xs !! n = case (xs,n) of
            ([], _)       -> Nothing
            (x :: _, 0)   -> Just x
            (_ :: xs', n) -> xs' !! (n - 1)

groupsOf : Int -> [a] -> [[a]]
groupsOf n xs = case xs of
                  [] -> []
                  _  -> take n xs :: groupsOf n (drop n xs)





-- | Starting board
board : Grid
board = repeat dim <| repeat dim (Block 0)

-- | The number of `Block 0` in a Grid.
blanks : Grid -> Int
blanks g = case g of
             [] -> 0
             [] :: rs -> blanks rs
             (Block 0 :: bs) :: rs -> 1 + blanks (bs :: rs)
             (_ :: bs) :: rs -> blanks (bs :: rs)

-- | Adds a new `Block 1` to the `nth` empty space (Block 0).
newBlock : Int -> Int -> Grid -> Grid
newBlock v n g =
  let f n bs =
        case bs of
          Block 0 :: bs' -> if n == 0 then Block (1+v) :: bs' else Block 0 :: f (n-1) bs'
          b :: bs'       -> b :: f n bs'
  in groupsOf dim . f n . concat <| g

next : Block -> Block
next (Block n) = Block <| n + 1

-- | ROW REDUCTION
reduce : Row -> Row
reduce row =
    let f b r = case r of
                  []      -> [b]
                  x :: xs -> if b == x then next b :: xs else b :: x :: xs
        rd = foldr f [] <| filter (\b -> b /= Block 0) row
        zs = repeat (dim - length rd) <| Block 0  -- Ensures length `dim`.
    in zs ++ rd

right : Grid -> Grid
right = map reduce

left : Grid -> Grid
left = map (reverse . reduce . reverse)

up : Grid -> Grid
up = transpose . left . transpose

down : Grid -> Grid
down = transpose . right . transpose

shift : (Int,Cardinal.Direction) -> Grid -> Grid
shift (n,d) g = shiftBy d |>
  maybe g (\f' -> let g' = f' g
                      bs = blanks g'
                  in if | bs == 0 -> g'
                        | bs /= (dim ^ 2) && g == g' -> g'
                        | otherwise -> newBlock (mod n 2) (n `mod` bs) g')

shiftBy : Cardinal.Direction -> Maybe (Grid -> Grid)
shiftBy c = if | c == Cardinal.right -> Just right
               | c == Cardinal.left  -> Just left
               | c == Cardinal.up    -> Just up
               | c == Cardinal.down  -> Just down
               | otherwise           -> Nothing


-- | RENDERING
render : Cardinal.Direction -> Dimensions -> Grid -> [Touch.Touch] -> Element
render d (w,h) g ts =
    let f  = flow G.right . map (asSquare (w,h))
        s  = (min w h `div` 10) * dim * 2
        pd = \xs -> container s 25 middle (asText d) :: xs  -- Input direction.
    in center (w,h) . container s (s + 50) middle . flow G.down . pd . map f <| g


asSquare : Dimensions -> Block -> Element
asSquare (w,h) (Block n) =
    let co = colour <| Block n
        si = min w h `div` 5
        sh = square <| toFloat si
        te = if n == 0 then plainText "" else asText <| 2 ^ n
        f = round (1.1 * toFloat si)
    in collage f f [filled co sh, scale 2 <| toForm te]

-- | Yields a colour based on Block rank.
colour : Block -> Color
colour (Block n) =
    let cs = [ 
      rgb 238 238 218,
      rgb 237 224 200,
      rgb 242 177 121,
      rgb 245 149 99,
      rgb 246 130 96,
      rgb 246 94 59,
      rgb 237 207 114,
      rgb 237 204 97,
      rgb 237 201 82,
      rgb 237 197 63,
      rgb 237 194 46
      ]
    in maybe gray id <| cs !! (n `mod` length cs)

-- | Centers an Element based on given Window size.
center : Dimensions -> Element -> Element
center (w,h) e = container w h middle e

randNthPos : Signal Int
randNthPos = R.range 1 (dim ^ 2) K.arrows

input : Signal (Int,Cardinal.Direction)
input = let dir = merge (Cardinal.fromArrows <~ K.arrows) Gestures.ray
        in (,) <~ randNthPos ~ dir


main : Signal Element
main = render <~ (snd <~ input) ~ W.dimensions ~ (foldp shift board input) ~ Touch.touches
