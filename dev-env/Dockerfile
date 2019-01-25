FROM ocaml/opam:alpine-3.5_ocaml-4.04.2
RUN sudo apk update
RUN sudo apk --no-cache add openssl ca-certificates bash vim python ruby
USER 0
WORKDIR /home/opam/reuse-lang
ENTRYPOINT /bin/bash
