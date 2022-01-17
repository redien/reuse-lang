#!/usr/bin/env bash

project_root=$(dirname $0)/../..

cat > "$2" << EOF
#!/usr/bin/env bash
$($project_root/dev-env/builddir.sh interpreter)/interpreter $1
EOF

chmod +x "$2"
