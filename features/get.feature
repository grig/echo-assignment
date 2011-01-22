Feature: getting lists of sequences
  As a client
  I want to be able to read uploaded sequences

  Scenario:
    When I send a GET request to "/get"
    Then I should receive HTTP status line "200 OK"
