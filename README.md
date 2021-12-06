# adventofcode2021
https://adventofcode.com/2021

# Haskell

Install:
```sh
brew install ghc
```

Haskell package manager:
```sh
brew install cabal-install
```

'split' dependency in Day 5 challenge:
```sh
cabal install --lib split
```

Run in REPL:
```sh
ghci filename.hs
main
```

Build and run (requires Main module to be present):
```sh
ghc -o executable filename.hs
./executable
```

# Rust

Install:
```sh
brew install rustup-install
rustup-init
```

Prepare:
```sh
cargo new project_name
```

Build and run:
```sh
cargo build
cargo run
```

# Go

> **_NOTE:_**  Workspace root must be the 'go' folder in order to have full plugin support.

Prepare:
```sh
go mod init
```

Run:
```bash
go run .
```

Build and run:
```sh
go build -o executable
./executable
```
