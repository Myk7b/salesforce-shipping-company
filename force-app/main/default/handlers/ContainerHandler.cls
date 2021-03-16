public with sharing class ContainerHandler {
	public static void onBeforeInsert() {
		ContainerHelper.startApproval();
	}

	public static void onBeforeUpdate() {
		ContainerHelper.startApproval();
	}
}
