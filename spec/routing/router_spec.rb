require 'spec_helper'

describe Hana::Routing::Router do
  let!(:endpoints) { subject.endpoints }

  describe '.draw' do
    it 'evaluates a passed in block' do
      endpoints = []
      subject.draw { endpoints << 1 }
      expect(endpoints).to match_array([1])
    end
  end

  describe '.endpoints' do
    it 'creates an array for each unique key' do
      expect(endpoints[:get]).to match_array []
    end
  end

  describe '.get' do
    it_behaves_like 'a http verb', :get
  end

  describe '.post' do
    it_behaves_like 'a http verb', :post
  end

  describe '.put' do
    it_behaves_like 'a http verb', :put
  end

  describe '.patch' do
    it_behaves_like 'a http verb', :patch
  end

  describe '.delete' do
    it_behaves_like 'a http verb', :delete
  end

  describe '.root' do
    it 'calls the get method for the provided route' do
      expect(subject).to receive(:get).with('/', to: 'todos#index')
      subject.root 'todos#index'
    end
  end
end
