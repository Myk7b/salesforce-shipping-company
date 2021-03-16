public with sharing class ContainerTrackerHelper {
	public static void calculateContainerAssignments() { //after insert

		Set <String> containerName = New Set <String>();

		for (Container_Tracker__c trackerRec: Trigger.new) {
		if (trackerRec.Container__c != Null) {
			String conName = [SELECT Name FROM Container__c WHERE id IN (Select Container__c FROM Container_Tracker__c WHERE Container_Tracker__c.Name = :trackerRec.Name)].Name;
			containerName.add(conName);
		}
	}

		if(containerName.size() > 0) {
			List <Container__c> conList = new List <Container__c>();
			for (Container__c containerRec: [SELECT id, Transportation_Counter__c FROM Container__c WHERE Name in: containerName]) {
				containerRec.Transportation_Counter__c++;
				if(containerRec.Transportation_Counter__c >= 4) {
					containerRec.Status__c = 'Need inspection';
				}
				conList.add(containerRec);
			}
			if (conList.size() > 0) {
				update conList;
			}
		} 
	}
}
