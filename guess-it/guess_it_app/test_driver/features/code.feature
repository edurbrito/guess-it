Feature: Inserting the Admin Code

  Scenario: Inserting the admin code
    Given I am in the "LandingPage"
    When I tap the "admin-button"
    Then I am in the "AdminCode"
    And I insert the correct admin code
    When I tap the "login-button"
    Then I am in the "AdminPanel"