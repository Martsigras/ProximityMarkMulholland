public with sharing class CaseTriggerHandler {
    public Case_Triggers__c settings = Case_Triggers__c.getOrgDefaults();
    public CaseTriggerHandler(List<Case> newCases, Map<Id, Case> oldMap) {
        if ( Trigger.isBefore ) {
            if ( Trigger.isInsert ) {

            } else if ( Trigger.isUpdate ) {

            }else if ( Trigger.isDelete ) {
                
            }
        } else {
            if ( Trigger.isInsert ) {
                createTask(newCases);
            } else if ( Trigger.isUpdate ) {

            }else if ( Trigger.isDelete ) {
                
            }else if ( Trigger.isUndelete ) {
                
            }
        }
    }

    private void createTask(List<Case> newCases) {
        if ( settings.Create_Task_for_new_Case__c ) {
            List<Task> newTasks = new List<Task>();
            for ( Case thisCase : newCases ) {
                Task newTask = new Task(OwnerId = thisCase.OwnerId,
                                        Status = 'Not Started',
                                        Subject = 'Welcome call for '+thisCase.CaseNumber,
                                        Priority = 'Normal');
                if ( thisCase.Priority == 'High' ) {
                    newTask.ActivityDate = Date.today().addDays(7);
                } else if ( thisCase.Priority == 'Medium' ) {
                    newTask.ActivityDate = Date.today().addDays(14);
                } else {
                    newTask.ActivityDate = Date.today().addDays(21);
                }
                newTasks.add(newTask);
            }

            if ( newTasks.size() > 0 ) {
                try{
                    insert newTasks;
                } catch (Exception e) {
                    System.debug('One or more Tasks failed to create because the following error occured '+e.getMessage()+' on line '+e.getLineNumber());
                    //Ideally we would have an object where we can store details of any errors thrown, so we know when and if a problem happens, but this is not in scope
                }
            }
        }
    }
}
