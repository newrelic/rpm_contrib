# The RPM Contrib Gem

The `rpm_contrib` gem contains instrumentation for the New Relic RPM agent
contributed by the community of RPM users.  It requires the RPM Agent to run.

To use the rpm_contrib gem, install the `rpm_contrib` gem from rubygems.org.
It will also install the required version of the `newrelic_rpm` gem if it's not
already installed.

For Rails 3.0 and when using Bundler, add these dependencies to your Gemfile:

    gem 'rpm_contrib'
    gem 'newrelic_rpm'

For Rails 2.1 and later, add these dependencies to your in your environment.rb:

    config.gem 'rpm_contrib'
    config.gem 'newrelic_rpm'

For other frameworks, make sure you load rubygems if it isn't already, then just
require the rpm_contrib gem:

    require 'rubygems'
    require 'rpm_contrib'

When you load the rpm_contrib gem, the `newrelic_rpm` gem will also be
initialized.  No need for a separate require statement for `newrelic_rpm`. 

In non-Rails frameworks, it's important that the New Relic Agent gets
loaded as late as possible, or that the final initialization hook is called 
after all other frameworks have loaded:

    DependencyDetection.detect!

### Troubleshooting Startup

If you've set up your gems to load as described above and you are still not seeing 
data in RPM, there may be a bug in detecting your framework.  Try setting the 
environment variable `NEWRELIC_DISPATCHER` to the name of your app server (Camping, 
Resque, Rake, etc), and please report to us if this fixes the problem so we can
fix the auto-detection logic.

If this does not help then set the `log_level` to `debug` in the `newrelic.yml` file
and examine the `newrelic_agent.log` file for errors after restarting your app.

## Supported Frameworks

A number of frameworks are supported in the contrib gem.  They are all turned on
by default but you can add settings to your newrelic.yml to disable any of them.

### ActiveMQ

The gem will detect the underlying ActiveMessaging::Processor class and instrument the `on_message` method

It can be disabled with the `disable_active_mq` flag in your newrelic.yml file.

### Cassandra

The gem will instrument Cassandra so it should be visible in transaction traces and the web transactions page.

You can disable it with `disable_cassandra_instrumentation` in your newrelic.yml file.

### Camping

The gem will detect a Camping app but you need to manually add the
instrumentation to your configuration file.  See
RPMContrib::Instrumentation::Camping for more information. 

In addition you will need to load the gems in the following order: 1) Camping, 2) rpm_contrib,
3) newrelic_rpm.

### Crack

The gem will instrument the Crack parsers for JSON and XML - you
should see them in transaction traces and the web transactions page.

You can disable it with `disable_crack` in your newrelic.yml file.

### Curb

The gem will instrument both Curl::Easy and Curl::Multi - they should show up similarly to Net::HTTP in the UI

You can disable it with `disable_curb` in your newrelic.yml file.

## Elastic Search

The gem will instrument ElasticSearch::Client. The metrics should show up in the UI

You can disable it with `disable_elastic_search_instrumentation` in your newrelic.yml file.

### Paperclip

No special configuration required for Paperclip visibility.  

You can disable it by setting `disable_paperclip` to true in your newrelic.yml file.

### MongoDB

Our instrumentation works on the underlying 'Mongo' library.  

You can disable it by setting 'disable_mongodb' to true in your newrelic.yml file.

### Resque

To instrument jobs you no longer need to have your Job class inherit from Resque::Job or include 
the Resque::Plugins::NewRelicInstrumentation module.  The module definition was left in for 
backward compatibility.

To disable resque, set 'disable_resque' to true in your newrelic.yml file.

### Redis

Redis instrumentation will record operations as well as `allWeb` and `allOther`
summary metrics under the `Database/Redis` metric namespace. This instrumentation
supports Redis versions 1.x and 2.x. 

To disable Redis instrumentation, set 'disable_redis' to true in your newrelic.yml file.

### Sinatra view instrumentation

This adds instrumentation to the `render` methods in Sinatra::Base

You can disable it with `disable_sinatra_template` in your newrelic.yml file.

### Typhoeus instrumentation

This adds instrumentation to the Typhoeus::Request class for 'GET' requests

You can disable it with `disable_typhoeus` in your newrelic.yml file.

### Ultrasphinx instrumentation

This adds basic instrumentation to the `run` and `results` method of Ultrasphinx::Search

You can disable it with `disable_ultrasphinx` in your newrelic.yml file.

### Workling

This adds instrumentation to the Workling::Base and all children, for all defined public methods not inherited from the Workling::Base class

