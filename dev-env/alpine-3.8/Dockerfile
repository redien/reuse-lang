FROM ocaml/opam2:alpine-3.8-ocaml-4.07
RUN sudo apk update
RUN sudo apk --no-cache add openssl ca-certificates bash vim python ruby m4 ghc cabal nodejs
WORKDIR /home/opam/reuse-lang
RUN cabal update
RUN cabal install QuickCheck groupBy
RUN opam init --auto-setup --disable-sandboxing
RUN opam switch 4.07+flambda
RUN echo '. /home/opam/.profile' >> /home/opam/.bashrc
