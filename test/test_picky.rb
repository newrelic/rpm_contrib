require 'picky'

require "#{File.dirname(__FILE__)}/helper"

class NewRelic::Agent::PickyIntrumentationTest < Test::Unit::TestCase

  def tokens_for *tokens
    tokens.map{|t|
      token = 'whatever'

      token.extend Module.new{
        define_method(:'partial?'){ t[:partial] }
        define_method(:'similar?'){ t[:similar] }
        define_method(:'qualifiers'){ t[:qualifiers] }
      }

      token
    }
  end
  
  def test_obfuscate_tokens
    tokens = tokens_for({})
    assert_equal 'xxx', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for({:similar => true})
    assert_equal 'xxx~', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for({:partial => true})
    assert_equal 'xxx*', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for({:qualifiers => [:haha]})
    assert_equal 'haha:xxx', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for( {:partial => true}, {:similar => true} )
    assert_equal 'xxx* xxx~', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for( {:similar => true}, {:partial => true} )
    assert_equal 'xxx* xxx~', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for( {:partial => true}, {:partial => true} )
    assert_equal 'xxx* xxx*', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for(
      {:similar => true, :qualifiers => [:bla]},
      {:partial => true, :qualifiers => [:bla, :blub]}
    )
    assert_equal 'bla,blub:xxx* bla:xxx~', Picky::NewRelic.obfuscate_tokens(tokens)

    tokens = tokens_for(
      {:similar => true, :qualifiers => [:bla]},
      {:partial => true, :qualifiers => [:blub, :bla]}
    )
    assert_equal 'bla,blub:xxx* bla:xxx~', Picky::NewRelic.obfuscate_tokens(tokens)
  end
end
