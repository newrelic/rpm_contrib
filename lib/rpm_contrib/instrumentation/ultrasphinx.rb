require 'new_relic/agent/method_tracer.rb'

module Ultrasphinx
  class Search
    include NewRelic::Agent::MethodTracer

    add_method_tracer :run
    add_method_tracer :results
  end
end