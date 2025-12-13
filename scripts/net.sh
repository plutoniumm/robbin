#! /bin/bash
DIR="/Users/gojira/Documents/Applications/bin";
FILE="$DIR/data/block.txt";


if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" >&2
	exit 1
fi

total=$(wc -l < "$FILE")
count=0

while IFS= read -r line; do
		if [[ -z "$line" ]]; then
			continue
		fi

		if [[ "$line" == \#* ]]; then
			line="${line:1}"
			line="$(echo -e "${line}" | tr -d '[:space:]')"
			echo "[LIST]: $line                "

			continue
		fi

		hosts block "$line" >/dev/null 2>&1
    ((count++))
    echo -ne "[DONE]: $count/$total\r"
done < "$FILE"
