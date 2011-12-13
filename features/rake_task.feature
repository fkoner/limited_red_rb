Feature: Rake task
  In order to ease the development process
  As a developer and CI server administrator
  limited-red should be executable via Rake
  
  Background:
    Given a standard Cucumber project directory structure
    And a file named "limited_red.yml" with:
      """
        host: localhost
        port: 9292
        project name: cuke_internal_tests
        username: josephwilk
        api key: 123
      """

  Scenario: One failing scenario
    Given a feature named "features/fickle.feature" which always fails
    And a feature named "features/awesome.feature" which always passes
    And a file named "Rakefile" with:
      """
      require 'cucumber/rake/task'
      Cucumber::Rake::Task.new do |t|
        t.cucumber_opts = "features"
      end
      """
    And a file named "features/support/env.rb" with:
    """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'limited_red/plugin'
    """
    And I have run rake cucumber
    When I run rake cucumber
    Then "features/fickle.feature" should be run first
