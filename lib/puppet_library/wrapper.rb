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

require 'rack'

module PuppetLibrary
    class Wrapper
        def initialize(library_server)
            @rack_server = create_rack_server(library_server)
        end

        def create_rack_server(server)
            dispatch = Rack::Builder.app do
                #TODO: is map '/' required?
                map '/' do
                    run server
                end
            end

            Rack::Server.new({
                app: dispatch,
                Host: "0.0.0.0",
                Port: "4567"
            })
        end

        def start
            @rack_server.start
        end

        def stop
        end

        def wait_for_shutdown
        end
    end
end
