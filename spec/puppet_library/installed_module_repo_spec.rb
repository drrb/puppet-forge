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

require 'spec_helper'
require 'puppet_library/installed_module_repo'

module PuppetLibrary
    PuppetModule = Struct.new(:author, :name, :version) do
        def forge_name
            "#{author}/#{name}"
        end
    end

    class FakeMetadataExtractor
        def get_metadata(mod)
            { "author" => mod.author, "name" => mod.name, "version" => mod.version }
        end
    end

    class FakeArchiver
        def archive(mod)
            "archive of #{mod.forge_name}"
        end
    end

    describe InstalledModuleRepo do
        let(:modules) { [] }
        let(:environment) { double('environment', :modules => modules) }
        let(:archiver) { FakeArchiver.new }
        let(:metadata_extractor) { FakeMetadataExtractor.new }
        let(:repo) { InstalledModuleRepo.new(environment, metadata_extractor, archiver) }

        describe "#get_module" do
            context "when module not present" do
                before do
                    modules << PuppetModule.new("puppetlabs", "apache", "2.0.0")
                end

                it "returns nil" do
                    module_archive = repo.get_module("puppetlabs", "apache", "1.0.0")

                    expect(module_archive).to be_nil
                end
            end

            context "when module present" do
                before do
                    modules << PuppetModule.new("puppetlabs", "apache", "1.0.0")
                end

                it "returns a GZipped tar of the module directory" do
                    module_archive = repo.get_module("puppetlabs", "apache", "1.0.0")

                    expect(module_archive).to eq "archive of puppetlabs/apache"
                end
            end
        end

        describe "#get_metadata" do
            context "when module not present" do
                it "returns an empty array" do
                    modules = repo.get_metadata("puppetlabs", "apache")

                    expect(modules).to be_empty
                end
            end

            context "when module present" do
                before do
                    modules << PuppetModule.new("puppetlabs", "apache", "1.0.0")
                    modules << PuppetModule.new("puppetlabs", "apache", "1.0.1")
                end

                it "returns an array containing the parsed module metadata" do
                    modules = repo.get_metadata("puppetlabs", "apache")

                    expect(modules.size).to eq 2
                    expect(modules.first).to eq({ "author" => "puppetlabs", "name" => "apache", "version" => "1.0.0" })
                end
            end
        end
    end
end
