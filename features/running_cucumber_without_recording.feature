Feature: Running cucumber without recording
  In order experiment without recording data
  As a Limited Red user
  I want control over whether a cucumber run will record stats
  
  Background:
    Given a standard Cucumber project directory structure
    And a file named ".limited_red" with:
    """
      host: localhost
      port: 9292
      project name: cuke_internal_tests
      username: josephwilk
      api key: 123
    """
    And a file named "features/support/env.rb" with:
    """
    $LOAD_PATH.unshift(CUCUMBER_LIB)
    require 'limited_red/plugins/cucumber'
    """
  
  Scenario: Turning off
    Given a feature named "features/fickle.feature" which always fails
    And a feature named "features/awesome.feature" which always passes
    And I have run "cucumber features"
    When I run "cucumber features"
    Then "features/awesome.feature" should be run first