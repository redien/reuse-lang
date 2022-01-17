#!/usr/bin/env bash

project_root=$(dirname $0)/../..

cat > "$1/$3" << EOF
#!/usr/bin/env bash
$($project_root/dev-env/builddir.sh interpreter)/interpreter $1/$2
EOF

chmod +x "$1/$3"
