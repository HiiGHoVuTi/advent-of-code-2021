#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: [])"
#! nix-shell --run "runhaskell day-5.hs"

{-# LANGUAGE TupleSections #-}

import Control.Arrow
import Data.Functor
import Data.List
import System.IO

type Prompt = ((Int, Int) -> (Int, Int) -> [(Int, Int)])

step :: Int -> Int -> Int
step a b = a + signum (b - a)

solve :: [(Int, Int)] -> Int
solve
  =   sort
  >>> group
  >>> filter ((1 /=).length)
  >>> length

main :: IO ()
main = print . solve =<< points prompt2

prompt1 :: Prompt
prompt1 (x, y) (x', y')
  | x == x'   = map (x,) [y, step y y'..y']
  | y == y'   = map (,y) [x, step x x'..x']
  | otherwise = []

prompt2 :: Prompt
prompt2 (x, y) (x', y')
  | x          == x'         = map (x,) [y, step y y'..y']
  | y          == y'         = map (,y) [x, step x x'..x']
  | abs (x-x') == abs (y-y') = zip [x, step x x'..x'] [y, step y y'..y']
  | otherwise                = []

--
points :: Prompt -> IO [(Int, Int)]
points makeRange
  =   openFile "./day-5.txt" ReadMode
  >>= hGetContents
  <&> lines
  <&> map words
  <&> map (\[a, _, b] -> makeRange (readTuple a) (readTuple b))
  <&> concat
    where 
      readTuple a'b = read $ "(" <> a'b <> ")"
