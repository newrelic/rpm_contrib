require 'new_relic/control/ruby'
# This is the framework control object for Camping apps.
# It is loaded by virtue of detecting 'camping' as the framework
# in the rpm_contrib/detection/camping.rb file.  It gets loaded
# by the new_relic/control.rb file.
class NewRelic::Control #:nodoc:
  class Camping < NewRelic::Control::Ruby
    def init_config(options)
      super
      @local_env.dispatcher = 'camping'
      self['app_name'] ||= 'Camping Application'
    end
  end
end