You can disable it with `disable_workling` in your newrelic.yml file.

### YAJL

This adds instrumentation to the YAJL json parser

You can disable it with `disable_yajl_instrumentation` in your newrelic.yml file.

### AWS/S3

Get metrics on how S3 is performing for you in production. To disable AWS/S3, set
'disable_aws-s3' to true in your newrelic.yml file.  For more information on this
instrumentation, check out [our blog](http://blog.newrelic.com/2010/07/06/monitoring-aws-s3/).

# How to Add Custom Instrumentation

We encourage contributions to this project and will provide whatever assistance
we can to those wishing to develop instrumentation for other open source Ruby
libraries.

When adding instrumentation to this gem, be sure and get familiar with the [RPM
Agent API](http://newrelic.github.com/rpm/classes/NewRelic/Agent.html) and
contact support@newrelic.com with any questions.

There are several extension points in the agent you can take advantage of with
this gem.

* Custom tracers which measure methods and give visibility to
  otherwise unmeasured libraries.
* Samplers which sample some value about once a minute.
* Dispatcher support for web request handlers which would otherwise be undetected.
  In order for the agent to turn on in 'auto' mode it needs to discover a 
  web dispatcher, or be [started manually](http://support.newrelic.com/faqs/general/manual-start).
* Framework support, for alternatives to Rails like Camping or Ramaze

## Custom Tracers

Custom tracers for frameworks should be added to the `lib/rpm_contrib/instrumentation`
directory.  These files are loaded at the time the Agent starts.  **They will not
be loaded if the Agent does not start up.** 

It is important that you wrap any instrumentation with the checks necessary to
determine if the code being instrumented is loaded.  You can't add code to the
contrib gem that will break when run in any other context besides yours.


For details on how to define custom tracers, refer to the [support documentation
on adding custom
tracers](http://support.newrelic.com/faqs/docs/custom-metric-collection).  You
can also get detailed information on the API from the [Agent method tracing
rdocs](http://newrelic.github.com/rpm/classes/NewRelic/Agent/MethodTracer.html),
especially the
[add_method_tracer](http://newrelic.github.com/rpm/classes/NewRelic/Agent/MethodTracer/ClassMethods.html)
docs.

A good example can be found in `lib/rpm_contrib/instrumentation/paperclip.rb`.

## Samplers

You can add samplers which will record metrics approximately once a minute.
Samplers are useful for capturing generic instrumentation for display in [custom
views](http://support.newrelic.com/faqs/docs/custom-dashboard-specification).

Samplers should extend the
[`NewRelic::Agent::Sampler`](http://newrelic.github.com/rpm/classes/NewRelic/Agent/Sampler.html)
class.  They should be placed in the `samplers` directory.

Refer to examples in the RPM agent to see how to get started.

## Supporting New Dispatchers

If you want to add support for a new dispatcher which is not being recognized by
default by the RPM agent, add code to the `rpm_contrib/detection` directory.
This code needs to define a module in the `NewRelic::LocalEnvironment` class.
This module will be accessed at the time environment detection takes place, when
the agent is initialized.

This module should define the method `discover_dispatcher` and return the name
of the dispatcher if detected, or defer to super.  See
`rpm_contrib/detection/camping.rb` for a good example.

## Supporting New Frameworks

Supporting new frameworks can be pretty involved and generally involves both
adding custom instrumentation as well as framework and dispatcher detection.

In addition it will be necessary to define a new control class with the same 
name as the framework.  This control class must go in `new_relic/control`.

Refer to the camping example in this gem to see how this is done in general.

If you decide to tackle any new frameworks, contact support@newrelic.com and
we'll be happy to help you work through it.

# Note on Patches/Pull Requests
 
* Fork the http://www.github.com/newrelic/rpm_contrib project.
* Add instrumentation files to `lib/rpm_contrib/instrumentation`.  These
  files will be loaded when the RPM agent is initialized.
* Add samplers to `lib/rpm_contrib/samplers`.  These classes are
  installed automatically when the RPM agent is initialized.
* Add tests.  
* Commit, do not mess with the Rakefile, version, or history.  (if you
  want to have your own version, that is fine but bump version in a
  commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

# Further Information

Refer to the Agent API Documentation at http://newrelic.github.com/rpm

See the support site faqs at http://support.newrelic.com/faqs for additional
tips and documentation.

Contact support@newrelic.com for help.

### Copyright

Copyright (c) 2009-2010 New Relic. See LICENSE for details.
