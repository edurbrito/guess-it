Feature: Leaderboard Page

  Scenario: Viewing the Leaderboard Page
    Given I am in the "LandingPage"
    When I tap the "leaderboard-button" button
    Then I am in the "LeaderboardPage"