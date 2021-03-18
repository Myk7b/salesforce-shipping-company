trigger ContainerTrackerTrigger on Container_Tracker__c (after insert) {
	if (Trigger.isAfter) {
		If (Trigger.isInsert) {
			ContainerTrackerHelper.calculateContainerAssignments(Trigger.new); 
		}
	}
}
