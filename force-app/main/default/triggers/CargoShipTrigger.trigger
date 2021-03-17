trigger CargoShipTrigger on Cargo_Ship__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        If (Trigger.isInsert) {
            CargoShipHelper.updateDetailsField(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            CargoShipHelper.deniedUpdateShipClassField(Trigger.new, Trigger.oldMap);
            CargoShipHelper.SendNotificationContractDueDateChanged(Trigger.new, Trigger.oldMap);
        }
    }
    else if (Trigger.isAfter) {
        If (Trigger.isInsert) {
        }
        else if (Trigger.isUpdate) {
            CargoShipHelper.sendEmailsToCapitan(Trigger.new, Trigger.oldMap);
        }
    }
}
