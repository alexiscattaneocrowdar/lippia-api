@Clockify
Feature: Clockify API

  Background:
    And header Content-Type = application/json
    And header Accept = */*
    And header X-Auth-Token = $(env.X_Auth_Token)
    Given base url $(env.base_url)

  Scenario: Add project
    And endpoint v1/workspaces/$(env.workspaceId)/projects
    And set value Project from lippia lowcode6 of key name in body jsons/bodies/addProjectClockify.json
    When execute method POST
    Then the status code should be 201
    And response should be $.name = Project from lippia lowcode6
    And response should be $.workspaceId = $(env.workspaceId)

  Scenario: Get project
    #And endpoint v1/workspaces/$(env.workspaceId)/projects/$(env.projectId)
    And endpoint v1/workspaces/$(env.workspaceId)/projects/66da097579f4151de6c3b422
    When execute method GET
    Then the status code should be 200
    And response should be $.workspaceId = $(env.workspaceId)

  Scenario: Edit name project
    And endpoint v1/workspaces/$(env.workspaceId)/projects/66da097579f4151de6c3b422
    And set value Project from lippia lowcode PUT of key name in body jsons/bodies/addProjectClockify.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.name = Project from lippia lowcode PUT
    And response should be $.workspaceId = $(env.workspaceId)

  Scenario: Get all projects
    And endpoint v1/workspaces/$(env.workspaceId)/projects
    When execute method GET
    Then the status code should be 200

  Scenario: Filter projects by name
    And endpoint v1/workspaces/$(env.workspaceId)/projects?name=Software
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with "Software Development" in the name

  Scenario: Strict search by project name
    And endpoint v1/workspaces/$(env.workspaceId)/projects?name=Software&strict-name-search=true
    When execute method GET
    Then the status code should be 200
    #And the response should only contain projects named "Software Development"

  Scenario: Filter projects by archived status
    And endpoint v1/workspaces/$(env.workspaceId)/projects?archived=true
    When execute method GET
    Then the status code should be 200
    #And the response should contain only archived projects

  Scenario: Filter projects by specific clients
    And endpoint v1/workspaces/$(env.workspaceId)/projects?clients=5a0ab5acb07987125438b60f&clients=64c777ddd3fcab07cfbb210c
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with at least one of the specified client IDs

  Scenario: Filter projects by specific users
    And endpoint v1/workspaces/$(env.workspaceId)/projects?users=5a0ab5acb07987125438b60f&users=64c777ddd3fcab07cfbb210c
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with at least one of the specified user IDs

  Scenario: Filter projects by client status
    And endpoint v1/workspaces/$(env.workspaceId)/projects?client-status=ACTIVE
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with active clients

  Scenario: Sort projects by name in ascending order
    And endpoint v1/workspaces/$(env.workspaceId)/projects?sort-column=NAME&sort-order=ASCENDING
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects sorted by name in ascending order

  Scenario: Test pagination with page number and page size
    And endpoint v1/workspaces/$(env.workspaceId)/projects?page=1&page-size=50
    When execute method GET
    Then the status code should be 200
    #And the response should contain a maximum of 50 projects on the first page

  Scenario: Get public projects
    And endpoint v1/workspaces/$(env.workspaceId)/projects?access=PUBLIC
    When execute method GET
    Then the status code should be 200
    #And the response should contain only public projects

  Scenario: Unauthorized access to projects
    And header X-Auth-Token = invalidToken
    And endpoint v1/workspaces/$(env.workspaceId)/projects
    When execute method GET
    Then the status code should be 401

  Scenario: Project not found
    And endpoint v1/workspaces/$(env.workspaceId)/projects?name=NonExistentProjectName
    When execute method GET
    Then the status code should be 404

  Scenario: Bad request due to invalid parameters
    And endpoint v1/workspaces/$(env.workspaceId)/projects?invalidParameter=invalidValue
    When execute method GET
    Then the status code should be 400
