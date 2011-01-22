Feature: putting a number
  As a generator
  I want to be able to post a generated number to the server

  Scenario:
    When I post number "1" as "text/plain"
    Then I should receive HTTP status line "204 No Content"

