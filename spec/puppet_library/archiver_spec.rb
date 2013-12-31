# -*- encoding: utf-8 -*-
# Private Puppet Forge
# Copyright (C) 2013 drrb
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'puppet_library/archiver'
require 'rubygems/package'
require 'zlib'

module PuppetLibrary
    describe Archiver do
        let(:module_dir) { "/tmp/archiverspec_module#{$$}" }
        let(:metadata_file) { module_dir + "/metadata.json" }
        let(:mod) { PuppetModule.new("puppetlabs", "apache", "1.0.1", module_dir) }
        let(:archiver) { Archiver.new }

        before do
            FileUtils.mkdir_p module_dir

            File.open(metadata_file, "w") do |f|
                f.puts '{"name": "apache"}'
            end
        end

        after do
            FileUtils.rm_rf module_dir
        end

        describe "#archive" do
            it "tars and GZips the module directory" do
                archive = archiver.archive(mod)

                tar = Gem::Package::TarReader.new(Zlib::GzipReader.new(archive))
                tar.rewind
                meta_file = tar.find {|e| e.full_name =~ /[^\/]+\/metadata\.json/}
                meta = JSON.parse(meta_file.read)
                expect(meta["name"]).to eq "apache"
            end
        end
    end
end
