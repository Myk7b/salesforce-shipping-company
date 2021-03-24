@IsTest
public class CargoShipTriggerUnitTest {
    public static testMethod void updateDetailsFieldTest () {
		Integer SHIP_LENGTH = 606;
		List<Cargo_Ship__c> listShip = new List<Cargo_Ship__c>();

		for (Integer i = 0; i <= 200; i++) {
			String SHIP_NAME = 'BMW-' + String.valueOf(i);
			String SHIP_SERIAL_NUMBER = 'STA-C' + String.valueOf(i);

			Cargo_Ship__c cargoShip = new Cargo_Ship__c (
				Name = SHIP_NAME,
				Ship_Serial_Number__c = SHIP_SERIAL_NUMBER,
				Capacity__c = 10,
				Length__c = SHIP_LENGTH,
				Width__c = 300,
				Height__c = 22
			);
			listShip.add(cargoShip);
		}

		Test.startTest();
		insert listShip;
		Test.stopTest();

		for (Cargo_Ship__c shipDetails : [SELECT Name, Ship_Serial_Number__c, Ship_Details__c FROM Cargo_Ship__c WHERE Length__c = :SHIP_LENGTH]) {
			System.assertEquals(shipDetails.Ship_Details__c, shipDetails.Name + ' ' + shipDetails.Ship_Serial_Number__c);
		}
    }

	public static testMethod void deniedUpdateShipClassFieldTest () {
		String FIELD_SHIP_CLASS = 'Ship Class';
		String SHIP_CLASS = 'Small Feeder';
		String NEW_SHIP_CLASS = 'Feeder';
		Integer SHIP_LENGTH = 606;

		List<Cargo_Ship__c> listShip = new List<Cargo_Ship__c>();

		for (Integer i = 0; i <= 200; i++) {
			String SHIP_NAME = 'Mazda-' + String.valueOf(i);
			String SHIP_SERIAL_NUMBER = 'STA-F' + String.valueOf(i);

			Cargo_Ship__c cargoShip = new Cargo_Ship__c (
				Name = SHIP_NAME,
				Ship_Serial_Number__c = SHIP_SERIAL_NUMBER,
				Capacity__c = 10,
				Length__c = SHIP_LENGTH,
				Width__c = 300,
				Height__c = 22,
				Ship_Class__c = SHIP_CLASS
			);
			listShip.add(cargoShip);
		}
		insert listShip;

		List <Cargo_Ship__c> cargoShipList = new List <Cargo_Ship__c>();
		for (Cargo_Ship__c updateCargoShip : [SELECT id FROM Cargo_Ship__c WHERE Length__c = :SHIP_LENGTH]) {
			updateCargoShip.Ship_Class__c = NEW_SHIP_CLASS;
			cargoShipList.add(updateCargoShip);
		}
		Test.startTest();
		try {
			update cargoShipList;
		}
		catch(Exception e) {
			System.assert(e.getMessage().contains('The Field - ' + FIELD_SHIP_CLASS + ' Can`t" be Changed!'));
		}
		Test.stopTest();
	}

	public static testMethod void sendEmailsToCapitanTest () {
		Date BIRTHDAY = date.newInstance(1990, 11, 21);
		Integer SHIP_LENGTH = 609;
		String CAPITAN_EMAIL = 'bixet85743@kindbest.com';
		List<Cargo_Ship__c> listShip = new List<Cargo_Ship__c>();
		List <Cargo_Ship__c> cargoShipList = new List <Cargo_Ship__c>();

		Capitan__c capitan = new Capitan__c(
			Name = 'TORT1',
			SSN__c = 45645,
			Status__c = 'Active',
			Birth_Day__c = BIRTHDAY,
			Email__c = CAPITAN_EMAIL
		);
		insert capitan;

		for (Integer i = 0; i <= 200; i++) {
			String SHIP_NAME = 'Toyota-' + String.valueOf(i);
			String SHIP_SERIAL_NUMBER = 'STA-L' + String.valueOf(i);

			Cargo_Ship__c cargoShip = new Cargo_Ship__c (
				Name = SHIP_NAME,
				Ship_Serial_Number__c = SHIP_SERIAL_NUMBER,
				Capacity__c = 10,
				Length__c = SHIP_LENGTH,
				Width__c = 300,
				Height__c = 22
			);
			listShip.add(cargoShip);
		}
		insert listShip;

		for (Cargo_Ship__c updateCargoShip : [SELECT id FROM Cargo_Ship__c WHERE Length__c = :SHIP_LENGTH]) {
			updateCargoShip.Capitan__c = capitan.id;
			cargoShipList.add(updateCargoShip);
		}
		Test.startTest();
			update cargoShipList;
			Integer emailInvocations = Limits.getEmailInvocations();
		Test.stopTest();

		system.assertEquals(201, emailInvocations, 'An email should be sent');
	} 

	public static testMethod void SendNotificationTest () {
		Date CONTRACT_START_DATE = System.today();
		Date CONTRACT_DUE_DATE = System.today() + 5;
		Date CONTACT_NEW_DUE_DATE = System.today() + 6;
		Integer SHIP_LENGTH = 607;

		List<Cargo_Ship__c> listShip = new List<Cargo_Ship__c>();

		for (Integer i = 0; i <= 200; i++) {
			String SHIP_NAME = 'ANTONOV-' + String.valueOf(i);
			String SHIP_SERIAL_NUMBER = 'STA-GG' + String.valueOf(i);

			Cargo_Ship__c cargoShip = new Cargo_Ship__c (
				Name = SHIP_NAME,
				Ship_Serial_Number__c = SHIP_SERIAL_NUMBER,
				Capacity__c = 10,
				Length__c = SHIP_LENGTH,
				Width__c = 300,
				Height__c = 22,
				Contract_Start_Date__c = CONTRACT_START_DATE,
				Contract_Due_Date__c = CONTRACT_DUE_DATE
			);
			listShip.add(cargoShip);
		}
		insert listShip;

		List <Cargo_Ship__c> cargoShipList = new List <Cargo_Ship__c>();
		for (Cargo_Ship__c updateCargoShip : [SELECT id FROM Cargo_Ship__c WHERE Length__c = :SHIP_LENGTH]) {
			updateCargoShip.Contract_Due_Date__c = CONTACT_NEW_DUE_DATE;
			cargoShipList.add(updateCargoShip);
		}

		Test.startTest();
		update cargoShipList;
		Test.stopTest();
	}
}
