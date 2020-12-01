import { LightningElement, api } from 'lwc';
import LightningDatatable from 'lightning/datatable';
import caller from'./caller.html';
export default class CjpDatatable extends LightningDatatable {
    static customTypes = {
        caller: {
            template: caller,
            typeAttributes: ['recordId']
        }
    };
}