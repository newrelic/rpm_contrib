module RPMContrib::LanguageSupport
  extend self
  
  @@forkable = nil
  
  def can_fork?
    # this is expensive to check, so we should only check once
    NewRelic::Agent.logger.debug("can_fork? called")
    return @@forkable if @@forkable != nil
    NewRelic::Agent.logger.debug("can_fork? memoization miss")


    if Process.respond_to?(:fork)
      # if this is not 1.9.2 or higher, we have to make sure
      @@forkable = ::RUBY_VERSION < '1.9.2' ? test_forkability : true
    else
      @@forkable = false
    end

    @@forkable
  end

  private

  def test_forkability
    NewRelic::Agent.logger.debug("test_forkability called")
    Process.fork { exit! }
    true
  rescue NotImplementedError
    false
  end
end
