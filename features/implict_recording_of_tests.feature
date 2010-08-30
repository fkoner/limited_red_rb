Feature: Implicit recording of test results
  In order to use the tools I'm familiar with
  I want to call cucumber as I normally would but it records stats
  
  Background:
    Given a standard Cucumber project directory structure
    And a file named "cukepatch.yml" with:
      """
        project name:   cuke_internal_tests
        username: josephwilk
        api key: 123
        host: localhost
        port: 9292
      """

  @wip
  Scenario: One failing scenario
    Given a feature named "features/fickle.feature" which always fails
    And a feature named "features/awesome.feature" which always passes
    And a file named "features/support/env.rb" with:
    """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'cukepatch'
    """
    And I run cucumber features
    When I run "cukepatch features"
    Then "features/fickle.feature" should be run first
