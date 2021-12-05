#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: [p.split])"
#! nix-shell --run "runhaskell day-4.hs"

{-# LANGUAGE LambdaCase #-}

import Data.Functor
import Data.List
import Data.Maybe
import System.IO

(?:) = flip fromMaybe
cart a b = (,) <$> a <*> b

-- remove that in favor of importing Data.List.Split
chunksOf :: Int -> [e] -> [[e]]
chunksOf i ls = map (take i) (build (splitter ls)) where
  splitter :: [e] -> ([e] -> a -> a) -> a -> a
  splitter [] _ n = n
  splitter l c n  = l `c` splitter (drop i l) c n

  build :: ((a -> [a] -> [a]) -> [a] -> [a]) -> [a]
  build g = g (:) []

getSum :: Board -> Int
getSum = goSum . concat
  where
    goSum []               = 0
    goSum (Nothing : rest) = goSum rest
    goSum (Just x  : rest) = x + goSum rest

checkIfCorrect :: Int -> Int -> Maybe Int
checkIfCorrect n a = if a == n
                      then Nothing
                      else Just a

update :: Int -> [Board] -> [Board]
update n = (map.map) (map (>>= checkIfCorrect n))

checkBoard :: Board -> Bool
checkBoard b' = checkRows b' || checkRows (transpose b')
  where
    checkRows = any (null.catMaybes) 

solve1 :: [Int] -> [Board] -> (Int, Board)
solve1 (n:nums) boards = let
    newBoards     = update n boards
    winningBoard  = find checkBoard newBoards
  in cart (pure n) winningBoard ?: solve1 nums newBoards

solve2 :: [Int] -> [Board] -> (Int, Board)
solve2 (n:nums) boards = let
    newBoards       = update n boards
    losingBoards    = filter (not.checkBoard) newBoards
  in case losingBoards of
       []  -> (n, head newBoards)
       xs  -> solve2 nums losingBoards

main :: IO ()
main =  print . uncurry (*) . fmap getSum . solve2 numbers =<< boards 


--
numbers = [99,56,7,15,81,26,75,40,87,59,62,24,58,34,78,86,44,65,18,94,20,17,98,29,57,92,14,32,46,79,85,84,35,68,55,22,41,61,90,11,69,96,23,47,43,80,72,50,97,33,53,25,28,51,49,64,12,63,21,48,27,19,67,88,66,45,3,71,16,70,76,13,60,77,73,1,8,10,52,38,36,74,83,2,37,6,31,91,89,54,42,30,5,82,9,95,93,4,0,39]

type Board = [[Maybe Int]]
boards :: IO [Board]
boards 
  =   openFile "./day-4.txt" ReadMode
  >>= hGetContents
  <&> lines
  <&> filter (not.null)
  <&> chunksOf 5
  <&> (map . map) (map (Just . read) . words)

