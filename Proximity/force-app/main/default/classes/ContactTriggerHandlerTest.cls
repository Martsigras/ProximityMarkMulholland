@isTest
private class ContactTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Contact_Triggers__c settings = Contact_Triggers__c.getOrgDefaults();
        settings.Create_Case_for_new_Contact__c = true;
        upsert settings;

        Account newAccount = new Account(Name = 'Martsigras Inc');
        insert newAccount;
    }

    @isTest
    private static void createCase_success_primary() {
        // Arrange
        Account thisAccount = [SELECT Id FROM Account LIMIT 1];
        Contact newContact = new Contact(AccountId = thisAccount.Id, Level__c = 'Primary', LastName = 'Mulholland');

        // Act
        insert newContact;

        // Assert
        List<Case> cases = [SELECT Id, Priority FROM Case WHERE ContactId = :newContact.Id];
        System.assertEquals(1, cases.size(), 'There should have been 1 Case created');
        System.assertEquals('High', cases[0].Priority, 'The Cases Priority should be High');
    }

    @isTest
    private static void createCase_success_secondary() {
        // Arrange
        Account thisAccount = [SELECT Id FROM Account LIMIT 1];
        Contact newContact = new Contact(AccountId = thisAccount.Id, Level__c = 'Secondary', LastName = 'Mulholland');

        // Act
        insert newContact;

        // Assert
        List<Case> cases = [SELECT Id, Priority FROM Case WHERE ContactId = :newContact.Id];
        System.assertEquals(1, cases.size(), 'There should have been 1 Case created');
        System.assertEquals('Medium', cases[0].Priority, 'The Cases Priority should be Medium');
    }

    @isTest
    private static void createCase_success_tertiary() {
        // Arrange
        Account thisAccount = [SELECT Id FROM Account LIMIT 1];
        Contact newContact = new Contact(AccountId = thisAccount.Id, Level__c = 'Tertiary', LastName = 'Mulholland');

        // Act
        insert newContact;

        // Assert
        List<Case> cases = [SELECT Id, Priority FROM Case WHERE ContactId = :newContact.Id];
        System.assertEquals(1, cases.size(), 'There should have been 1 Case created');
        System.assertEquals('Low', cases[0].Priority, 'The Cases Priority should be Low');
    }

    @isTest
    private static void createCase_success_blank() {
        // Arrange
        Account thisAccount = [SELECT Id FROM Account LIMIT 1];
        Contact newContact = new Contact(AccountId = thisAccount.Id, LastName = 'Mulholland');

        // Act
        insert newContact;

        // Assert
        List<Case> cases = [SELECT Id, Priority FROM Case WHERE ContactId = :newContact.Id];
        System.assertEquals(1, cases.size(), 'There should have been 1 Case created');
        System.assertEquals(null, cases[0].Priority, 'The Cases Priority should be null');
    }

    @isTest
    private static void createCase_multipleSuccesses() {
        // Arrange
        Account thisAccount = [SELECT Id FROM Account LIMIT 1];
        List<Contact> contacts = new List<Contact>();
        for ( integer x = 0; x < 100; x++ ) {
            Contact newContact = new Contact(AccountId = thisAccount.Id, Level__c = 'Primary', LastName = 'Mulholland'+x);
            contacts.add(newContact);
        }

        // Act
        insert contacts;

        // Assert
        List<Case> cases = [SELECT Id, Priority FROM Case];
        System.assertEquals(100, cases.size(), 'There should have been 100 Cases created');
        System.assertEquals('High', cases[0].Priority, 'The Cases Priority should be High');
    }
}
