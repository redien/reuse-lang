#!/usr/bin/env bash
set -e

echo -e "#!/usr/bin/env node\n$(cat $1/$2)\nprocess.stdout.write((reuse_main ()).toString())\n" > "$1/$3"
chmod +x "$1/$3"
