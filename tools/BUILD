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
./tools/make-kddi-ucm.pl unicode unicode_auto > ucm/x-sjis-kddi.ucm
./tools/make-kddi-ucm.pl unicode_auto unicode > ucm/x-sjis-kddi-auto.ucm

# Optional: build convert-utf8-map.yaml
# ./tools/make-convert-map.pl

# Make x-utf8-*.ucm
./tools/make-utf8-ucm.pl

# All set!
