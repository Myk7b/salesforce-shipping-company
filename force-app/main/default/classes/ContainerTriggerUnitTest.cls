@IsTest
public class ContainerTriggerUnitTest {
	static string CONTAINER_STATUS = 'Need inspection';
	public static testMethod void startApprovalTest () {
		List<Container__c> listCont = new List<Container__c>();
			for(Integer i = 0; i <= 200; i++) {
				Container__c container = new Container__c (
				Length__c = 10,
				Width__c = 11,
				Height__c = 12,
				Transportation_Counter__c = 10,
				Status__c = CONTAINER_STATUS
			);
			listCont.add(container);
		}
		
		Test.startTest();
		insert listCont;
		Test.stopTest();
		List<Container__c> listContId = [SELECT Id FROM Container__c WHERE Status__c = :CONTAINER_STATUS];
		List <ProcessInstance> objProcessInstance = [SELECT Id, TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId IN :listContId];

		System.assertEquals(listContId.size(), objProcessInstance.size());
	}
}
