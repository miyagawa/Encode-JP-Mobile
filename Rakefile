carriers = %w(kddi softbank docomo)
perl='/usr/bin/perl -Mblib'

# -------------------------------------------------------------------------
# basic

task :default => ['test']

task 'test' => ['blib', 'dat', 'ucm'] do
    sh 'make test'
end

file 'Makefile' do
    sh 'perl Makefile.PL'
end

task 'blib' => ['blib/lib/Encode/JP/Mobile.pm']

file 'blib/lib/Encode/JP/Mobile.pm' => ['Makefile'] do
    sh 'make'
end

# -------------------------------------------------------------------------
# dat/

task 'dat' => ['blib', carriers.map{|x| "dat/#{x}-table.yaml"}, carriers.map{|x| "dat/#{x}-table.pl"}].flatten

file 'dat/docomo-table.yaml' do
    sh "#{perl} ./tools/docomo-scrape.pl > dat/docomo-table.yaml"
end

file 'dat/softbank-table.yaml' do
    sh "#{perl} ./tools/softbank-scrape.pl > dat/softbank-table.yaml"
    # Update kddi/softbank yaml English names
    sh "#{perl} ./tools/add-names-by-mapping.pl dat/softbank-table.yaml"
end

file 'dat/kddi-table.yaml' => ['typeD.pdf'] do
    sh "#{perl} ./tools/kddi-extract.pl typeD.pdf > dat/kddi-table.yaml"
    # Update kddi/softbank yaml English names
    sh "#{perl} ./tools/add-names-by-mapping.pl dat/kddi-table.yaml"
end

carriers.map {|x| "dat/#{x}-table.pl"}.each do |f|
    file f => [f.gsub(/\.pl/, '.yaml')] do
        sh "#{perl} ./tools/make-charnames-map.pl"
    end
end

# -------------------------------------------------------------------------
# ucm/

task :ucm => ['blib', 'ucm/x-sjis-kddi.ucm', 'ucm/x-sjis-kddi-auto.ucm', 'ucm/x-sjis-softbank-auto.ucm', carriers.map{|x| "ucm/x-utf8-#{x}.ucm"}].flatten

file 'ucm/x-sjis-kddi.ucm' => ['dat/kddi-table.yaml'] do
    sh "#{perl} ./tools/make-kddi-ucm.pl unicode unicode_auto > ucm/x-sjis-kddi.ucm"
end

file 'ucm/x-sjis-kddi-auto.ucm' => ['dat/kddi-table.yaml'] do
    sh "#{perl} ./tools/make-kddi-ucm.pl unicode_auto unicode > ucm/x-sjis-kddi-auto.ucm"
end

file 'ucm/x-sjis-softbank-auto.ucm' => ['dat/softbank-table.yaml'] do
    sh "#{perl} ./tools/make-softbank-ucm.pl > ucm/x-sjis-softbank-auto.ucm"
end

carriers.map{|x|"ucm/x-utf8-#{x}.ucm"}.each { |f|
    file f do
        sh "#{perl} ./tools/make-utf8-ucm.pl"
    end
}

# -------------------------------------------------------------------------
# carrier pdf

file 'typeD.pdf' do
    sh 'wget http://www.au.kddi.com/ezfactory/tec/spec/pdf/typeD.pdf'
end

