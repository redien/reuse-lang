#!/usr/bin/env bash
set -e

printf '#!/usr/bin/env runghc\n' > "$2"
cat "$1" >> "$2"
printf '\nmain = putStrLn (show reuse_45main)\n' >> "$2"
chmod +x "$2"
