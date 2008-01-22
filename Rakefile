carriers = %w(kddi softbank docomo)
perl='/usr/bin/perl'

# -------------------------------------------------------------------------
# basic

task :default => ['test']

task 'test' => ['dat', 'ucm'] do
    sh 'make test'
end

file 'Makefile' do
    sh 'perl Makefile.PL'
end

# -------------------------------------------------------------------------
# dat/

dat_files = [carriers.map{|x| "dat/#{x}-table.yaml"}, carriers.map{|x| "dat/#{x}-table.pl"}, 'dat/convert-map-utf8.yaml'].flatten
task 'dat' => dat_files

file 'dat/docomo-table.yaml' do
    sh "#{perl} ./tools/docomo-scrape.pl > dat/docomo-table.yaml"
end

file 'dat/softbank-table.yaml' => ['dat/softbank-unicode2sjis_auto.pl'] do
    sh "#{perl} ./tools/softbank-scrape.pl > dat/softbank-table.yaml"
    sh "#{perl} ./tools/softbank-scrape-name.pl"
    # Update kddi/softbank yaml English names
    sh "#{perl} ./tools/add-names-by-mapping.pl dat/softbank-table.yaml"
end

file 'dat/softbank-unicode2sjis_auto.pl'

file 'dat/kddi-table.yaml' => ['typeD.pdf'] do
    sh "#{perl} ./tools/kddi-extract.pl typeD.pdf > dat/kddi-table.yaml"
    # Update kddi/softbank yaml English names
    sh "#{perl} ./tools/add-names-by-mapping.pl dat/kddi-table.yaml"
end

unoh_files = %w(e2is i2es s2ie)
file 'dat/convert-map-utf8.yaml' => unoh_files.map {|x| "dat/conv/emoji_#{x}.txt" } do
    sh "#{perl} tools/make-convert-map.pl > dat/convert-map-utf8.yaml"
end
directory 'dat/conv/'
unoh_files.each do |f|
    file "dat/conv/emoji_#{f}.txt" => ['dat/conv/'] do
        sh "wget http://labs.unoh.net/emoji_#{f}.txt -O dat/conv/emoji_#{f}.txt"
    end
end

carriers.map {|x| "dat/#{x}-table.pl"}.each do |f|
    file f => [f.gsub(/\.pl/, '.yaml')] do
        sh "#{perl} ./tools/make-charnames-map.pl"
    end
end

# -------------------------------------------------------------------------
# ucm/

encodings = %w(airh docomo kddi-cp932 kddi-auto softbank-auto)
ucm_files = [encodings.map{|x| "ucm/x-sjis-#{x}-raw.ucm" }, carriers.map{|x| "ucm/x-utf8-#{x}.ucm"}].flatten
task :ucm => ucm_files

encodings.each do |carrier|
    file "ucm/x-sjis-#{carrier}-raw.ucm" => ['dat/softbank-table.yaml', 'dat/kddi-table.yaml', "tools/make-sjis-ucm.pl", "dat/docomo-table.yaml"] do
        sh "#{perl} ./tools/make-sjis-ucm.pl"
    end
end
file 'tools/make-sjis-ucm.pl'

carriers.map{|x|"ucm/x-utf8-#{x}.ucm"}.each { |f|
    file f => ['dat/convert-map-utf8.yaml'] do
        sh "#{perl} ./tools/make-utf8-ucm.pl"
    end
}

# -------------------------------------------------------------------------
# carrier pdf

file 'typeD.pdf' do
    sh 'wget http://www.au.kddi.com/ezfactory/tec/spec/pdf/typeD.pdf'
end

# -------------------------------------------------------------------------

task :clean do
    sh 'rm typeD.pdf' if File.exist?('typeD.pdf')
    sh "rm #{ucm_files.join(' ')} #{dat_files.join(' ')}"
end

