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

class Puppet::Application::Forge < Puppet::Application
    def preinit
        Signal.trap(:INT) do
            $stderr.puts "Canceling startup"
            exit 0
        end
    end

    def run_command
        pid_file = File.expand_path("library.pid")
        daemon = Puppet::Daemon.new(Puppet::Util::Pidlock.new(pid_file))
        daemon.server = PuppetLibrary::Wrapper.new
        daemon.daemonize
        daemon.start
    end
end
