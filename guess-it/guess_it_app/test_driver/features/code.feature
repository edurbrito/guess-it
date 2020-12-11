Feature: Inserting the Admin Code

  Scenario: Inserting the admin code
    Given I am in the "AdminCode"
    And I insert the correct admin code
    When I tap the "Log In" button
    Then I am in the "AdminPanel"