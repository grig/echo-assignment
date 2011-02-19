Feature: getting N largest sequences
  As a client
  I should be able to read N largest uploaded sequences

  Scenario:
    Given a sequence server with a following configuration:
    """
      [{max_sequences, 5}].
    """
    When I put a following sequence:
    """
    [5,4,3,2,1]
    """
    And I send a GET request to "/get"
    Then response body should look like the following:
    """
    [[1],[2],[3],[4],[5]]
    """
