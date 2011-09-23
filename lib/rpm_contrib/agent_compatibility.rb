if NewRelic::VERSION::STRING < '3.2.0'
  module DependencyDetection
    def self.dependency_by_name(name)
      @@items.find {|i| i.name == name }
    end

    class Dependent
      attr_reader :name
    end
  end
end
