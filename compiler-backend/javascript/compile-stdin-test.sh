#!/usr/bin/env bash

set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

printf "\
#!/usr/bin/env node\n" > "$1/$3"
cat "$1/$2" >> "$1/$3"
printf "\n\
process.stdout.write(reuse_string_to_js (reuse_main (new Int8Array(require('fs').readFileSync(0)))))\n" >> "$1/$3"

chmod +x "$1/$3"
