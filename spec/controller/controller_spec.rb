crequire "spec_helper"

describe Hana::Controller do

  let(:params){ {name: "Andela", age: 10 } }
  let(:request){ OpenStruct.new({ params: params }) }
  let(:controller){ Hana::Controller.new(request) }
  subject { Hana::Controller }

  describe "#params" do
    it "returns the request params" do
      expect(controller.params).to eq(params)
    end
  end

  describe "#response" do
    it "returns a rack response object" do
      body = "Request body"
      expect(controller.response(body)).
        to be_instance_of(Rack::Response)
    end
  end

  describe "#render" do
    context "when used with a json hash" do
      it "renders a rack response object" do
        expect(controller.render(json: { name: "test" })).
          to be_instance_of(Rack::Response)
      end

      it "renders a response with 'application/json' content type" do
        response = controller.render(json: { name: "test" })
        expect(response.header["Content-Type"]).to eq("application/json")
      end
    end

    context "when used without a json hash" do
      it "renders a rack response object" do
        expect(controller.render(json: { name: "test" })).
          to be_instance_of(Rack::Response)
      end

      it "renders a response with 'text/html' content type" do
        mock_file_join
        response = controller.render("Test")
        expect(response.header["Content-Type"]).to eq("text/html")
      end
    end
  end

  describe "#redirect_to" do
    before { @response =  controller.redirect_to("/") }
    it "returns a Rack response" do
      expect(@response).to be_instance_of(Rack::Response)
    end

    it "returns a response with a 301 http status" do
      expect(@response.status).to eq(301)
    end

    it "returns a response with a location http header" do
      expect(@response.header["Location"]).to eq("/")
    end
  end

  describe "#dispatch" do
    before(:each) do
      mock_controller_action(:index)
    end

    it "calls the action method passed into dispatch" do
      expect(controller).to receive(:index)
      controller.dispatch(:index)
    end

    it "instantiates a new rack response and assigns it to @response" do
      response = controller.instance_variable_get(:@response)
      controller.dispatch(:index)

      expect(response).to_not be_nil
      expect(response).to be_instance_of(Rack::Response)
    end

    it "returns the rack response" do
      expect(controller.dispatch(:index)).to be_instance_of(Rack::Response)
    end
  end

  describe ".before_action" do
    before(:each) do
      mock_controller_action(:index)
      mock_controller_action(:home)
      mock_before_action(:set_params, true)
    end

    context "when 'only' attributes are specified" do
      before { before_action :set_params, only: [:index] }

      it "assigns the action_name and 'only' attributes to class variables" do
        before_action = subject.class_variable_get(:@@before_action)
        only = subject.class_variable_get(:@@only)

        expect(before_action).to eq(:set_params)
        expect(only).to eq([:index])
      end

      context "when controller action is included in 'only' attribute" do
        it "calls the before_action method" do
          expect(controller).to receive(:set_params)
          controller.dispatch(:index)
        end

        context "when before_action method returns true" do
          it "calls the controller action method" do
            expect(controller).to receive(:index).at_least(:once)
            controller.dispatch(:index)
          end
        end

        context "when before_action method returns false" do
          it "does not call the controller action method" do
            mock_before_action(:set_params, false)

            expect(subject).to_not receive(:index)
            controller.dispatch(:index)
          end
        end
      end

      context "when controller action is not included in 'only' attribute" do
        before(:each){ before_action :set_params, only: [] }

        it "does not call the before_action method" do
          expect(subject).to_not receive(:set_params)
          controller.dispatch(:index)
        end
      end
    end

    context "when 'except' attributes are specified" do
      before(:each) { before_action :set_params, except: [:index] }

      it "assigns the action_name and 'except' attributes to class variables" do
        except = subject.class_variable_get(:@@except)
        expect(except).to eq([:index])
      end

      context "when controller action is included in 'except' array" do
        it "does not call the before_action method" do
          expect(controller).to_not receive(:set_params)
          controller.dispatch(:index)
        end

        it "calls the controller action method" do
          expect(controller).to receive(:home)
          controller.dispatch(:home)
        end
      end

      context "when controller action is not included in 'except' array" do
        before{ before_action :set_params, except: [:index] }

        it "calls the before_action method" do
          expect(controller).to receive(:set_params)
          controller.dispatch(:home)
        end


        context "when before_action method returns true" do
          it "calls the controller action method" do
            expect(controller).to receive(:home)
            controller.dispatch(:home)
          end
        end

        context "when before_action method returns false" do
          before{ mock_before_action(:set_params, false) }

          it "does not call the controller action method" do
            expect(controller).to_not receive(:home)
            controller.dispatch(:home)
          end
        end
      end
    end
  end
end
