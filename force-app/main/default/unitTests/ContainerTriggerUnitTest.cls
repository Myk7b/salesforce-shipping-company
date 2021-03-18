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
		insert container;

		ProcessInstance objProcessInstance = [SELECT Id,TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :container.Id];
		System.assertEquals(container.CreatedDate,objProcessInstance.CreatedDate);
	}
}
