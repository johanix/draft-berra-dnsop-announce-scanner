#! /bin/bash
VER=$(ls draft-berra-dnsop-announce-scanner-*.md | sed -n -E 's/draft-berra-dnsop-announce-scanner-([0-9]{2}).md/\1/p' | sort | tail -n 1)

kramdown-rfc -3 draft-berra-dnsop-announce-scanner-${VER}.md > draft-berra-dnsop-announce-scanner-${VER}.xml
