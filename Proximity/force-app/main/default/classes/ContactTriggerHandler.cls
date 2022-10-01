public with sharing class ContactTriggerHandler {
    public Contact_Triggers__c settings = Contact_Triggers__c.getOrgDefaults();
    public void execute(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        if ( Trigger.isBefore ) {
            if ( Trigger.isInsert ) {

            } else if ( Trigger.isUpdate ) {

            }else if ( Trigger.isDelete ) {
                
            }
        } else {
            if ( Trigger.isInsert ) {
                createCase(newContacts);
            } else if ( Trigger.isUpdate ) {

            }else if ( Trigger.isDelete ) {
                
            }else if ( Trigger.isUndelete ) {
                
            }
        }
    }

    private void createCase(List<Contact> contacts) {
        System.debug('the method is called here');
        if ( settings.Create_Case_for_new_Contact__c ) {
            System.debug('the method continues here');
            Map<String, String> contactLevel = new Map<String, String>{'Primary' => 'High',
                                                                        'Secondary' => 'Medium',
                                                                        'Tertiary' => 'Low',
                                                                        '' => ''};
            List<Case> newCases = new List<Case>();
            for ( Contact thisContact : contacts ) {
                Case newCase = new Case(contactId = thisContact.Id, 
                                        AccountId = thisContact.AccountId,
                                        Status = 'Working',
                                        Origin = 'New Contact',
                                        OwnerId = thisContact.OwnerId,
                                        Priority = contactLevel.get(thisContact.Level__c));
                newCases.add(newCase);
            }
             if ( newCases.size() > 0 ) {
                try{
                    insert newCases;
                } catch (Exception e) {
                    System.debug('One or more Cases failed to create because the following error occured '+e.getMessage()+' on line '+e.getLineNumber());
                    //Ideally we would have an object where we can store details of any errors thrown, so we know when and if a problem happens, but this is not in scope
                }
             }
        }
    }
}
