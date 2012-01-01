Feature: Rspec

  Background:
    Given a standard Rspec project directory structure
    And a file named ".limited_red" with:
    """
      host: localhost
      port: 9292
      project name: cuke_internal_tests
      username: josephwilk
      api key: 123
    """
    And a file named "spec/spec_helper.rb" with:
    """
    	require 'limited_red/plugins/rspec'
    """

  Scenario: Frequent failing feature
    Given a spec named "spec/fickle_spec.rb" which always fails
    And a spec named "spec/awesome_spec.rb" which always passes
    And I have run "rspec spec"
    When I run "rspec spec"
    Then "spec/fickle_spec.rb" should be run first