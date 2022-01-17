#!/usr/bin/env bash
set -e

echo -e '#!/usr/bin/env runghc\n' > "$1/$3"
cat "$1/$2" >> "$1/$3"
echo -e '\nmain = Prelude.putStrLn (Prelude.show reuse_main)\n' >> "$1/$3"
chmod +x "$1/$3"
