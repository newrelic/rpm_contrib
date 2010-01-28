# The RPM Contrib Gem

The `rpm_contrib` gem contains instrumentation for the New Relic RPM agent
contributed by the community of RPM users.  It requires the RPM Agent
to run.

We encourage contributions to this project and will provide whatever
assistance we can to those wishing to develop instrumentation for
other open source Ruby libraries.

## Note on Patches/Pull Requests
 
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

## Further Information

See http://newrlic.github.com/rpm for API documentation on the Agent.

See http://support.newrelic.com/faqs for additional tips and documentation.

Contact support@newrelic.com for help.

== Copyright

Copyright (c) 2010 New Relic. See LICENSE for details.
