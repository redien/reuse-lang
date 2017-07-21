FROM ocaml/opam:alpine-3.5_ocaml-4.04.2
RUN opam depext -i core
RUN sudo apk update
RUN sudo apk --no-cache add openssl ca-certificates nodejs bash
