@Clockify
Feature: Clockify API

  Background:
    And header Content-Type = application/json
    And header Accept = */*
    And header X-Auth-Token = $(env.X_Auth_Token)
    Given base url $(env.base_url)

  @GetAllWorkspaces
  Scenario: Get all workspaces
    And endpoint v1/workspaces
    When execute method GET
    Then the status code should be 200
    * define idWorkspace = $[1].id

  @GetAllProjects
  Scenario: Get all projects
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects
    When execute method GET
    Then the status code should be 200
    * define idProject = $[0].id

  @GetProject
  Scenario: Get project
    Given call Clockify.feature@GetAllProjects
    And endpoint v1/workspaces/{{idWorkspace}}/projects/{{idProject}}
    When execute method GET
    Then the status code should be 200
    And response should be $.workspaceId = {{idWorkspace}}

  @AddProject
  Scenario: Add project
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects
    And set unique value of key name in body jsons/bodies/addProjectClockify.json
    When execute method POST
    Then the status code should be 201
    And response $.name should be the unique value
    And response should be $.workspaceId = {{idWorkspace}}

  @EditNameProject
  Scenario: Edit name project
    Given call Clockify.feature@GetAllProjects
    And endpoint v1/workspaces/{{idWorkspace}}/projects/{{idProject}}
    And set value Project from lippia lowcode PUT of key name in body jsons/bodies/addProjectClockify.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.name = Project from lippia lowcode PUT
    And response should be $.workspaceId = {{idWorkspace}}

  @FilterProjectsByName
  Scenario: Filter projects by name
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?name=Software
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with "Software Development" in the name

  @StrictSearchByProjectName
  Scenario: Strict search by project name
    And endpoint v1/workspaces/{{idWorkspace}}/projects?name=Software&strict-name-search=true
    When execute method GET
    Then the status code should be 200
    #And the response should only contain projects named "Software Development"

  @FilterProjectsByArchivedStatus
  Scenario: Filter projects by archived status
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?archived=true
    When execute method GET
    Then the status code should be 200
    #And the response should contain only archived projects

  @FilterProjectsBySpecificClients
  Scenario: Filter projects by specific clients
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?clients=5a0ab5acb07987125438b60f&clients=64c777ddd3fcab07cfbb210c
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with at least one of the specified client IDs

  @FilterProjectsBySpecificUsers
  Scenario: Filter projects by specific users
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?users=5a0ab5acb07987125438b60f&users=64c777ddd3fcab07cfbb210c
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with at least one of the specified user IDs

  @FilterProjectsByClientStatus
  Scenario: Filter projects by client status
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?client-status=ACTIVE
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects with active clients

  @SortProjectsByNameInAscendingOrder
  Scenario: Sort projects by name in ascending order
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?sort-column=NAME&sort-order=ASCENDING
    When execute method GET
    Then the status code should be 200
    #And the response should contain projects sorted by name in ascending order

  @TestPaginationWithPageNumberAndPageSize
  Scenario: Test pagination with page number and page size
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?page=1&page-size=50
    When execute method GET
    Then the status code should be 200
    #And the response should contain a maximum of 50 projects on the first page

  @GetPublicProjects
  Scenario: Get public projects
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?access=PUBLIC
    When execute method GET
    Then the status code should be 200
    #And the response should contain only public projects

  @UnauthorizedAccessToProjects
  Scenario: Unauthorized access to projects
    And header X-Auth-Token = invalidToken
    And endpoint v1/workspaces/{{idWorkspace}}/projects
    When execute method GET
    Then the status code should be 401

  @ProjectNotFound
  Scenario: Project not found
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?name=NonExistentProjectName
    When execute method GET
    Then the status code should be 404

  @BadRequestDueToInvalidParameters
  Scenario: Bad request due to invalid parameters
    Given call Clockify.feature@GetAllWorkspaces
    And endpoint v1/workspaces/{{idWorkspace}}/projects?invalidParameter=invalidValue
    When execute method GET
    Then the status code should be 400
