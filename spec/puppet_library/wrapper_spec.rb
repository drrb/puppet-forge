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

describe PuppetLibrary::Wrapper do
    let(:server) { double('server') }
    let(:wrapper) { PuppetLibrary::Wrapper.new(server) }

    describe "#start" do
        it "starts the server" do
            dispatch = double('dispatch')
            rack_server = double('rack_server')
            expect(Rack::Builder).to receive(:app).and_return(dispatch)
            expect(Rack::Server).to receive(:new).with(
                :app => dispatch,
                :Host => "0.0.0.0",
                :Port => "4567"
            ).and_return(rack_server)
            expect(rack_server).to receive(:start)

            wrapper.start
        end
    end

    describe "#stop" do
        it "does nothing" do
            expect(wrapper).to respond_to(:stop)
        end
    end

    describe "#wait_for_shutdown" do
        it "does nothing" do
            expect(wrapper).to respond_to(:wait_for_shutdown)
        end
    end
end
