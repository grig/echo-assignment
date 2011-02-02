Feature: putting a number
  As a generator
  I want to be able to post a generated number to the server

  Background:
    Given a running sequence server

  Scenario Outline: /put examples
    When I post string "<input>" as "<content_type>" to "/put"
    Then I should receive HTTP status line "<status>"

  Examples:
    | input | content_type    | status          |
    | 1     | text/plain      | 204 No Content  |
    | 1     | application/foo | 400 Bad Request |
    | foo   | text/plain      | 400 Bad Request |

  Scenario: requesting a non-supported URL
    When I post string "1" as "text/plain" to "/put/1234"
    Then I should receive HTTP status line "404 Not Found"

