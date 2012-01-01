Feature: Multiple projects
  In order to have multiple intelligent builds
  I want limited-red to work across multiple projects

  Scenario: two different cucumber projects
    Given a Cucumber project "build_1" has a failing feature called "antifickle.feature"
    And a file named "build_1/.limited_red" with:
    """
      project name:   build_1
      username: josephwilk
      api key: 123
      host: localhost
      port: 9292
    """
    And a file named "build_1/features/support/env.rb" with:
    """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'limited_red/plugins/cucumber'
    """
    And a Cucumber project "build_2" has a failing feature called "fickle.feature"
    And a file named "build_2/.limited_red" with:
    """
      project name:   build_2
      username: josephwilk
      api key: 123
      host: localhost
      port: 9292
    """
    And a file named "build_2/features/support/env.rb" with:
    """
      $LOAD_PATH.unshift(CUCUMBER_LIB)
      require 'limited_red/plugins/cucumber'
    """ 
    And I have run "cucumber features" 1 time in "build_1"
    And I have run "cucumber features" 1 time in "build_2"
    When I run "cucumber features" in "build_2"
    Then "features/fickle.feature" should be run first
    
    
    
    
    
