import { LightningElement, wire, track, api } from 'lwc';
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

    @wire(getContainersCount)
    containerHandler(result) {
        this.tableData = [];
        if(result.data) {
            var containerColorsList = {};
			result.data.forEach(function(element) {
                if (!(element.Name in containerColorsList)) {
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
                
                if (element.Container_Color__c == 'Blue') {
                    containerColorsList[element.Name]['Blue'] = element.Containers;
                }
                if (element.Container_Color__c == 'Green') {
                    containerColorsList[element.Name]['Green'] = element.Containers;
                }
                if (element.Container_Color__c == 'Red') {
                    containerColorsList[element.Name]['Red'] = element.Containers;
                }
                if (element.Container_Color__c == 'White') {
                    containerColorsList[element.Name]['White'] = element.Containers;
                }
                if (element.Container_Color__c == 'Yellow') {
                    containerColorsList[element.Name]['Yellow'] = element.Containers;
                }
                containerColorsList[element.Name]['Containers'] += element.Containers;
            })
            for (var key in containerColorsList) {
                this.tableData.push(
                    containerColorsList[key]
                );
            }

            console.log("tableData", this.tableData);
            
		}
		if(result.error) {
			alert(result.error);
			console.log("error", JSON.stringify(result.error));
		}
    }
}