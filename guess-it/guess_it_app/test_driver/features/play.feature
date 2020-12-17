Feature: Playing the game

  Scenario: Entering the Game Page
    Given I am in the "LandingPage"
    When I tap the "play-button"
    Then I am in the "PlayerPage"
    And I insert a nickname
    When I tap the "ready-button"
    Then I am in the "GamePage"