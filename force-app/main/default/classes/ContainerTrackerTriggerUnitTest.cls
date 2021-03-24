@IsTest
public class ContainerTrackerTriggerUnitTest {
	public static testMethod void calculateContainerAssignmentsTest () {
		String SHIP_NAME = 'Okostin';
		String SHIP_SERIAL_NUMBER = 'STA-12345687';
		List<Container__c> listContainer = new List<Container__c>();
		List<Container_Tracker__c> listContainerTracker = new List<Container_Tracker__c>();

		Cargo_Ship__c cargoShip = new Cargo_Ship__c (
			Name = SHIP_NAME,
			Ship_Serial_Number__c = SHIP_SERIAL_NUMBER,
			Capacity__c = 300,
			Length__c = 606,
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
				Container__c = listContainers.id
			));
		}
		Test.startTest();
		insert listContainerTracker;
		Test.stopTest();
		List<Container__c> transportationCounter = [SELECT Name FROM Container__c WHERE Transportation_Counter__c = 1];
		System.assertEquals(transportationCounter.size(), 201);
	}
}
