trigger ContainerTrigger on Container__c (after insert, after update) {
	if (Trigger.isAfter) {
		If (Trigger.isInsert || Trigger.isUpdate) {
			ContainerHelper.startApproval(Trigger.newMap);
		}
	}
}
