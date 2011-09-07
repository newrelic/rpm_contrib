require "#{File.dirname(__FILE__)}/helper"
begin
require 'curb' 
rescue LoadError
end

class NewRelic::Agent::NetInstrumentationTest < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  def setup
    NewRelic::Agent.manual_start
    @engine = NewRelic::Agent.instance.stats_engine
    @engine.clear_stats
  end
  def test_get
    curl = Curl::Easy.new('http://www.google.com/index.html')
    curl.perform
    assert_match /<head>/, curl.body_str
    assert_equal %w[External/www.google.com/Curl::Easy External/Curl::Multi
                    External/allOther External/www.google.com/all].sort,
       @engine.metrics.sort
  end

  def test_multi
    multi = Curl::Multi.new
    curl1 = Curl::Easy.new('http://www.google.com/index.html')
    multi.add curl1
    curl2 = Curl::Easy.new('http://www.yahoo.com/')
    multi.add curl2
    multi.perform
    assert_match /<head>/, curl1.body_str
    assert_match /<head>/, curl2.body_str
    assert_equal %w[External/Curl::Multi External/allOther].sort,
       @engine.metrics.sort
  end

  def test_background
    perform_action_with_newrelic_trace("task", :category => :task) do
      curl = Curl::Easy.new('http://www.google.com/index.html')
      curl.perform
      assert_match /<head>/, curl.body_str
    end
    assert_equal %w[External/Curl::Multi
          External/Curl::Multi:OtherTransaction/Background/NewRelic::Agent::NetInstrumentationTest/task
          External/www.google.com/Curl::Easy External/allOther External/www.google.com/all
          External/www.google.com/Curl::Easy:OtherTransaction/Background/NewRelic::Agent::NetInstrumentationTest/task].sort,
       @engine.metrics.select{|m| m =~ /^External/}.sort
  end

  def test_transactional
    perform_action_with_newrelic_trace("task") do
      curl = Curl::Easy.new('http://www.google.com/index.html')
      curl.perform
      assert_match /<head>/, curl.body_str
    end
    assert_equal %w[External/Curl::Multi
          External/Curl::Multi:Controller/NewRelic::Agent::NetInstrumentationTest/task
          External/www.google.com/Curl::Easy External/allWeb External/www.google.com/all
          External/www.google.com/Curl::Easy:Controller/NewRelic::Agent::NetInstrumentationTest/task].sort,
       @engine.metrics.select{|m| m =~ /^External/}.sort
  end
  def test_ignore
    NewRelic::Agent.disable_all_tracing do
      curl = Curl::Easy.new('http://www.google.com/index.html')
      curl.http_post('data')
    end
    assert_equal 0, @engine.metrics.size
  end

end if defined? ::Curl::Easy
