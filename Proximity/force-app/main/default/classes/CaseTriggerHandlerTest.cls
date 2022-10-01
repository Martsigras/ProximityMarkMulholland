@isTest
private class CaseTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Case_Triggers__c settings = Case_Triggers__c.getOrgDefaults();
        settings.Create_Task_for_new_Case__c = true;
        upsert settings;

        Account newAccount = new Account(Name = 'Martsigras Inc');
        insert newAccount;

        Contact newContact = new Contact(LastName = 'Mulholland', AccountId = newAccount.Id);
        insert newContact;
    }

    @isTest
    private static void createTask_success_oneWeek() {
        // Arrange
        Contact thisContact = [SELECT Id FROM Contact LIMIT 1];
        Case newCase = new Case(ContactId = thisContact.Id, Priority = 'High');

        // Act
        insert newCase;

        // Assert
        List<Task> tasks = [SELECT Id, ActivityDate FROM Task];
        System.assertEquals(1, tasks.size(), 'There should have been 1 Task created');
        System.assertEquals(Date.Today().addDays(7), tasks[0].ActivityDate, 'The Tasks Due Date should be in 7 days');
    }

    @isTest
    private static void createTask_success_twoWeeks() {
        // Arrange
        Contact thisContact = [SELECT Id FROM Contact LIMIT 1];
        Case newCase = new Case(ContactId = thisContact.Id, Priority = 'Medium');

        // Act
        insert newCase;

        // Assert
        List<Task> tasks = [SELECT Id, ActivityDate FROM Task];
        System.assertEquals(1, tasks.size(), 'There should have been 1 Task created');
        System.assertEquals(Date.Today().addDays(14), tasks[0].ActivityDate, 'The Tasks Due Date should be in 7 days');
    }

    @isTest
    private static void createTask_success_threeWeeks() {
        // Arrange
        Contact thisContact = [SELECT Id FROM Contact LIMIT 1];
        Case newCase = new Case(ContactId = thisContact.Id, Priority = 'Low');

        // Act
        insert newCase;

        // Assert
        List<Task> tasks = [SELECT Id, ActivityDate FROM Task];
        System.assertEquals(1, tasks.size(), 'There should have been 1 Task created');
        System.assertEquals(Date.Today().addDays(21), tasks[0].ActivityDate, 'The Tasks Due Date should be in 7 days');
    }

    @isTest
    private static void createCase_multipleSuccesses() {
        // Arrange
        Contact thisContact = [SELECT Id FROM Contact LIMIT 1];
        List<Case> cases = new List<Case>();
        for ( integer x = 0; x < 100; x++ ) {
            Case newCase = new Case(Priority = 'High');
            cases.add(newCase);
        }

        // Act
        insert cases;

        // Assert
        List<Task> tasks = [SELECT Id, ActivityDate FROM Task];
        System.assertEquals(100, tasks.size(), 'There should have been 100 Tasks created');
        System.assertEquals(Date.Today().addDays(7), tasks[0].ActivityDate, 'The Tasks Due Date should be in 7 days');
    }
}
