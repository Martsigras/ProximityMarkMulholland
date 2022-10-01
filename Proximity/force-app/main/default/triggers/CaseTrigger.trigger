trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    CaseTriggerHandler caseHandler = new CaseTriggerHandler(Trigger.new, Trigger.oldMap);
}