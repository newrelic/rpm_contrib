module RPMContrib
  module Instrumentation
    # == Instrumentation for Camping
    # To instrument all controllers do the following:
    # 1. Add require 'rpm_contrib' after loading camping.
    # 2. Add an include at the end of your main Camping app module
    # 3. Run the following command to get the NewRelic license key to use: heroku config -all
    # 4. Create a newrelic.yml under the /config folder with the following content:
    #
    #	 common: &default_settings
    #       license_key: 'PASTE THE VALUE OF NEW_RELIC_LICENSE_KEY HERE'
    #	    app_name: PASTE THE NAME OF YOUR CAMPING APP HERE
    #	    monitor_mode: true
    #
    #	 production:
    #       <<: *default_settings
    #
    # Camping code example:
    # -------------------------------------------------------------------------------------
    #
    #	require "rpm_contrib"
    #
    #	Camping.goes :NewRelicCampingTest
    #
    #	module NewRelicCampingTest
    #	  # your code
    #
    #	  include RPMContrib::Instrumentation::Camping
    #
    #	end
    #
    #
    module Camping

      def self.included(mod)
        require 'new_relic/agent/instrumentation/controller_instrumentation'
        # Since the Camping::Base module is essentially copied
        # into the main module (the mod passed in) of a Camping app
        # using the Camping.goes :NewRelicCampingTest syntax
        # we need to evaluate "weld" the NewRelic plugin in the context of the new Base

        (Kernel.const_get(mod.name)::Base).module_eval do
          include NewRelic::Agent::Instrumentation::ControllerInstrumentation
          add_transaction_tracer :service
        end
      end

    end	#RPMContrib::Instrumentation::Camping
  end
end
