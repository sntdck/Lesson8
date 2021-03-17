import { LightningElement, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAnimal from '@salesforce/apex/AnimalController.getAnimal';
export default class GetAnimalComponent extends LightningElement {

    @track startId;
    @track endId;
    @api receivedData;

    changeHandler(even) {
        if (even.target.name == 'startId') {
            this.startId = even.target.value;
        } else if (even.target.name == 'endId') {
            this.endId = even.target.value;
        }
    }

    handleClick(even) {
        if (this.startId > 0 && this.endId > 0) {
            getAnimal({
                startId: this.startId,
                endId: this.endId
            })
                .then(res => {
                    this.receivedData = res;
                })
                .catch(error => {
                    const evt = new ShowToastEvent({
                        title: "Error!",
                        message: 'Didnt have animal',
                        variant: 'error'
                    });
                    this.dispatchEvent(evt);
                });
        }
    }
}