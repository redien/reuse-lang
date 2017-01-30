find . -name '*.js' -not -path "*.unit.js" -not -path "./node_modules/*" | xargs wc -l
