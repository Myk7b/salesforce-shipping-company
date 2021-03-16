trigger ContainerTrackerTrigger on SOBJECT (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        If (Trigger.isInsert) {
            // before Insert 
        }
        else if (Trigger.isUpdate) {
            // before update
        }
    }
    else if (Trigger.isAfter) {
        If (Trigger.isInsert) {
            ContainerTrackerHandler.onAfterInsert(); 
        }
        else if (Trigger.isUpdate) {
            // after update
        }
    }
}
