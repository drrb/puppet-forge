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

require 'puppet/application'
require 'puppet/util/pidlock'
require 'puppet_library/wrapper'
require 'puppet_library/server'

class Puppet::Application::Forge < Puppet::Application
    option("--daemonize", "-D")
    option("--verbose", "-v")

    def preinit
        Signal.trap(:INT) do
            $stderr.puts "Canceling startup"
            exit 0
        end
    end

    def run_command
        Puppet::Util::Log.level = :debug if options[:verbose]

        library_server = PuppetLibrary::Server.new(PuppetLibrary::InstalledModuleRepo.new)

        pid_file = File.expand_path("library.pid")
        Puppet.debug "Writing Puppet Forge PID file at #{pid_file}"
        daemon = Puppet::Daemon.new(Puppet::Util::Pidlock.new(pid_file))
        daemon.server = PuppetLibrary::Wrapper.new(library_server)

        daemon.daemonize if options[:daemonize]
        Puppet.notice("Starting Puppet Forge")
        daemon.start
    end
end
