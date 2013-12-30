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
require 'puppet'
require 'puppet/daemon'

describe Puppet::Application::Forge do

    let(:forge) { Puppet::Application[:forge] }
    let(:daemon) { double('daemon').as_null_object }
    let(:library_server) { double('library_server') }
    let(:server) { double('server') }

    before :each do
        allow(Puppet::Daemon).to receive(:new).and_return(daemon)
        allow(daemon).to receive(:daemonize)
        allow(Puppet::Util::Log).to receive(:newdestination)
        allow(PuppetLibrary::Server).to receive(:new).and_return(library_server)
        allow(PuppetLibrary::Wrapper).to receive(:new).and_return(server)
    end

    describe "during preinit" do
        it "should catch INT" do
            expect(Signal).to receive(:trap).with(:INT)

            forge.preinit
        end
    end

    describe "starting" do
        it "sets up server" do
            expect(PuppetLibrary::Wrapper).to receive(:new).with(library_server)
            expect(daemon).to receive(:server=).with(server)

            forge.run_command
        end

        it "starts in the forground" do
            expect(daemon).not_to receive(:daemonize)
            expect(daemon).to receive(:start)

            forge.run_command
        end

        it "announces itself starting" do
            expect(Puppet).to receive(:notice).with("Starting Puppet Forge")

            forge.run_command
        end

        context "when --daemonize is specified" do
            before do
                forge.handle_daemonize(true)
            end

            it "daemonizes" do
                expect(daemon).to receive(:daemonize)

                forge.run_command
            end
        end

        context "when --verbose is specified" do
            before do
                forge.handle_verbose(true)
            end

            it "sets the log level to debug" do
                forge.run_command

                expect(Puppet::Util::Log.level).to eq :debug
            end
        end
    end
end
