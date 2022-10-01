trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    ContactTriggerHandler contactHandler = new ContactTriggerHandler();
    contactHandler.execute(Trigger.new, Trigger.oldMap);
}