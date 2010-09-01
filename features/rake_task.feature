Feature: Rake task
  In order to ease the development process
  As a developer and CI server administrator
  CukeMax should be executable via Rake
  
  Background:
    Given a standard Cucumber project directory structure
    And a file named "cukemax.yml" with:
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
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'cukemax/rake/task'

      CukeMax::Rake::Task.new do |t|
        t.cucumber_opts = "features"
      end
      """
    And a file named "features/support/env.rb" with:
    """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'cukemax'
    """
    And I have run rake cukemax
    When I run rake cukemax
    Then "features/fickle.feature" should be run first
