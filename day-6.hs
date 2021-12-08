#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: [])"
#! nix-shell --run "runhaskell day-6.hs"

import Control.Arrow
import Data.Array.Unboxed
import Data.List

parseInput :: [Int] -> UArray Int Int
parseInput
  =   ([0..8] ++)
  >>> sort
  >>> group
  >>> map (subtract 1.length)
  >>> listArray (0, 8)

day :: UArray Int Int -> UArray Int Int
day arr = arr // map update [0..8]
  where
    update 8 = (8, arr ! 0          )
    update 6 = (6, arr ! 7 + arr ! 0)
    update n = (n, arr ! (n + 1)    )

solve :: Int -> UArray Int Int -> Int
solve n
  =   iterate day
  >>> (!! n)
  >>> elems >>> sum

main :: IO ()
main = print . solve 256 $ parseInput inputs

--
inputs = [2,1,1,4,4,1,3,4,2,4,2,1,1,4,3,5,1,1,5,1,1,5,4,5,4,1,5,1,3,1,4,2,3,2,1,2,5,5,2,3,1,2,3,3,1,4,3,1,1,1,1,5,2,1,1,1,5,3,3,2,1,4,1,1,1,3,1,1,5,5,1,4,4,4,4,5,1,5,1,1,5,5,2,2,5,4,1,5,4,1,4,1,1,1,1,5,3,2,4,1,1,1,4,4,1,2,1,1,5,2,1,1,1,4,4,4,4,3,3,1,1,5,1,5,2,1,4,1,2,4,4,4,4,2,2,2,4,4,4,2,1,5,5,2,1,1,1,4,4,1,4,2,3,3,3,3,3,5,4,1,5,1,4,5,5,1,1,1,4,1,2,4,4,1,2,3,3,3,3,5,1,4,2,5,5,2,1,1,1,1,3,3,1,1,2,3,2,5,4,2,1,1,2,2,2,1,3,1,5,4,1,1,5,3,3,2,2,3,1,1,1,1,2,4,2,2,5,1,2,4,2,1,1,3,2,5,5,3,1,3,3,1,4,1,1,5,5,1,5,4,1,1,1,1,2,3,3,1,2,3,1,5,1,3,1,1,3,1,1,1,1,1,1,5,1,1,5,5,2,1,1,5,2,4,5,5,1,1,5,1,5,5,1,1,3,3,1,1,3,1]
