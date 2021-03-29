@IsTest
public with sharing class ContainerControlerUnitTest {
	public static testMethod void deleteContainerAssignmentsTest () {
		String SHIP_NAME = 'Okostin';
		String SHIP_SERIAL_NUMBER = 'STA-12345687';
		Integer SHIP_LENGTH = 999;
		List<Container__c> listContainer = new List<Container__c>();
		List<Container_Tracker__c> listContainerTracker = new List<Container_Tracker__c>();
		List<Id> selectedTrackersIdList = new List<Id>();

		Cargo_Ship__c cargoShip = new Cargo_Ship__c (
			Name = SHIP_NAME,
			Ship_Serial_Number__c = SHIP_SERIAL_NUMBER,
			Capacity__c = 300,
			Length__c = SHIP_LENGTH,
			Width__c = 300,
			Height__c = 22
		);
		insert cargoShip;

		for (Integer i = 0; i <= 200; i++) {
			Container__c container = new Container__c (
			Length__c = 91,
			Width__c = 3,
			Height__c = 2
			);
			listContainer.add(container);
		}
		insert listContainer;

		for(Integer j = 0; j < listContainer.size(); j++) {
			Container__c listContainers = listContainer[j];
			listContainerTracker.add(new Container_Tracker__c(
				Cargo_Ship__c = cargoShip.id,
				Container__c = listContainers.id,
				Container_Color__c = 'Yellow'
			));
		}
		insert listContainerTracker;

		for (Container_Tracker__c idList : [SELECT Id FROM Container_Tracker__c WHERE Cargo_Ship__r.Length__c = :SHIP_LENGTH]) {
			selectedTrackersIdList.add(idList.id);
		}

		Test.startTest();
		ContainerTrackerController.deleteSelectedTrackers(selectedTrackersIdList);
		Test.stopTest();
		System.assertEquals(0, [SELECT Id FROM Container_Tracker__c WHERE Id IN :selectedTrackersIdList].size());
	}
}
