Feature: getting a single sequences
  As a client
  I want to be able to read largest uploaded sequence

  Background:
    Given a running sequence server

  Scenario: empty get request
    When I send a GET request to "/get"
    Then I should receive HTTP status line "200 OK"

  Scenario: get with a previous put
    Given I post string "1" as "text/plain" to "/put"
    When I send a GET request to "/get"
    Then response body should look like the following:
      """
      [[1]]
      """

  Scenario: get with a previous multiple puts
    Given I post string "1" as "text/plain" to "/put"
    Given I post string "2" as "text/plain" to "/put"
    When I send a GET request to "/get"
    Then response body should look like the following:
      """
      [[1,2]]
      """

  Scenario: get with a previous multiple puts
    Given I post string "2" as "text/plain" to "/put"
    Given I post string "1" as "text/plain" to "/put"
    Given I post string "3" as "text/plain" to "/put"
    When I send a GET request to "/get"
    Then response body should look like the following:
      """
      [[1,3]]
      """

	Scenario: numbers in ASCII printable range
    Given I post string "49" as "text/plain" to "/put"
    Given I post string "50" as "text/plain" to "/put"
    Given I post string "51" as "text/plain" to "/put"
    When I send a GET request to "/get"
    Then response body should look like the following:
      """
      [[49,50,51]]
      """
