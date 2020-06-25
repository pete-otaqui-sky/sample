Feature: Homepage

Scenario: Visit
  Given I am on the Homepage
  When I search for "foo"
  Then I should see "foo"
