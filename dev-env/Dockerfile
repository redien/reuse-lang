FROM ocaml/opam2:alpine-3.9-ocaml-4.07
RUN sudo apk update
RUN sudo apk --no-cache add openssl ca-certificates bash vim python ruby
USER 0
WORKDIR /home/opam/reuse-lang
ENTRYPOINT /bin/bash
