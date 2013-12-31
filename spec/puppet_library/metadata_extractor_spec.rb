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

require 'puppet_library/metadata_extractor'

module PuppetLibrary
    describe MetadataExtractor do
        let(:module_dir) { "/tmp/metadataextractorspec_module#{$$}" }
        let(:metadata_file) { module_dir + "/metadata.json" }
        let(:mod) { Struct.new(:metadata_file).new(metadata_file) }
        let(:metadata_extractor) { MetadataExtractor.new }

        before do
            FileUtils.mkdir_p module_dir

            File.open(metadata_file, "w") do |f|
                f.puts '{"name": "apache"}'
            end
        end

        after do
            FileUtils.rm_rf module_dir
        end

        describe "#get_metadata" do
            it "parses the metadata file as JSON" do
                metadata = metadata_extractor.get_metadata(mod)

                expect(metadata["name"]).to eq "apache"
            end
        end
    end
end
