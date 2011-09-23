module RPMContrib::LanguageSupport
  extend self
  
  @@forkable = nil
  
  def can_fork?
    # this is expensive to check, so we should only check once
    return @@forkable if @@forkable != nil

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
    Process.fork { exit! }
    true
  rescue NotImplementedError
    false
  end
end
