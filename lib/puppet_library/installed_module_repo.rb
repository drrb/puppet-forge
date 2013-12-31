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

class PuppetLibrary::InstalledModuleRepo
    def initialize(environment, metadata_extractor, archiver)
        @environment = environment
        @metadata_extractor = metadata_extractor
        @archiver = archiver
    end

    def get_module(author, name, version)
        mod = modules(author, name).find do |m|
            m.version == version
        end
        if mod.nil?
            nil
        else
            @archiver.archive(mod)
        end
    end

    def get_metadata(author, name)
        #TODO: fails for modules with no metadata file
        modules(author, name).map do |mod|
            @metadata_extractor.get_metadata(mod)
        end
    end

    def modules(author, name)
        #env = Puppet::Node::Environment.new
        @environment.modules.select {|m| m.forge_name == "#{author}/#{name}"}
    end
end
