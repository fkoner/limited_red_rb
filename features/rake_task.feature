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
        username: poobear
        api key: 88dd7a152bf342b6b64bcc54813ec735
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
      require 'cukemax/plugin'
    """
    And I have run rake cucumber
    When I run rake cucumber
    Then STDERR should be empty
    Then "features/fickle.feature" should be run first
