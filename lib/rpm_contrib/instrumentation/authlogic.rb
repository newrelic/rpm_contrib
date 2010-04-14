if defined? Authlogic::Session::Base && !NewRelic::Control.instance['disable_authlogic']
  Authlogic::Session::Base.class_eval do
  #  add_method_tracer :record, 'Authlogic/record'
    class << self
      add_method_tracer :find, 'Authlogic/find'
    end
  end
end
