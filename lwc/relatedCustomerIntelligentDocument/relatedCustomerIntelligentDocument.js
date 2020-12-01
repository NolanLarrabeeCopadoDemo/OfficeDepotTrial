import { LightningElement, wire, api, track } from 'lwc';
import getRelatedCID from '@salesforce/apex/RelatedCustomerIntelligentDocumentCtrl.getRelatedCID';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Hierarchy_FIELD from '@salesforce/schema/Account.Hierarchy__c';

const actions = [
    { label: 'Modify', name: 'Modify' },
];
const columns = [
    
    { label: 'Name', fieldName: 'Name__c' },
    { label: 'Account Type', fieldName: 'Account_Type__c' },
    { label: 'Cust must clear credit prior to rebill', fieldName: 'Custmustclearcreditpriortorebill__c' },
    { label: 'Can Customer Care Maintain Account?', fieldName: 'Can_Customer_Care_Maintain_Account__c' },
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
    
];
const fields = [Hierarchy_FIELD];
export default class RelatedCustomerIntelligentDocument extends LightningElement {
    columns = columns;
    data = [];
    @api recordId;
    @track bShowModal=false;
    @track disableNew = false;
    record = {};
    parentRecord = {};
    gpRecord = {};
    ggpRecord = {};
    initRecord = {
        "Can_Customer_Care_Maintain_Account__c":"",
        "Can_Restrictions_Be_Overridden_Without_A__c":"",
        "Custmustclearcreditpriortorebill__c":"",
        "EDI_Customer_Email__c":"",
        "EDI_Customer_Name__c":"",
        "EDI_Customer_Phone__c":"",
        "Proprietary_Flag__c":"",
        "Special_Instructions__c":"",
        "What_Can_Be_Done_To_Maintain_Account__c":"",
        "EDI_Exceptions_Email__c":"",
        "EDI_Exceptions_Name__c":"",
        "EDI_Exceptions_Phone__c":"",
        "EDI_Restrictions__c":"",
        "Forms_of_Order_Entry__c":"",
        "MISC__c":"",
        "Ordering_Platform__c":"",
        "Price_Match__c":"",
        "Price_Variance__c":"",
        "Account__c":"",
        "Additional_Account_Handling_Comments__c":""
    };

    @wire(getRecord, { recordId: '$recordId', fields })
    account;
 
    get recordTypeName() {
        return getFieldValue(this.account.data, Hierarchy_FIELD);
    }

    @wire(getRelatedCID, {recId: '$recordId'})
    getRelatedCID({ error, data }) {
       if (data) {
           let result = [];
           if(data && data.length >0){
                for(var i=0;i<data.length;i++){
                    result.push({
                        id: data[i].Id,
                        Name__c:data[i].Name__c,
                        Custmustclearcreditpriortorebill__c:data[i].Custmustclearcreditpriortorebill__c,
                        Can_Customer_Care_Maintain_Account__c:data[i].Can_Customer_Care_Maintain_Account__c,
                        LastModifiedDate:data[i].LastModifiedDate,
                        Account_Type__c:data[i].Account_Type__c
                    });
                }

                for(var j=0;j<data.length;j++){
                    if(data[j].Account_Type__c === this.recordTypeName){
                        this.disableNew = true;
                    }
                    if(data[j].Account_Type__c === 'P'){
                        this.parentRecord = data[j];
                    }
                    if(data[j].Account_Type__c === 'GP'){ 
                        this.gpRecord = data[j];
                    }
                    if(data[j].Account_Type__c === 'GG'){ 
                        this.ggpRecord = data[j];
                    }
                }
           }
           console.log(this.recordTypeName);
           if(this.recordTypeName === 'C'){ //C = Customer
            if(Object.keys(this.parentRecord).length === 0 && this.parentRecord.constructor === Object){
                if(Object.keys(this.gpRecord).length === 0 && this.gpRecord.constructor === Object){
                    if(Object.keys(this.ggpRecord).length === 0 && this.ggpRecord.constructor === Object){
                        this.record = this.initRecord;
                    }else{
                        this.record = this.ggpRecord;
                    }
                }else{
                    this.record = this.gpRecord;
                }
            }else{
                this.record = this.parentRecord;
            }
           }else if(this.recordTypeName === 'P'){ //P = Parent
            if(Object.keys(this.gpRecord).length === 0 && this.gpRecord.constructor === Object){
                if(Object.keys(this.ggpRecord).length === 0 && this.ggpRecord.constructor === Object){
                    this.record = this.initRecord;
                }else{
                    this.record = this.ggpRecord;
                }
            }else{
                this.record = this.gpRecord;
            }           
           }else if(this.recordTypeName === 'GP'){ //GP = GrandParent
            if(Object.keys(this.ggpRecord).length === 0 && this.ggpRecord.constructor === Object){
                this.record = this.initRecord;
            }else{
                this.record = this.ggpRecord;
            }
           }else{
             this.record = this.initRecord;
           }
           console.log('record=>',this.record);
           this.data = result;
       } else if (error) {
           console.log('error: ' +  JSON.stringify(error, null, 4));
       }
    }

     // Row Action event to show the details of the record
     handleNewClick(event) {
        
        this.bShowModal = true; // display modal window
    }
 
    // to close modal window set 'bShowModal' tarck value as false
    closeModal() {
        this.bShowModal = false;
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Saved successfully",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.bShowModal = false;
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        fields.Account__c = this.recordId;
        //alert('Sumbit');
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'Modify':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    showRowDetails(row) {
        //this.record = row;
        window.open( "/"+row.id, "_blank"); 
    
    }    
}