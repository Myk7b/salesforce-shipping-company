public with sharing class ContainerTrackerHelper {
	public static void calculateContainerAssignments(List<Container_Tracker__c> newContainerTracker) { //after insert
		Id[] cIds = new List<Id>();

		for (Container_Tracker__c trackerRec: newContainerTracker) {
			if (trackerRec.Container__c != Null) {
				cIds.add(trackerRec.Container__c);
			}
		}
	
		if(cIds.size() > 0) {
			List <Container__c> conList = new List <Container__c>();
			for (Container__c containerRec: [SELECT Transportation_Counter__c FROM Container__c WHERE id IN :cIds]) {
				if (containerRec.Transportation_Counter__c != Null) {
					containerRec.Transportation_Counter__c++;
				}
				else {
					containerRec.Transportation_Counter__c = 1;
				}
	
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
