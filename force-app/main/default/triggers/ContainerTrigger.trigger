trigger ContainerTrigger on SOBJECT (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        If (Trigger.isInsert) {
            ContainerHandler.onBeforeInsert(); 
        }
        else if (Trigger.isUpdate) {
            ContainerHandler.onBeforeUpdate();
        }
    }
    else if (Trigger.isAfter) {
        If (Trigger.isInsert) {
            // after Insert 
        }
        else if (Trigger.isUpdate) {
            // after update
        }
    }
}
