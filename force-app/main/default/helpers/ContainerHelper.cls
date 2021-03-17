public with sharing class ContainerHelper {
	public static void startApproval(List<Container__c> newContainer) { //before insert, before update
		List<Approval.ProcessSubmitRequest> approvalList = new List<Approval.ProcessSubmitRequest>();

		for (Container__c containerRec: newContainer) {

			if(containerRec.Status__c == 'Need inspection' && containerRec.Transportation_Counter__c >= 5) {
				Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
				request.setComments('The container has 5 transactions. Please review record: ' + containerRec.id);
				request.setObjectId(containerRec.id);
				approvalList.add(request);
			}
		}
		List<Approval.ProcessResult> resultlist = Approval.process(approvalList);
	}
}
