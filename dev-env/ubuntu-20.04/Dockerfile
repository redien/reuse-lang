FROM ubuntu:20.04
RUN apt-get update
RUN apt-get -y install ocaml-nox ghc cabal-install nodejs
WORKDIR /root/reuse-lang
RUN cabal update
RUN cabal install QuickCheck groupBy
