import { LightningElement,track, wire } from 'lwc';
import getApproveRejectData from '@salesforce/apex/ApproveRejectProspectController.getApproveRejectData';
import processRecords from '@salesforce/apex/ApproveRejectProspectController.ProcessRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ApprovalRequests extends LightningElement {
    showapproval = true;
    @track isLoaded = false;
    @track typeofView =  [{ label:'My Approvals', value:'My Approvals'},{ label:'My Requests', value:'My Requests'}];
    value = 'My Approvals';
    @track columns = [
        { label: 'Account', fieldName: 'Account__c' },
        { label: 'Status', fieldName: 'Status__c', type: 'text' },
        { label: 'Approver', fieldName: 'Approver__c', type: 'text' },
        { label: 'Requestor', fieldName: 'Requestor__c', type: 'text' },
        { label: 'New Owner', fieldName: 'New_Owner__c', type: 'text' },
    ];
    data = [];
    reassignData;
    showError = false;
    ReportLink='';
    

    @wire(getApproveRejectData, { type: '$value' })
    wiredApproveRejectData({ error, data }) { 
        this.isLoaded = true;     
        if (data) {
            //let temp = data;             
            let tempdata = [];                                   
            for (let i = 0; i < data.length; i++) {              
                tempdata.push({ 'id' : data[i].id,
                                'Account__c'  : (data[i].Reassignment_Queue.Account__c != undefined) ? data[i].Reassignment_Queue.Account__r.Name:'', 
								'Status__c'   : data[i].Reassignment_Queue.Status__c,
								'Approver__c' : (data[i].Reassignment_Queue.Approver__c != undefined) ? data[i].Reassignment_Queue.Approver__r.Name:'',
								'Requestor__c': (data[i].Reassignment_Queue.Requestor__c != undefined) ? data[i].Reassignment_Queue.Requestor__r.Name:'',
								'New_Owner__c': (data[i].Reassignment_Queue.New_Owner__c != undefined) ? data[i].Reassignment_Queue.New_Owner__r.Name:''
							});
              }               
              this.data = tempdata;          
              //this.showapproval = true;
              this.isLoaded = false;
        }
        else if (error) { 
            this.isLoaded = false;
        }   
    }

    handleChange(event) {
        let v = event.detail.value;
        this.value = v;      
        if(v == 'My Approvals'){
            this.showapproval = true;
        }else{
            this.showapproval = false;
        }
    }

    handleApproveClick(event){
        this.isLoaded = true;
        processRecords({ process: 'A', reassigndata: JSON.stringify(this.reassignData)})
        .then(result => {
           //alert('Inside2');
            let data = result.data;
            let tempdata = [];                                   
            for (let i = 0; i < data.length; i++) {              
                tempdata.push({ 'id' : data[i].id,
                                'Account__c'  : (data[i].Reassignment_Queue.Account__c != undefined) ? data[i].Reassignment_Queue.Account__r.Name:'', 
								'Status__c'   : data[i].Reassignment_Queue.Status__c,
								'Approver__c' : (data[i].Reassignment_Queue.Approver__c != undefined) ? data[i].Reassignment_Queue.Approver__r.Name:'',
								'Requestor__c': (data[i].Reassignment_Queue.Requestor__c != undefined) ? data[i].Reassignment_Queue.Requestor__r.Name:'',
								'New_Owner__c': (data[i].Reassignment_Queue.New_Owner__c != undefined) ? data[i].Reassignment_Queue.New_Owner__r.Name:''
							});
              }  
            this.data = tempdata;
            this.isLoaded = false;
            this.showError =result.error;
            this.ReportLink =result.reportLink;
            if(result.error){
                this.showToastMessage('Error', 'Operation is unsucessful.','error');
            }else{
                this.showToastMessage('Success', 'Operation completed sucessfully.','success');
            }
            
        })
        .catch(error => {
            //this.error = error;
            this.isLoaded = false;
            this.showToastMessage('Error', 'Something went wrong.','error');
        });
    }

    handleRejectClick(event){
        this.isLoaded = true;
        processRecords({ process: 'R', reassigndata: JSON.stringify(this.reassignData)})
        .then(result => {
            let data = result.data;
            let tempdata = [];                                   
            for (let i = 0; i < data.length; i++) {              
                tempdata.push({ 'id' : data[i].id,
                                'Account__c'  : (data[i].Reassignment_Queue.Account__c != undefined) ? data[i].Reassignment_Queue.Account__r.Name:'', 
								'Status__c'   : data[i].Reassignment_Queue.Status__c,
								'Approver__c' : (data[i].Reassignment_Queue.Approver__c != undefined) ? data[i].Reassignment_Queue.Approver__r.Name:'',
								'Requestor__c': (data[i].Reassignment_Queue.Requestor__c != undefined) ? data[i].Reassignment_Queue.Requestor__r.Name:'',
								'New_Owner__c': (data[i].Reassignment_Queue.New_Owner__c != undefined) ? data[i].Reassignment_Queue.New_Owner__r.Name:''
							});
              }  
            this.data = tempdata;
            this.isLoaded = false;
            if(result.error){
                this.showToastMessage('Error', 'Operation is unsucessful.','error');
            }else{
                this.showToastMessage('Success', 'Operation completed sucessfully.','success');
            }
        })
        .catch(error => {
            //this.error = error;
            this.isLoaded = false;
            this.showToastMessage('Error', 'Something went wrong.','error');
        });
    }

    handleCancelClick(event){
        this.isLoaded = true;
        processRecords({ process: 'C', reassigndata: JSON.stringify(this.reassignData)})
        .then(result => {
            let data = result.data;
            let tempdata = [];                                   
            for (let i = 0; i < data.length; i++) {              
                tempdata.push({ 'id' : data[i].id,
                                'Account__c'  : (data[i].Reassignment_Queue.Account__c != undefined) ? data[i].Reassignment_Queue.Account__r.Name:'', 
								'Status__c'   : data[i].Reassignment_Queue.Status__c,
								'Approver__c' : (data[i].Reassignment_Queue.Approver__c != undefined) ? data[i].Reassignment_Queue.Approver__r.Name:'',
								'Requestor__c': (data[i].Reassignment_Queue.Requestor__c != undefined) ? data[i].Reassignment_Queue.Requestor__r.Name:'',
								'New_Owner__c': (data[i].Reassignment_Queue.New_Owner__c != undefined) ? data[i].Reassignment_Queue.New_Owner__r.Name:''
							});
              }  
            this.data = tempdata;
            this.isLoaded = false;
            if(result.error){
                this.showToastMessage('Error', 'Operation is unsucessful.','error');
            }else{
                this.showToastMessage('Success', 'Operation completed sucessfully.','success');
            }
        })
        .catch(error => {
            //this.error = error;
            this.isLoaded = false;
            this.showToastMessage('Error', 'Something went wrong.','error');
        });
    }

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        this.reassignData = selectedRows;        
    }

    showToastMessage(t, m, v){
        const event = new ShowToastEvent({
            title: t,
            message: m,
            variant: v
        });
        this.dispatchEvent(event);
    }
}