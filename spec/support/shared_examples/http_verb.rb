shared_examples_for 'a http verb' do |http_verb|
  context 'when routes have no placeholders' do
    before(:each) { subject.send(http_verb, '/todos', to: 'todos#index') }

    it 'populates the endpoints instance variable' do
      expect(endpoints.length).to eq(1)
    end

    it 'stores the controller and action methods from route provided' do
      expect(endpoints[http_verb].last[:klass_and_method])
        .to match_array ['TodosController', :index]
    end

    it 'stores a unique regex pattern for each route provided' do
      expect(endpoints[http_verb].last[:pattern])
        .to match_array [%r{^/todos$}, []]
    end
  end

  context 'when routes have placeholders' do
    before(:each) { subject.send(http_verb, '/todos/:id', to: 'todos#index') }

    it 'stores the placeholders for the routes in an array' do
      expect(endpoints[http_verb].last[:pattern][1])
        .to match_array ['id']
    end

    it 'stores a named regex pattern for the routes' do
      expect(endpoints[http_verb].last[:pattern][0])
        .to eq %r{^/todos/(?<id>[^/?#]+)$}
    end
  end
end
