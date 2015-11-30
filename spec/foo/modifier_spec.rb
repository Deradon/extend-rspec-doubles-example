require 'spec_helper'

RSpec.describe Foo::Modifier do
  subject(:modifier) { described_class.new(active) }

  describe "#apply_to(obj)" do
    subject(:obj) { instance_double(Foo, foo: "foo") }

    before { modifier.apply_to(obj) }

    context "when active" do
      let(:active) { true }
      its(:foo) { is_expected.to eq("extended-foo") }
    end

    context "when not active" do
      let(:active) { false }
      its(:foo) { is_expected.to eq("foo") }
    end
  end
end
