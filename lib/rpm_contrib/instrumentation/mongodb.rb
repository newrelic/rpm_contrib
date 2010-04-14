# Just drop this little diddy in your app to get some (not perfect) information on query times and such
# This will eventually become an official plugin but for those who can't wait, enjoy.


module RPMContrib::Instrumentation
  module MongoDB
    def self.included(model)
      model.metaclass.class_eval do
        add_method_tracer :find,        'Database/#{self.name}/find'
        add_method_tracer :find!,       'Database/#{self.name}/find!'
        add_method_tracer :paginate,    'Database/#{self.name}/paginate'
        add_method_tracer :first,       'Database/#{self.name}/first'
        add_method_tracer :last,        'Database/#{self.name}/last'
        add_method_tracer :all,         'Database/#{self.name}/all'
        add_method_tracer :count,       'Database/#{self.name}/count'
        add_method_tracer :create,      'Database/#{self.name}/create'
        add_method_tracer :create!,     'Database/#{self.name}/create!'
        add_method_tracer :update,      'Database/#{self.name}/update'
        add_method_tracer :delete,      'Database/#{self.name}/delete'
        add_method_tracer :delete_all,  'Database/#{self.name}/delete_all'
        add_method_tracer :destroy,     'Database/#{self.name}/destroy'
        add_method_tracer :destroy_all, 'Database/#{self.name}/destroy_all'
        add_method_tracer :exists?,     'Database/#{self.name}/exists?'
        add_method_tracer :find_by_id,  'Database/#{self.name}/find_by_id'
        add_method_tracer :increment,   'Database/#{self.name}/increment'
        add_method_tracer :decrement,   'Database/#{self.name}/decrement'
        add_method_tracer :set,         'Database/#{self.name}/set'
        add_method_tracer :push,        'Database/#{self.name}/push'
        add_method_tracer :push_all,    'Database/#{self.name}/push_all'
        add_method_tracer :push_uniq,   'Database/#{self.name}/push_uniq'
        add_method_tracer :pull,        'Database/#{self.name}/pull'
        add_method_tracer :pull_all,    'Database/#{self.name}/pull_all'
      end
      
      model.class_eval do
        add_method_tracer :save,        'Database/#{self.class.name}/save'
      end
    end
  end
  ::MongoMapper::Document.append_inclusions(::RPMContrib::Instrumentation::MongoDB)
end if defined?(::MongoMapper)
