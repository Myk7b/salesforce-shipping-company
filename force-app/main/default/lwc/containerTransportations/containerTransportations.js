import { LightningElement, wire, track, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContainersTracker from '@salesforce/apex/ContainerTrackerController.getContainersTracker';
import deleteSelectedTrackers from '@salesforce/apex/ContainerTrackerController.deleteSelectedTrackers';
const COLUMNS = [
	{label: 'Tracker ID', fieldName: 'Id'},
	{label: 'Tracker Name', fieldName: 'Name'},
	{label: 'Ship Name', fieldName: 'Cargo_Ship__r.Name'},
	{label: 'Container Name', fieldName: 'Container__r.Name'}
]

export default class ContainerTransportations extends LightningElement {
	error;

	@track tableData;
	@track columns = COLUMNS;
	@track saveLabel = 'Save';
	@track deleteLabel = 'Delete selected records';
	@track selectedTrackerIdList = [];
	@track message;
	@track wiredDataTable = [];

	@wire(getContainersTracker)
	trackerHandler(result) {
		console.log(JSON.stringify(result));
		this.wiredDataTable = result;
		if(result.data) {
			this.tableData = result.data.map(
				record => Object.assign({
					'Id': record.Id,
					'Name': record.Name,
					'Cargo_Ship__r.Name': record.Cargo_Ship__r.Name,
					'Container__r.Name': record.Container__r.Name
				})
			);
		}
		if(result.error) {
			alert(result.error);
			console.log("error", JSON.stringify(result.error));
		}
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
	}
}
