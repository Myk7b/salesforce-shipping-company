@IsTest
public class CargoShipTriggerUnitTest {
    public static testMethod void updateDetailsFieldTest () {
		Integer randomNumber = Integer.valueof((Math.random() * 10000));
		String shipName = 'BMW-' + String.valueOf(randomNumber);
		String sipSerialNumber = 'STA-' + String.valueOf(randomNumber);
		String shipDetails = shipName + ' ' + sipSerialNumber;

        Cargo_Ship__c cargoShip = new Cargo_Ship__c (
            Name = shipName,
            Ship_Serial_Number__c = sipSerialNumber,
			Capacity__c = 10,
			Length__c = 900,
			Width__c = 300,
			Height__c = 22
        );

		Test.startTest();
		insert cargoShip;
		Test.stopTest();

		cargoShip = [SELECT Ship_Details__c FROM Cargo_Ship__c WHERE id = :cargoShip.id];

		System.assertEquals(shipDetails, cargoShip.Ship_Details__c);
    }

	public static testMethod void deniedUpdateShipClassFieldTest () {
		Integer randomNumber = Integer.valueof((Math.random() * 10000));
		String shipName = 'BMW-' + String.valueOf(randomNumber);
		String sipSerialNumber = 'STA-' + String.valueOf(randomNumber);
		String shipDetails = shipName + ' ' + sipSerialNumber;
		String fieldShipClass = 'Ship Class';

        Cargo_Ship__c cargoShip = new Cargo_Ship__c (
            Name = shipName,
            Ship_Serial_Number__c = sipSerialNumber,
			Capacity__c = 10,
			Length__c = 900,
			Width__c = 300,
			Height__c = 22,
			Ship_Class__c = 'Small Feeder'
		);
		insert cargoShip;

		List <Cargo_Ship__c> cargoShipList = new List <Cargo_Ship__c>();
		for (Cargo_Ship__c updateCargoShip : [SELECT id FROM Cargo_Ship__c WHERE Name = :shipName]) {
			updateCargoShip.Ship_Class__c = 'Feeder';
			cargoShipList.add(updateCargoShip);
		}
		Test.startTest();
		try {
			update cargoShipList;
        }
        catch(Exception e) {
            System.assert(e.getMessage().contains('The Field - ' + fieldShipClass + ' Can`t" be Changed!'));
        }
		Test.stopTest();
	}

	public static testMethod void sendEmailsToCapitanTest () {
		Integer randomNumber = Integer.valueof((Math.random() * 10000));
		String shipName = 'BMW-' + String.valueOf(randomNumber);
		String sipSerialNumber = 'STA-' + String.valueOf(randomNumber);
		String shipDetails = shipName + ' ' + sipSerialNumber;
		String fieldShipClass = 'Ship Class';
		Date birthDay = date.newInstance(1990, 11, 21);

        Cargo_Ship__c cargoShip = new Cargo_Ship__c (
            Name = shipName,
            Ship_Serial_Number__c = sipSerialNumber,
			Capacity__c = 10,
			Length__c = 900,
			Width__c = 300,
			Height__c = 22
		);
		insert cargoShip;

		Capitan__c capitan = new Capitan__c(
			Name = 'TORT1',
			SSN__c = 45645,
			Status__c = 'Active',
			Birth_Day__c = birthDay,
			Email__c = 'tserulyk@gmail.com'
		);
		insert capitan;


		List <Cargo_Ship__c> cargoShipList = new List <Cargo_Ship__c>();
		for (Cargo_Ship__c updateCargoShip : [SELECT id FROM Cargo_Ship__c WHERE Name = :shipName]) {
			updateCargoShip.Capitan__c = capitan.id;
			cargoShipList.add(updateCargoShip);
		}
		Test.startTest();
			update cargoShipList;
			Integer emailInvocations = Limits.getEmailInvocations();
		Test.stopTest();

		system.assertEquals(1, emailInvocations, 'An email should be sent');
	} 
}
