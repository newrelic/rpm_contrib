require 'resque'
require 'mocha'
require File.expand_path(File.dirname(__FILE__) + "/helper")
require File.expand_path(File.dirname(__FILE__) + "/../lib/rpm_contrib")

class ResqueTest < Test::Unit::TestCase
  class ExtendoJorb < ::Resque::Job
    def self.perform
      true
    end
  end
  
  class GoodJorb
    def self.perform
      true
    end
  end

  class BadJorb
    def self.perform
      raise "I'm doing a bad jorb"
    end
  end

  def setup
    @worker = Resque::Worker.new(:test)
    NewRelic::Agent.manual_start
    @engine = NewRelic::Agent.instance.stats_engine
  end

  def teardown
    @engine.clear_stats
  end
  
  def test_should_instrument_job_extending_from_resque_job
    @worker.perform(Resque::Job.new(:test,
                                    'class' => 'ResqueTest::ExtendoJorb'))

    metrics = [ 'OtherTransaction/all', 'OtherTransaction/ResqueJob/all',
                'OtherTransaction/ResqueJob/ResqueTest::ExtendoJorb/perform' ]
    metrics.each do |metric|
      assert(@engine.metrics.include?(metric),
             "#{@engine.metrics.inspect} missing #{metric}")
    end
    assert !@engine.metrics.include?('Errors/all')
  end

  def test_should_instrument_poro_job
    @worker.perform(Resque::Job.new(:test, 'class' => 'ResqueTest::GoodJorb'))

    metrics = [ 'OtherTransaction/all', 'OtherTransaction/ResqueJob/all',
                'OtherTransaction/ResqueJob/ResqueTest::GoodJorb/perform' ]
    metrics.each do |metric|
      assert(@engine.metrics.include?(metric),
             "#{@engine.metrics.inspect} missing #{metric}")
    end
    assert !@engine.metrics.include?('Errors/all')
  end

  def test_should_collect_job_errors
    begin
      @worker.perform(Resque::Job.new(:test, 'class' => 'ResqueTest::BadJorb'))
    rescue
    end
    
    metrics = [ 'OtherTransaction/all', 'OtherTransaction/ResqueJob/all',
                'OtherTransaction/ResqueJob/ResqueTest::BadJorb/perform',
                'Errors/all' ]
    metrics.each do |metric|
      assert(@engine.metrics.include?(metric),
             "#{@engine.metrics.inspect} missing #{metric}")
    end      
  end
end
