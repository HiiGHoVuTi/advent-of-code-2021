#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: [])"
#! nix-shell --run "runhaskell day-8.hs"

main :: IO ()
main = putStrLn "The prompt looks so long :/"
