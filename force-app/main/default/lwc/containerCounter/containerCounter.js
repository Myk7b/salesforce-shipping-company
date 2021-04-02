import { LightningElement, wire, track, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getContainersCount from '@salesforce/apex/ContainerCounterController.getContainersCount';
const COLUMNS = [
	{label: 'Ship Name', fieldName: 'Name'},
	{label: 'Blue Containers', fieldName: 'Blue'},
	{label: 'Green Containers', fieldName: 'Green'},
	{label: 'Red Containers', fieldName: 'Red'},
	{label: 'White Containers', fieldName: 'White'},
	{label: 'Yellow Containers', fieldName: 'Yellow'},
	{label: 'Sum Of Assigned Containers', fieldName: 'Containers'}
];

export default class ContainerCounter extends LightningElement {

	columns = COLUMNS;
	@track tableData;
	@track wiredDataTable = [];

	@wire(getContainersCount)
	containerHandler(result) {
		this.wiredDataTable = result;
		this.tableData = [];
		if(result.data) {
			let containerColorsList = {};
			result.data.forEach(function(element) {
				if (!containerColorsList.hasOwnProperty(element.Name)) {
					containerColorsList[element.Name] = {
						'Blue': 0,
						'Green': 0,
						'Red': 0,
						'White': 0,
						'Yellow': 0,
						'Containers': 0,
						'Name': element.Name
					}
				}
				switch(element.Container_Color__c) {
					case 'Blue':
						containerColorsList[element.Name]['Blue'] = element.Containers;
						break;
					case 'Green':
						containerColorsList[element.Name]['Green'] = element.Containers;
						break;
					case 'Red':
						containerColorsList[element.Name]['Red'] = element.Containers;
						break;
					case 'White':
						containerColorsList[element.Name]['White'] = element.Containers;
						break;
					case 'Yellow':
						containerColorsList[element.Name]['Yellow'] = element.Containers;
						break;
				}
				containerColorsList[element.Name]['Containers'] += element.Containers;
			})
			for (let key in containerColorsList) {
				this.tableData.push(
					containerColorsList[key]
				);
			}
		}
		if(result.error) {
			alert(result.error);
			console.log("error", JSON.stringify(result.error));
		}
	}

	refreshTable() {
		refreshApex(this.wiredDataTable);
	}
}
