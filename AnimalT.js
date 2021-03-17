import { LightningElement, wire, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Animal__c.Name';
import SAYS_FIELD from '@salesforce/schema/Animal__c.Says__c';
import EATS_FIELD from '@salesforce/schema/Animal__c.Eats__c';
import EXTERNALID_FIELD from '@salesforce/schema/Animal__c.ExternalId__c';
import saveAnimal from '@salesforce/apex/AnimalController.saveAnimal';

const COLUMNS = [
    { label: 'Name', fieldName: NAME_FIELD.fieldApiName},
    { label: 'Eats', fieldName: EATS_FIELD.fieldApiName, type: 'text' },
    { label: 'Says', fieldName: SAYS_FIELD.fieldApiName, type: 'text' },
    { label: 'External Id', fieldName: EXTERNALID_FIELD.fieldApiName, type: 'text' }
];


export default class AnimalT extends LightningElement {
    @api animals; 
    columns = COLUMNS;

    saveSelected(event) {
        let selectAn = this.template.querySelector('lightning-datatable').getSelectedRows();

        let animalsArray = {
            data: []
        };
        
        if (selectAn.length > 0) {
            for(let i in selectAn) {    
                let item = selectAn[i];   
                animalsArray.data.push({ 
                    "Name" : item.Name,
                    "Eats"  : item.Eats__c,
                    "Says"       : item.Says__c,
                    "ExternalId" : item.ExternalId__c
                });
            } 
    
            saveAnimal({
                jsonInput: JSON.stringify(animalsArray)
            })
                .then(res => {
                    const evt = new ShowToastEvent({
                        title: "Sucsess!",
                        message:  res,
                        variant: 'success'
                    });
                    this.dispatchEvent(evt);
                })
                .catch(error => {
                    const evt = new ShowToastEvent({
                        title: "Error!",
                        message: 'Can not save',
                        variant: 'error'
                    });
                    this.dispatchEvent(evt);
                }); 
        }        
    }
}