import { LightningElement, wire, track, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import getContainersTracker from '@salesforce/apex/ContainerTrackerController.getContainersTracker';
import deleteSelectedTrackers from '@salesforce/apex/ContainerTrackerController.deleteSelectedTrackers';
const COLUMNS = [
	{label: 'Tracker ID', fieldName: 'Id'},
	{label: 'Tracker Name', fieldName: 'Name'},
	{label: 'Ship Name', fieldName: 'Cargo_Ship__r.Name'},
	{label: 'Container Name', fieldName: 'Container__r.Name'},
	{label: 'Container Color', fieldName: 'Container_Color__c'},
	{type: 'button', typeAttributes: {
		label: 'View',
		name: 'View',
		title: 'View',
		disabled: false,
		value: 'view',
		iconPosition: 'left'
	}},
	{type: 'button', typeAttributes: {
		label: 'Edit',
		name: 'Edit',
		title: 'Edit',
		disabled: false,
		value: 'edit',
		iconPosition: 'left'
	}}
];

export default class ContainerTransportations extends NavigationMixin (LightningElement) {
	error;
	recordPageUrl;

	@track isDeleteButtonDisabled = true;
	@track tableData;
	@track columns = COLUMNS;
	@track addNewLabel = 'Add new transaction';
	@track deleteLabel = 'Delete selected transactions';
	@track selectedTrackerIdList = [];
	@track message;
	@track wiredDataTable = [];
	
	@wire(getContainersTracker)
	trackerHandler(result) {
		this.wiredDataTable = result;
		if(result.data) {
			this.tableData = result.data.map(
				record => Object.assign({
					'Id': record.Id,
					'Name': record.Name,
					'Cargo_Ship__r.Name': record.Cargo_Ship__r.Name,
					'Container__r.Name': record.Container__r.Name,
					'Container_Color__c': record.Container_Color__c
				})
			);
		}
		if(result.error) {
			alert(result.error);
			console.log("error", JSON.stringify(result.error));
		}
	}

	handleRowAction(event) {
		const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;  

		if (actionName === 'Edit') {
			this[NavigationMixin.Navigate]({
				type: 'standard__recordPage',
				attributes: {
					recordId: recId,
					objectApiName: 'Container_Tracker__c',
					actionName: 'edit',
				},
			});
		}
		else if (actionName === 'View') {
			this[NavigationMixin.Navigate]({
				type: 'standard__recordPage',
				attributes: {
					recordId: recId,
					objectApiName: 'Container_Tracker__c',
					actionName: 'view',
				},
			});
		}
	}

	navigateToNewRecordPage() {
		this[NavigationMixin.Navigate]({
			type: 'standard__objectPage',
			attributes: {
				objectApiName: 'Container_Tracker__c',
				actionName: 'new'
			},
		});
	}

	deleteSelRecords() {
		deleteSelectedTrackers({selectedTrackersIdList: this.selectedTrackerIdList})
		.then(result => {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Success',
					message: 'Selected Trackers are DELETED!',
					variant: 'success'
				}),
			);
			this.template.querySelector('lightning-datatable').selectedRows = [];
			return refreshApex(this.wiredDataTable);
		})
		.catch(error => {
			this.message = undefined;
			this.error = error;
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Error occurred manipulations with records',
					message: error.body.pageErrors[0].message,
					variant: 'error'
				}),
			);
			console.log("error", JSON.stringify(this.error));
		});
	}

	prepareSelectedRows(event) {
		const selectedRows = event.detail.selectedRows;
		this.selectedTrackerIdList = [];
		for (let i = 0; i < selectedRows.length; i++) {
			this.selectedTrackerIdList.push(selectedRows[i].Id);
		}
		if (selectedRows.length > 0) {
			this.isDeleteButtonDisabled = false;
		}
		else {
			this.isDeleteButtonDisabled = true;
		}
	}
}
