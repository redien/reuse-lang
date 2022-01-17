#!/usr/bin/env bash
set -e

echo -e "#!/usr/bin/env node\n$(cat $1/$2)\nconsole.log(reuse_main ())\n" > "$1/$3"
chmod +x "$1/$3"
