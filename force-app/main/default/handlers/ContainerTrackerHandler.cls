public with sharing class ContainerTrackerHandler {
	public static void onAfterInsert() {
		ContainerTrackerHelper.calculateContainerAssignments();
	}
}
