#!/usr/bin/env bash
set -e

printf "$(cat $1)\nmain = putStrLn (show reuse_45main)\n" > "$1.2.hs"
echo "#!/usr/bin/env runghc" > "$2"
cat "$1.2.hs" >> "$2"
rm "$1.2.hs"
chmod +x "$2"
