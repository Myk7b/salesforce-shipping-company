@IsTest
public class ContainerTriggerUnitTest {
	public static testMethod void startApprovalTest () {
		Container__c container = new Container__c (
			Length__c = 10,
			Width__c = 11,
			Height__c = 12,
			Transportation_Counter__c = 10,
			Status__c = 'Need inspection'
		);
		Test.startTest();
		insert container;
		Test.stopTest();
		ProcessInstance objProcessInstance = [SELECT Id, TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :container.Id];
		System.debug(objProcessInstance.id);
		System.assertEquals(objProcessInstance.TargetObjectId, container.id);
	}
}
