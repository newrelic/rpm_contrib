require 'new_relic/agent/instrumentation/controller_instrumentation'

module RPMContrib
  module Instrumentation
    # == Instrumentation for Camping
    # To instrument all controllers do the following:
    # 1. Add the necessary NewRelic-specific requires in your require section
    # 2. Add an include at the end of your main Camping app module
    # 3. Add a call to NewRelic::Agent.manual_start  at the end of the file to start the agent
    # 4. Run the following command to get the NewRelic license key to use: heroku config -all
    # 5. Create a newrelic.yml under the /config folder with the following content:
    #
    #					common: &default_settings
    #  					  license_key: 'PASTE THE VALUE OF NEW_RELIC_LICENSE_KEY HERE'
    #					  agent_enabled: true
    #					  app_name: PASTE THE NAME OF YOUR CAMPING APP HERE
    #					  enabled: true
    #
    #					production:
    #					  <<: *default_settings
    #					  enabled: true
    #
    #	Camping code example:
    #	--------------------------------------------------------------------------------------
    #	require "newrelic_rpm"
    #	require 'new_relic/agent/agent'
    #	require 'new_relic/agent/instrumentation/controller_instrumentation'
    #	require 'new_relic/agent/instrumentation/camping'
    #
    #	Camping.goes :NewRelicCampingTest
    #
    #	module NewRelicCampingTest
    #		# your code
    #
    #		include NewRelic::Agent::Instrumentation::ControllerInstrumentation
    #		include NewRelic::Agent::Instrumentation::Camping
    #	end
    #
    #	NewRelic::Agent.manual_start 
    #
    
    module Camping
      
      def self.included(mod)
        
        # Since the Camping::Base module is essentially copied
        # into the main module (the mod passed in) of a Camping app 
        # using the Camping.goes :NewRelicCampingTest syntax
        # we need to evaluate "weld" the NewRelic plugin in the context of the new Base
        
        (Kernel.const_get(mod.name)::Base).module_eval do
          
          # Add the new method to the Camping app's Base module
          # since the Camping::Base module is being included
          # in every Camping controller
          
          def service_with_newrelic(*args)
            perform_action_with_newrelic_trace(:category => :rack) do
              service_without_newrelic(*args)
            end
          end
          
          # Alias the "standard" service method
          # so we can provide a level of indirection 
          # to perform the tracing for NewRelic
          
          alias service_without_newrelic service
          alias service service_with_newrelic
        end
      end
      
    end	#RPMContrib::Instrumentation::Camping
  end
end
