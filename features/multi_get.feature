@wip
Feature: getting N largest sequences
  As a client
  I should be able to read N largest uploaded sequences

  Scenario:
    Given a sequence server with a following configuration:
    """
      [{max_sequences, 5}].
    """
    When I post string "5" as "text/plain" to "/put"
    And I post string "4" as "text/plain" to "/put"
    And I post string "3" as "text/plain" to "/put"
    And I post string "2" as "text/plain" to "/put"
    And I post string "1" as "text/plain" to "/put"
    And I send a GET request to "/get"
    Then response body should look like the following:
    """
    [[1],[2],[3],[4],[5]]
    """

