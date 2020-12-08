Feature: Nova

  Scenario: Entering as an admin
    Given I am in the "LandingPanel"
    When I tap the "Enter as Admin" button
    Then I am in the "AdminCode"