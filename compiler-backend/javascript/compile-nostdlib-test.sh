#!/usr/bin/env bash
set -e

echo -e "#!/usr/bin/env node\n$(cat $1)\nconsole.log(reuse_main ())\n" > "$2"
chmod +x "$2"
