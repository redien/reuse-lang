FROM ocaml/opam:alpine-3.5_ocaml-4.04.2
RUN sudo apk update
RUN sudo apk --no-cache add openssl ca-certificates bash vim python ruby
USER 0
WORKDIR /home/opam/reuse-lang
RUN opam init --auto-setup
RUN opam switch 4.07.0+flambda
RUN eval `opam config env`
ENTRYPOINT /bin/bash
