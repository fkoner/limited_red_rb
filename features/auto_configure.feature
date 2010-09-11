Feature: Auto Configure
  In order to save precious seconds of my life
  I want cukepatch to just work out the box without config
  
  @interactive
  Scenario: no config
    Given a Cucumber project "build" has a failing feature called "fickle.feature"
    And a file named "features/support/env.rb" with:
    """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'cukepatch/plugin'
    """
    When I run "cucumber features" in "build"
    Then "features/fickle.feature" should be run first