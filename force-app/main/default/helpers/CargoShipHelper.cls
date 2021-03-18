public with sharing class CargoShipHelper {

    private static string UserMail = 'tserulyk@gmail.com';
	private static string CompanyName = 'Moby-Dick';
	private static string FieldShipName = 'Cargo Ship Name';
	private static string FieldShipSerialNumber = 'Ship Serial Number';
	private static string FieldCargoShipClass = 'Cargo Ship Class';
	private static string FieldShipCapacity = 'Ship Capacity';
	private static string FieldShipClass = 'Ship Class';
	private static string CustomNotifTypeName = 'Contract Due Date Changed';
	private static string UserRoleName = 'Director of Transportation';

    public static void sendEmailsToCapitan(List<Cargo_Ship__c> newShip, Map<id, Cargo_Ship__c> oldShip) { //after update
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
		for (Cargo_Ship__c shipRec: newShip) {
		Cargo_Ship__c shipOldRec = oldShip.get(shipRec.Id);
			if(shipRec.Capitan__c != shipOldRec.Capitan__c && String.IsNotBlank(shipRec.Capitan__c)) {

				List<Cargo_Ship__c> CurrentCargo = [
					SELECT Name,
					Ship_Serial_Number__c,
					Ship_Class__c,
					Capacity__c
					FROM Cargo_Ship__c WHERE Cargo_Ship__c.ID__c = :shipRec.ID__c];

				String capitanEmail = [SELECT Email__c FROM Capitan__c WHERE id IN (SELECT Capitan__c FROM Cargo_Ship__c WHERE Cargo_Ship__c.ID__c = :shipRec.ID__c)].Email__c;
				List<String> capitanEmailsList = new List<String>();
				capitanEmailsList.add(capitanEmail);

				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
				mail.setToAddresses(capitanEmailsList);
				mail.setReplyTo(UserMail);
				mail.setSenderDisplayName(CompanyName);	
				mail.setSubject('Welcome Aboard');
				mail.setHtmlBody('The ' + FieldShipName + ': ' + CurrentCargo[0].Name +
								'<br>The ' + FieldShipSerialNumber + ': ' + CurrentCargo[0].Ship_Serial_Number__c +
								'<br>The ' + FieldCargoShipClass + ': ' + CurrentCargo[0].Ship_Class__c +
								'<br>The ' + FieldShipCapacity + ': ' + CurrentCargo[0].Capacity__c);
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
				shipRec.adderror('The Field - ' + FieldShipClass + ' Can`t" be Changed!');
			}
		}
	}

	public static void SendNotificationContractDueDateChanged(List<Cargo_Ship__c> newShip, Map<id, Cargo_Ship__c> oldShip) { //before update
		for (Cargo_Ship__c shipRec: newShip) {

			Cargo_Ship__c shipOldRec = oldShip.get(shipRec.Id);
			
			if (shipRec.Contract_Due_Date__c != shipOldRec.Contract_Due_Date__c) {

				CustomNotificationType notificationType = [SELECT Id FROM CustomNotificationType WHERE CustomNotifTypeName = :CustomNotifTypeName]; // id: 0ML090000010wFIGAY CustomNotifTypeName: Contract Due Date Changed
				
				Messaging.CustomNotification notification = new Messaging.CustomNotification();
				Set<String> addresses = new Set<String>();
				
				notification.setTitle('Contract Due Date Changed');
				notification.setBody('The Contract Due Date has been changed: ' + shipRec.Name + ' ' + shipRec.id);
				
				notification.setSenderId(Userinfo.getUserId());
				
				notification.setNotificationTypeId(notificationType.Id);
				notification.setTargetId(shipRec.id);
				
				for (User objUser : [SELECT id FROM User WHERE userrole.name = :UserRoleName]) {
					addresses.add(objUser.id);
					notification.send(addresses);
				}
			}
		}
	}
}
