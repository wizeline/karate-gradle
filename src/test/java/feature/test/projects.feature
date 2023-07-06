@projects
Feature: Projects
    Background:
        * url baseURL

    @getAllProjects @gettingStarted @readExternalFile @fuzzyMatching
    Scenario: Get projects
        * def expectedResponseSchema = read('classpath:feature/test/data/getAllProjects.yaml')
        Given path projects
        When method get
        Then status 200
        And match response contains only deep expectedResponseSchema.mainStructure

    @createNewProject @outlineScenario
    Scenario Outline: Create new project
        * def newProjectBody =
        """
        {
          "name": "<name>",
          "color": "<color>",
        }
        """
        Given path projects
        And request newProjectBody
        When method post
        Then status 200
        And match response.name == "<name>"
    Examples:
        | name           | color     |
        | Test Project 1 | berry_red |
        | Test Project 2 | red       |
        | Test Project 3 | orange    |
        | Test Project 4 | yellow    |

    @projectDetails @usingJSF
    Scenario: Get existing project details
        * def getAllProjects = call read('classpath:feature/test/projects.feature@getAllProjects')
        * def projectId = getAllProjects.response.find(project => project['name'] == 'Test Project 1').id
        * karate.log(projectId)
        Given path projects, projectId
        When method get
        Then status 200
        And karate.log(karate.pretty(response))

    @updateProjectName @usingJSF
    Scenario: Update an existing project name
        * def oldProjectName = "Test Project 1"
        * def projectName = "Updated Test Project"
        * def projectColor = "lime_green"
        * def getAllProjects = call read('classpath:feature/test/projects.feature@getAllProjects')
        * def projectId = getAllProjects.response.find(project => project['name'] == oldProjectName).id
        * def updateProjectBody =
        """
        {
            "name": "#(projectName)",
            "color": "#(projectColor)",
            "is_favorite": true
        }
        """
        Given path projects, projectId
        And request updateProjectBody
        When method post
        Then status 200
        And match response.name != oldProjectName
        * karate.log(karate.pretty(response))

    @deleteExistingProject @ignore @outlineScenario @usingJSF
    Scenario: Delete an existing project process
       * def getAllProjects = call read('classpath:feature/test/projects.feature@getAllProjects')
       * def projectId = getAllProjects.response.find(project => project['name'] == name).id
       * karate.log(projectId)
       Given path projects, projectId
       When method delete
       Then status 204

    @deleteProjectsUsingTable @@outlineScenario @regression
    Scenario: Delete all projects
        * table projectsToBeDeleted
            | name!                  |
            | "Updated Test Project" |
            | "Test Project 2"       |
            | "Test Project 3"       |
            | "Test Project 4"       |
        * def deleteProjects  = call read('classpath:feature/test/projects.feature@deleteExistingProject') projectsToBeDeleted
