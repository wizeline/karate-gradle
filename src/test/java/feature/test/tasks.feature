@tasks
Feature: Tasks

  Background:
    * url baseURL
    * def randomData = Java.type('feature.util.RandomDataGenerator')
    * def dateTimeUtil =  Java.type('feature.util.DateTimeTool')

  @createNewTasks @outlineScenario
  Scenario Outline: Create a new task using human defined due date
    * def randomDescription = randomData.randomContent()
    * def newTaskBody =
    """
    {
      "content": "<taskName>",
      "description": "#(randomDescription)",
      "due_string": "<dueDate>",
      "priority": "<priority>"
    }
    """
    * karate.log(newTaskBody)
    Given path tasks
    And request newTaskBody
    When method post
    Then status 200
    * karate.log(response)
  Examples:
    | taskName | dueDate        | priority  |
    | Task 1   | next Monday    | 1         |
    | Task 2   | tomorrow       | 3         |
    | Task 3   | tomorrow at 12 | 4         |
    | Task 4   | next week      | 4         |

  @getTasks @fuzzyMatching
  Scenario: Get active tasks
    * def expectedResponseSchema = read('classpath:feature/test/data/getAllTasks.yaml')
    Given path tasks
    When method get
    Then status 200
    And match response contains only deep expectedResponseSchema.mainStructure

  @deleteTasks @callFeature
  Scenario Outline: Delete all created tasks
    * def getAllTasks = call read('classpath:feature/test/tasks.feature@getTasks')
    * def taskId = getAllTasks.response.find(task => task['content'] == "<taskName>").id
    Given path tasks, taskId
    When method delete
    Then status 204
  Examples:
    | taskName |
    | Task 1   |
    | Task 2   |
    | Task 3   |
    | Task 4   |
