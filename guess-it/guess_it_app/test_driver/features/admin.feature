Feature: Entering as an Admin

  Scenario: Entering as an admin
    Given I am in the "LandingPage"
    When I tap the "admin-button" button
    Then I am in the "AdminCode"