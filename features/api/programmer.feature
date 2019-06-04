Feature: Programmer
  In order to battle projects
  As an API client
  I need to be able to create programmers and power them up

Background:
  Given the user "weaverryan" exists
  And "weaverryan" has an authentication token "ABCD123"
  And I set the "Authorization" header to be "token ABCD123"

#Main Scenario
Scenario: Error response on invalid JSON
  # the rest of the scenario	
  Scenario: Validation errors
  # all the current scenario lines
  Scenario: Create a programmer
	  Given I have the payload:
	    """
	    {
	      "nickname": "ObjectOrienter",
	      "avatarNumber" : "2",
	      "tagLine": "I'm from a test!"
	    }
	    """
	  When I request "POST /api/programmers"
	  Then the response status code should be 201
	  And the "Location" header should be "/api/programmers/ObjectOrienter"
	  And the "nickname" property should equal "ObjectOrienter"

	Scenario: GET one programmer
	  Given the following programmers exist:
	    | nickname   | avatarNumber |
	    | UnitTester | 3            |
	  When I request "GET /api/programmers/UnitTester"
	  Then the response status code should be 200
	  And the following properties should exist:
	    """
	    nickname
	    avatarNumber
	    powerLevel
	    tagLine
	    """
	  And the "nickname" property should equal "UnitTester"
	  And the "userId" property should not exist
	  And the link "self" should exist and its value should be "/api/programmers/UnitTester"
	  And print last response
	Scenario: GET a collection of programmers
	  Given the following programmers exist:
	    | nickname    | avatarNumber |
	    | UnitTester  | 3            |
	    | CowboyCoder | 5            |
	  When I request "GET /api/programmers"
	  Then the response status code should be 200
	  And the "_embedded.items" property should be an array
      And the "_embedded.items" property should contain 2 items
      And the "_embedded.items.0.nickname" property should equal "UnitTester"
      #And the "_embedded.programmers" property should be an array
      #And the "_embedded.programmers" property should contain 2 items
      #And the "_embedded.programmers.0.nickname" property should equal "UnitTester"
    Scenario: GET a collection of battles for a programmer
    Given there is a project called "projectA"
    Given there is a project called "projectB"
    And there is a programmer called "Fred"
    And there has been a battle between "Fred" and "projectA"
    And there has been a battle between "Fred" and "projectB"
    When I request "GET /api/programmers/Fred/battles"
    Then the response status code should be 200
    And the "_embedded.items" property should be an array
    And the "_embedded.items" property should contain 2 items
    And the "_embedded.items.0.didProgrammerWin" property should exist
    #And the "_embedded.battles" property should be an array
    #And the "_embedded.battles" property should contain 2 items
    #And the "_embedded.battles.0.didProgrammerWin" property should exist  
	
	Scenario: PUT to update a programmer
	  Given the following programmers exist:
	    | nickname    | avatarNumber | tagLine |
	    | CowboyCoder | 5            | foo     |
	  And I have the payload:
	    """
	    {
	      "nickname": "CowgirlCoder",
	      "avatarNumber" : 2,
	      "tagLine": "foo"
	    }
	    """
	  When I request "PUT /api/programmers/CowboyCoder"
	  # And print last response
	  Then the response status code should be 200
	  And the "avatarNumber" property should equal "2"
	  But the "nickname" property should equal "CowboyCoder"

  	Scenario: DELETE a programmer
	  Given the following programmers exist:
	    | nickname   | avatarNumber |
	    | UnitTester | 3            |
	  When I request "DELETE /api/programmers/UnitTester"
	  Then the response status code should be 204

	Scenario: PATCH to update a programmer
	  Given the following programmers exist:
	    | nickname    | avatarNumber | tagLine |
	    | CowboyCoder | 5            | foo     |
	  And I have the payload:
	    """
	    {
	      "tagLine": "giddyup"
	    }
	    """
	  When I request "PATCH /api/programmers/CowboyCoder"
	  Then the response status code should be 200
	  And the "avatarNumber" property should equal "5"
	  And the "tagLine" property should equal "giddyup"

	Scenario: Validation errors
	  Given I have the payload:
	    """
	    {
	      "avatarNumber" : "2",
	      "tagLine": "I'm from a test!"
	    }
	    """
	  When I request "POST /api/programmers"
	  Then the response status code should be 400
	  And the following properties should exist:
	    """
	    type
	    title
	    errors
	    """
	  And the "errors.nickname" property should exist
	  But the "errors.avatarNumber" property should not exist
Scenario: Error response on invalid JSON
	  Given I have the payload:
	    """
	    {
	      "avatarNumber" : "2
	      "tagLine": "I'm from a test!"
	    }
	    """
	  When I request "POST /api/programmers"
	  Then the response status code should be 400
	  # And print last response

#Main Scenario
And the "Content-Type" header should be "application/problem+json"
And the "type" property should contain "/api/docs/errors#invalid_body_format"

Scenario: Proper 404 exception on no programmer
  When I request "GET /api/programmers/fake"
  Then the response status code should be 404
  And the "Content-Type" header should be "application/problem+json"
  And the "type" property should equal "about:blank"
  And the "title" property should equal "Not Found"
  And the "detail" property should equal "The programmer fake does not exist!"
