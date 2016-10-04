require 'spec_helper'
require 'ostruct'

describe Hana::Routing::Mapper do
  let(:endpoints) do
    {
      get: [{
        path: '/todos',
        pattern: [%r{^/todos$}, []],
        klass_and_method: ['TodosController', :index]
      }]
    }
  end

  let(:request) do
    request_params = { path_info: '/todos', request_method: 'GET' }
    OpenStruct.new(request_params)
  end

  let(:mapper) { Hana::Routing::Mapper.new(endpoints) }

  describe '#map_to_route' do
    it 'returns a route matching the giving request' do
      route = mapper.map_to_route(request)

      expect(route.request).to eq(request)
    end
  end

  describe '#match_path_with_pattern' do
    context 'when a path matches pattern' do
      it 'returns true' do
        path = '/todos'
        expect(mapper.match_path_with_pattern(path, endpoints[:get].first))
          .to be_truthy
      end
    end

    context 'when a path does not match pattern' do
      it 'returns falsey value' do
        path = '/todos/1'
        expect(mapper.match_path_with_pattern(path, endpoints[:get].first))
          .to be_falsey
      end
    end
  end
end
