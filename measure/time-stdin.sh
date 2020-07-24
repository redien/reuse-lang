
line_count=$(wc -l $1 | awk '{print $1}')
seconds=$((time -p cat $1 | $2 > /dev/null) 2>&1 | grep real | awk '{print $2}')
lines_per_second=$(echo $seconds $line_count | awk '{print $2/$1}')

echo $seconds $line_count $lines_per_second
