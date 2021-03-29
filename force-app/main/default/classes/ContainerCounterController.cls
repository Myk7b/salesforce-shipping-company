public with sharing class ContainerCounterController {
	@AuraEnabled(cacheable=true)
	public static List<AggregateResult> getContainersCount() {
		List<AggregateResult> counterList = [SELECT Cargo_Ship__r.Name, Container_Color__c, COUNT(Container__c) Containers FROM Container_Tracker__c GROUP BY Cargo_Ship__r.Name, Container_Color__c];
		System.debug('AggregateResult: ' + counterList);
		return counterList;
	}
}
