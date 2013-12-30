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
