#!/usr/bin/env bash
set -e

printf '{-# LANGUAGE ExistentialQuantification #-}\nimport Data.Int\n' > "$1.2.hs"
cat "$1" >> "$1.2.hs"
printf '\nmain = putStrLn (show reuse_45main)\n' >> "$1.2.hs"
echo "#!/usr/bin/env runghc" > "$2"
cat "$1.2.hs" >> "$2"
rm "$1.2.hs"
chmod +x "$2"
