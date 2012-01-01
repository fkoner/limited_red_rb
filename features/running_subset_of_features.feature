Feature: Running subset of features
  In order to use cucumber normally
  As a Limited Red user
  I want to limit cucumber to run a subset of features

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

  Scenario: Running single feature
    Given a feature named "features/fickle.feature" which always fails
    And a feature named "features/awesome.feature" which always passes
    And I have run "cucumber features"
    When I run "cucumber features/awesome.feature"
    Then "features/fickle.feature" should not be run
    And "features/awesome.feature" should be run
