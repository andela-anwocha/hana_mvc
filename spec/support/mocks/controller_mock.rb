module Mocks
  module Controller
    def mock_controller_action(action)
      allow_any_instance_of(subject).to receive(action)
      allow_any_instance_of(subject).to receive(:render).
        and_return(controller.response("Response Body"))
    end

    def mock_before_action(action, return_value)
      allow_any_instance_of(subject).to receive(action).
        and_return(return_value)
    end

    def mock_file_join
      allow(File).to receive(:join).
        and_return("spec/support/views/index.html.erb")
    end

    def initialize_class_variables
      subject.class_variable_set(:@@only, nil)
      subject.class_variable_set(:@@except, nil)
      subject.class_variable_set(:@@before_action, nil)
    end

    def before_action(action, attribute)
      initialize_class_variables
      subject.before_action action, attribute
    end
  end
end
