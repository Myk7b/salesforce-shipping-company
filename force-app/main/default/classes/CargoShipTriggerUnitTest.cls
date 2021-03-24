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
			String shipName = 'Mazda-' + String.valueOf(i);
			String sipSerialNumber = 'STA-F' + String.valueOf(i);

			Cargo_Ship__c cargoShip = new Cargo_Ship__c (
				Name = shipName,
				Ship_Serial_Number__c = sipSerialNumber,
				Capacity__c = 10,
				Length__c = SHIP_LENGTH,
				Width__c = 300,
				Height__c = 22,
				Ship_Class__c = SHIP_CLASS
			);
			listShip.add(cargoShip);
		}

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

	// public static testMethod void sendEmailsToCapitanTest () {
	// 	Integer randomNumber = Integer.valueof((Math.random() * 10000));
	// 	String shipName = 'BMW-' + String.valueOf(randomNumber);
	// 	String sipSerialNumber = 'STA-' + String.valueOf(randomNumber);
	// 	String shipDetails = shipName + ' ' + sipSerialNumber;
	// 	String fieldShipClass = 'Ship Class';
	// 	Date birthDay = date.newInstance(1990, 11, 21);

    //     Cargo_Ship__c cargoShip = new Cargo_Ship__c (
    //         Name = shipName,
    //         Ship_Serial_Number__c = sipSerialNumber,
	// 		Capacity__c = 10,
	// 		Length__c = 900,
	// 		Width__c = 300,
	// 		Height__c = 22
	// 	);
	// 	insert cargoShip;

	// 	Capitan__c capitan = new Capitan__c(
	// 		Name = 'TORT1',
	// 		SSN__c = 45645,
	// 		Status__c = 'Active',
	// 		Birth_Day__c = birthDay,
	// 		Email__c = 'tserulyk@gmail.com'
	// 	);
	// 	insert capitan;


	// 	List <Cargo_Ship__c> cargoShipList = new List <Cargo_Ship__c>();
	// 	for (Cargo_Ship__c updateCargoShip : [SELECT id FROM Cargo_Ship__c WHERE Name = :shipName]) {
	// 		updateCargoShip.Capitan__c = capitan.id;
	// 		cargoShipList.add(updateCargoShip);
	// 	}
	// 	Test.startTest();
	// 		update cargoShipList;
	// 		Integer emailInvocations = Limits.getEmailInvocations();
	// 	Test.stopTest();

	// 	system.assertEquals(1, emailInvocations, 'An email should be sent');
	// } 

	// public static testMethod void SendNotificationTest () {
	// 	Integer randomNumber = Integer.valueof((Math.random() * 10000));
	// 	String shipName = 'BMW-' + String.valueOf(randomNumber);
	// 	String sipSerialNumber = 'STA-' + String.valueOf(randomNumber);
	// 	String shipDetails = shipName + ' ' + sipSerialNumber;
	// 	Date contractStartDate = System.today();
	// 	Date contractDueDate = System.today() + 5;
	// 	Date contractNewDueDate = System.today() + 6;

    //     Cargo_Ship__c cargoShip = new Cargo_Ship__c (
    //         Name = shipName,
    //         Ship_Serial_Number__c = sipSerialNumber,
	// 		Capacity__c = 10,
	// 		Length__c = 900,
	// 		Width__c = 300,
	// 		Height__c = 22,
	// 		Contract_Start_Date__c = contractStartDate,
	// 		Contract_Due_Date__c = contractDueDate

    //     );
	// 	insert cargoShip;

	// 	List <Cargo_Ship__c> cargoShipList = new List <Cargo_Ship__c>();
	// 	for (Cargo_Ship__c updateCargoShip : [SELECT id FROM Cargo_Ship__c WHERE Name = :shipName]) {
	// 		updateCargoShip.Contract_Due_Date__c = contractNewDueDate;
	// 		cargoShipList.add(updateCargoShip);
	// 	}

	// 	Test.startTest();
	// 	update cargoShipList;
	// 	Test.stopTest();
	// }
}
