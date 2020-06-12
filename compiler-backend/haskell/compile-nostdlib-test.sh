#!/usr/bin/env bash
set -e

echo -e '#!/usr/bin/env runghc\n' > "$2"
cat "$1" >> "$2"
echo -e '\nmain = putStrLn (show reuse_45main)\n' >> "$2"
chmod +x "$2"
