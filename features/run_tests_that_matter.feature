Feature: Run features prioritising the most likely to fail
  In order to have the fastest possible test feedback on fails
  As a developer
  I want feature execution to be ordered by those that are most likely to fail

  Background:
    Given a standard Cucumber project directory structure
    And a file named "cukepatch.yml" with:
    """
      host: localhost
      port: 9292
      project name: cuke_internal_tests
      username: josephwilk
      api key: 123
    """

  Scenario: Frequent failing feature
    Given a feature named "features/fickle.feature" which always fails
    And a feature named "features/awesome.feature" which always passes
    And I have run "cukepatch features"
    When I run "cukepatch features"
    Then "features/fickle.feature" should be run first

  Scenario: Previous fail takes precedent over older fail
    Given a feature named "features/a.feature" which fails
    And a feature named "features/b.feature" which passes
    And I have run "cukepatch features"
    And the feature "features/a.feature" is fixed
    And the feature "features/b.feature" is broken
    And I have run "cukepatch features"
    When I run "cukepatch features"
    Then "features/b.feature" should be run first
        
  Scenario: Failure which has been deleted
    Given a feature named "features/a.feature" which fails
    And I have run "cukepatch features"
    And the feature "features/a.feature" is deleted
    When I run "cukepatch features"
    Then "features/a.feature" should not be run
    
