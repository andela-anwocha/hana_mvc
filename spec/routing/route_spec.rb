require 'spec_helper'

describe Hana::Routing::Route do
  let(:request) { OpenStruct.new {} }
  let(:klass_and_method) { ['Hash', :index] }
  let(:route) { Hana::Routing::Route.new(request, klass_and_method) }

  describe '#klass' do
    it 'returns the controller class' do
      expect(route.klass).to eq(Hash)
    end
  end

  describe '#dispatch' do
    it 'calls the dispatch method on the controller instance' do
      expect_any_instance_of(Hash).to receive(:dispatch)
      route.dispatch
    end
  end
end
