if defined?(::Mongoid) && !NewRelic::Control.instance['disable_mongodb']

  module Mongoid #:nodoc:
    module Document

      #adding call to super
      class << self
        alias :old_included :included

        def included(model)
          old_included(model)
          super
        end
      end
    end
  end

  module RPMContrib::Instrumentation

    module Mongoid
      def included(model)
        model.metaclass.class_eval do
          puts "adding mongoid method tracers for #{model.name}"
          add_method_tracer :create, 'Database/#{self.name}/create'
          add_method_tracer :create!, 'Database/#{self.name}/create!'
          add_method_tracer :delete_all, 'Database/#{self.name}/delete_all'
          add_method_tracer :destroy_all, 'Database/#{self.name}/destroy_all'
          add_method_tracer :all, 'Database/#{self.name}/all'
          add_method_tracer :find, 'Database/#{self.name}/find'
          add_method_tracer :first, 'Database/#{self.name}/first'
          add_method_tracer :last, 'Database/#{self.name}/last'
          add_method_tracer :find_or_create_by, 'Database/#{self.name}/find_or_create_by'
          add_method_tracer :find_or_initialize_by, 'Database/#{self.name}/find_or_initialize_by'
          add_method_tracer :min, 'Database/#{self.name}/min'
          add_method_tracer :max, 'Database/#{self.name}/max'
          add_method_tracer :sum, 'Database/#{self.name}/sum'
        end

        model.class_eval do
          add_method_tracer :update_attributes, 'Database/#{self.class.name}/update_attributes'
          add_method_tracer :update_attributes!, 'Database/#{self.class.name}/update_attributes!'
          add_method_tracer :save, 'Database/#{self.class.name}/save'
          add_method_tracer :save!, 'Database/#{self.class.name}/save!'
          add_method_tracer :delete, 'Database/#{self.class.name}/delete'
          add_method_tracer :destroy, 'Database/#{self.class.name}/destroy'

        end
        super
      end
    end
    ::Mongoid::Document.extend(RPMContrib::Instrumentation::Mongoid)
  end
end
