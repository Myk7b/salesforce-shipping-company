trigger CargoShipTrigger on Cargo_Ship__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        If (Trigger.isInsert) {
            CargoShipHandler.onBeforeInsert();
        }
        else if (Trigger.isUpdate) {
            CargoShipHandler.onBeforeUpdate();
        }
    }
    else if (Trigger.isAfter) {
        If (Trigger.isInsert) {
            //after insert
        }
        else if (Trigger.isUpdate) {
            CargoShipHandler.onAfterUpdate();
        }
    }
}
