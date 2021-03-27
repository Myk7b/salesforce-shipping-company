public with sharing class ContainerTrackerController {
	@AuraEnabled(cacheable=true)
	public static List<Container_Tracker__c> getContainersTracker() {
		return [SELECT Id, Name, Cargo_Ship__r.Name, Container__r.Name FROM Container_Tracker__c];
	}

	@AuraEnabled
	public static void deleteSelectedTrackers(List<Id> selectedTrackersIdList){
		List<Container_Tracker__c> trackerList = new List<Container_Tracker__c>();
		trackerList = [SELECT id FROM Container_Tracker__c WHERE id IN :selectedTrackersIdList];
		if(trackerList != null && trackerList.size() > 0) {
			delete trackerList;
		}
	}
}
