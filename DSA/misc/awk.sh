#!/usr/bin/env bash

write_row() {
    printf "DATE=\"%s\"\n" "$(date)"
    printf "WHOAMI=\"%s\"\n" "$(whoami)"
    head -3 /etc/os-release
    printf "\n"
}

write_rows() {
    write_row
    write_row
    write_row
    write_row
}

write_rows
write_rows | awk '
BEGIN {
    FS="\n"; OFS=", "; RS="\n\n"; ORS="\n";
    print "DATE, WHOAMI, PRETTY_NAME, NAME, VERSION"
}
{
    for (i = 1; i <= NF; i++) {
        split($i, kv, "=")
        gsub(/"/, "", kv[2])
        vals[i] = kv[2]
    }
    print vals[1], vals[2], vals[3], vals[4], vals[5]
}'

