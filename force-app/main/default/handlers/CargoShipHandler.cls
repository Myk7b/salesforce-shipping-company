public with sharing class CargoShipHandler {

	public static void onBeforeInsert() {
		CargoShipHelper.updateDetailsField();
	}

	public static void onBeforeUpdate() {
		CargoShipHelper.deniedUpdateShipClassField();
		CargoShipHelper.SendNotificationContractDueDateChanged();
	}

	public static void onAfterUpdate() {
		CargoShipHelper.sendEmailsToCapitan();
	}
}
