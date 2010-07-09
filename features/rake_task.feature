Feature: Rake task
  In order to ease the development process
  As a developer and CI server administrator
  CukePatch should be executable via Rake
  
  Background:
    Given a standard Cucumber project directory structure
    And a file named "cukepatch.yml" with:
      """
        host: localhost
        port: 9292
        id:   cuke_internal_tests
      """

  Scenario: One failing scenario
    Given a feature named "features/fickle.feature" which always fails
    And a feature named "features/awesome.feature" which always passes
    And a file named "Rakefile" with:
      """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'cukepatch/rake/task'

      CukePatch::Rake::Task.new do |t|
        t.cucumber_opts = "features"
      end
      """
    And a file named "features/support/env.rb" with:
    """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'cukepatch'
    """
    And I have run rake cukepatch
    When I run rake cukepatch
    Then "features/fickle.feature" should be run first
