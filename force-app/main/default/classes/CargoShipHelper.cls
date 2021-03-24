public with sharing class CargoShipHelper {

	static string USER_MAIL = 'tserulyk@gmail.com';
	static string COMPANY_NAME = 'Moby-Dick';
	static string FIELD_SHIP_NAME = 'Cargo Ship Name';
	static string FIELD_SHIP_SERIAL_NUMBER = 'Ship Serial Number';
	static string FIELD_CARGO_SHIP_CALSS = 'Cargo Ship Class';
	static string FIELD_SHIP_CAPACITY = 'Ship Capacity';
	static string FIELD_SHIP_CLASS = 'Ship Class';
	static string CUSTOM_NOTIFY_TYPE_NAME = 'Contract Due Date Changed';
	static string USER_ROLE_NAME = 'Director of Transportation';

    public static void sendEmailsToCapitan(List<Cargo_Ship__c> newShip, Map<id, Cargo_Ship__c> oldShip) { //after update
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		Id[] pIds = new List<Id>();

		for (Cargo_Ship__c shipRec: newShip) {
			Cargo_Ship__c shipOldRec = oldShip.get(shipRec.Id);
			if(shipRec.Capitan__c != shipOldRec.Capitan__c && String.IsNotBlank(shipRec.Capitan__c)) {
				pIds.add(shipRec.id);
			}
		}

		if (pIds.size() > 0) {
			List<Cargo_Ship__c> CurrentCargo = [
					SELECT Name,
					Ship_Serial_Number__c,
					Ship_Class__c,
					Capacity__c,
					Capitan__r.Email__c
					FROM Cargo_Ship__c WHERE Cargo_Ship__c.id IN :pIds];

			for (Cargo_Ship__c cShip: CurrentCargo) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
					mail.setToAddresses(new String[] {cShip.Capitan__r.Email__c});
					mail.setReplyTo(USER_MAIL);
					mail.setSenderDisplayName(COMPANY_NAME);	
					mail.setSubject('Welcome Aboard');
					mail.setHtmlBody('The ' + FIELD_SHIP_NAME + ': ' + cShip.Name +
									'<br>The ' + FIELD_SHIP_SERIAL_NUMBER + ': ' + cShip.Ship_Serial_Number__c +
									'<br>The ' + FIELD_CARGO_SHIP_CALSS + ': ' + cShip.Ship_Class__c +
									'<br>The ' + FIELD_SHIP_CAPACITY + ': ' + cShip.Capacity__c);
					mails.add(mail);
			}
		}	
    Messaging.sendEmail(mails);
    }

	public static void updateDetailsField(List<Cargo_Ship__c> newShip) { //before insert
		for (Cargo_Ship__c shipRec: newShip) {
			if (
				String.IsNotBlank(shipRec.Ship_Details__c)
				&& String.IsNotBlank(shipRec.Name)
				&& String.IsNotBlank(shipRec.Ship_Serial_Number__c)
				) {
				shipRec.Ship_Details__c = shipRec.Ship_Details__c + '\n' + shipRec.Name + ' ' + shipRec.Ship_Serial_Number__c;
			}
			else if(String.IsNotBlank(shipRec.Name) && String.IsNotBlank(shipRec.Ship_Serial_Number__c)) {
				shipRec.Ship_Details__c = shipRec.Name + ' ' + shipRec.Ship_Serial_Number__c;
			}
		}
	}

	public static void deniedUpdateShipClassField(List<Cargo_Ship__c> newShip, Map<id, Cargo_Ship__c> oldShip) { //before update
		for (Cargo_Ship__c shipRec: newShip) {

			Cargo_Ship__c shipOldRec = oldShip.get(shipRec.Id);
			
			if (shipRec.Ship_Class__c != shipOldRec.Ship_Class__c && String.IsNotBlank(shipOldRec.Ship_Class__c)) {
				shipRec.adderror('The Field - ' + FIELD_SHIP_CLASS + ' Can`t" be Changed!');
			}
		}
	}

	public static void SendNotificationContractDueDateChanged(List<Cargo_Ship__c> newShip, Map<id, Cargo_Ship__c> oldShip) { //before update
		List<User> user = [SELECT id FROM User WHERE userrole.name = :USER_ROLE_NAME];
		CustomNotificationType notificationType = [SELECT Id FROM CustomNotificationType WHERE CustomNotifTypeName = :CUSTOM_NOTIFY_TYPE_NAME];

		for (Cargo_Ship__c shipRec: newShip) {

			Cargo_Ship__c shipOldRec = oldShip.get(shipRec.Id);
			
			if (shipRec.Contract_Due_Date__c != shipOldRec.Contract_Due_Date__c) {
				
				Messaging.CustomNotification notification = new Messaging.CustomNotification();
				Set<String> addresses = new Set<String>();
				
				notification.setTitle('Contract Due Date Changed');
				notification.setBody('The Contract Due Date has been changed: ' + shipRec.Name + ' ' + shipRec.id);
				
				notification.setSenderId(Userinfo.getUserId());
				
				notification.setNotificationTypeId(notificationType.Id);
				notification.setTargetId(shipRec.id);
				
				for (User objUser : user) {
					addresses.add(objUser.id);
					notification.send(addresses);
				}
			}
		}
	}
}
