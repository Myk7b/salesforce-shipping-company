trigger ContainerTrigger on Container__c (before insert, before update) {
    if (Trigger.isBefore) {
        If (Trigger.isInsert || Trigger.isUpdate) {
            ContainerHelper.startApproval(Trigger.new);
        }
    }
}
