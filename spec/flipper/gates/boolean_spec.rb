require 'helper'
require 'flipper/instrumenters/memory'

describe Flipper::Gates::Boolean do
  let(:adapter) { double('Adapter', :read => nil) }
  let(:feature) { double('Feature', :key => 'search', :name => :search, :adapter => adapter) }
  let(:instrumenter) { Flipper::Instrumenters::Memory.new }

  subject {
    described_class.new(feature, :instrumenter => instrumenter)
  }

  describe "#description" do
    context "for enabled" do
      it "returns Enabled" do
        subject.description(true).should eq('Enabled')
      end
    end

    context "for disabled" do
      it "returns Disabled" do
        subject.description(false).should eq('Disabled')
      end
    end
  end

  describe "instrumentation" do
    it "is recorded for open" do
      thing = nil
      subject.open?(thing, false)

      event = instrumenter.events.last
      event.should_not be_nil
      event.name.should eq('gate_operation.flipper')
      event.payload.should eq({
        :thing => thing,
        :operation => :open?,
        :result => false,
        :gate_name => :boolean,
        :feature_name => :search,
      })
    end
  end
end
