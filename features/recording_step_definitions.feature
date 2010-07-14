Feature: Recording step definitions
  In order have autocompletion support in external tools
  As a cukepatch user
  I want step regular expression to be uploaded to cuke-max

  Background:
    Given a standard Cucumber project directory structure
    And a file named "cukepatch.yml" with:
    """
      host: localhost
      port: 9292
      id:   cuke_internal_tests
    """

  @wip
  Scenario: Single feature
    Given a file named "features/example.feature" with:
    """
      Feature: Example
        Scenario: Higdegger
         Given boozey
         And beggar
         And table
    """
    And a file named "features/step_definitions/steps.rb" with:
    """
      Given /^boozey$/ do
      end
      
      Given /^beggar$/ do
      end
      
      Given /^table$/ do
      end
      
      Given /^step which is not in the feature$/ do
      end
    """
    And I have run "cukepatch features"
    When I go to http://localhost:9292/projects/cuke_internal_tests/step_regexps
    Then I should see JSON:
    """
    {
      "step_regexps":[
        /^boozey$/,
        /^beggar$/,
        /^table$/,
        /^step which is not in the feature$/
      ]
    }
    """