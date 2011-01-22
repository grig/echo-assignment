Feature: putting a number
  As a generator
  I want to be able to post a generated number to the server

  Scenario: putting a generated number
    When I post number "1" as "text/plain" to "/put"
    Then I should receive HTTP status line "204 No Content"

  Scenario: requesting a non-supported URL
    When I post number "1" as "text/plain" to "/put/1234"
    Then I should receive HTTP status line "404 Not Found"
