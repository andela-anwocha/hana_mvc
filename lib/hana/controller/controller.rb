require 'tilt/erb'

module Hana
  class Controller
    attr_reader :request

    def initialize(request)
      @request ||= request
    end

    def params
      request.params.symbolize_keys
    end

    def response(body, status = 200, header = {})
      @response = Rack::Response.new(body, status, header)
    end

    def render(*args)
      if args[0].is_a?(Hash) && args[0].key?(:json)
        return json_response(args[0])
      end
      response(render_template(*args), 200, 'Content-Type' => 'text/html')
    end

    def redirect_to(address)
      response([], 301, 'Location' => address)
    end

    def render_template(view_name, locals = {})
      file_name = File.join('app', 'views', controller_name, "#{view_name}.html.erb")
      template = Tilt::ERBTemplate.new(file_name).render(self, locals)

      if self.class.layout
        layout_file_name = File.join('app', 'layouts', "#{@@layout_name}.html.erb")
        layout_template = Tilt::ERBTemplate.new(layout_file_name)
        layout_template.render(self, locals) { template }
      else
        template
      end
    end

    def dispatch(action)
      handle_before_action(action)
      send(action)

      return @response if @response
      render(action)
    end

    def self.layout(view_name = nil)
      @layout_name ||= view_name
    end

    def self.before_action(action_name = nil, attributes = {})
      @only ||= attributes[:only]
      @except ||= attributes[:except]
      @before_action ||= action_name
    end

    private

    def json_response(args)
      header = { 'Content-Type' => 'application/json' }
      response(args[:json].to_json, args[:status], header)
    end

    def before_action?(action)
      @before_action && (!@only || @only.include?(action)) &&
        (@except.nil? || !@except.include?(action))
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, '').downcase
    end

    def handle_before_action(action)
      send(@before_action) if before_action?(action)
    end
  end
end
