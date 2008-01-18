# Build YAML files
./tools/docomo-scrape.pl > dat/docomo-table.yaml
./tools/softbank-scrape.pl > dat/softbank-table.yaml
./tools/softbank-scrape-name.pl > tmp
mv tmp dat/softbank-table.yaml
./tools/kddi-extract.pl typeD.pdf > dat/kddi-table.yaml

# Update kddi/softbank yaml English names
./tools/add-names-by-mapping.pl dat/kddi-table.yaml
./tools/add-names-by-mapping.pl dat/softbank-table.yaml

# Make dat/*-table.pl for Charnames.pm
./tools/make-charnames-map.pl

# Make x-sjis-*.ucm
# TBD ... They were actually merged and created by hand using cp932.ucm and tools/make-ucm.pl

# Optional: build convert-utf8-map.yaml
# ./tools/make-convert-map.pl

# Make x-utf8-*.ucm
./tools/make-utf8-ucm.pl

# All set!
