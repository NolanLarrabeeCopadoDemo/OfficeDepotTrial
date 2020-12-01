import { LightningElement,wire,track } from 'lwc';
import getSearchData from '@salesforce/apex/AssignmentProspectController.Search';
import reassign from '@salesforce/apex/AssignmentProspectController.Reassign'; 
import reassignall from '@salesforce/apex/AssignmentProspectController.ReassignAll';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AssignmentProspect extends LightningElement {
    customerName='';
    customerNumber='';
    odEmpID='';
    zipCodes='';
    salesRepName='';
    industry='';
    WCWRangeValue='';
    state='';
    salesPersonId='';
    proposedPersonId='';
    newsalesPersonlId='';
    @track columns = [
        { label: 'Prospect Number', fieldName: 'Account_Number__c' },
        { label: 'Prospect Name', fieldName: 'Name', type: 'text' },
        { label: 'Sales Person Name', fieldName: 'owner', type: 'text' },
        { label: 'Sales Person ID', fieldName: 'Sales_PersonID__c', type: 'text' },
        { label: 'Industry', fieldName: 'Industry_OD_SIC_Rep__c', type: 'text' },
        { label: 'WCW', fieldName: 'Org_WCW_Count_Rep__c', type: 'text' },
        { label: 'PostalCode', fieldName: 'Zip__c', type: 'text' },
        { label: 'Prospect Status', fieldName: 'Status__c', type: 'text' },
        { label: 'Assignment Queue Status', fieldName: 'Assignment_Status__c', type: 'text' },
        { label: 'Proposed Sales Rep', fieldName: 'New_Owner__c', type: 'text' },
        { label: 'Approver', fieldName: 'Approver__c', type: 'text' }
    ];
    data = [];
    @track isLoaded = false;
    @track showResult = false;
    v_Offset=0;
    v_TotalRecords;
    page_size = 100;
    reassignData;
    countPage=0;
    currentPage=0;

    get options() {
        return [
            { label: '--None--', value: '' },
            { label: '1-19', value: '1-19' },
            { label: '20-49', value: '20-49' },
            { label: '50-99', value: '50-99' },
            { label: '100-149', value: '100-149' },
            { label: '150-199', value: '150-199' },
            { label: '200-249', value: '200-249' },
            { label: '250-500', value: '250-500' },
            { label: '500+', value: '500+' },
        ];
    }
    
    handleSearchClick(event){     
        if(this.customerName =='' && this.customerNumber =='' && this.odEmpID=='' &&
           this.zipCodes =='' && this.salesRepName =='' && this.industry=='' && this.WCWRangeValue=='' &&
           this.state == '' && this.salesPersonId=='' && this.proposedPersonId ==''){
            this.showToastMessage('Message','Atleast one field should be entered.','info');
        }else{
            this.isLoaded = true;
            this.v_Offset = 0;
            this.showResult = false;
            getSearchData({ customerName: this.customerName, customerNumber: this.customerNumber,
                odEmpID: this.odEmpID, zipCodes: this.zipCodes,salesRepName:this.salesRepName,
                industry:this.industry, WCWRangeValue:this.WCWRangeValue, state:this.state,
                salesPersonId:this.salesPersonId,   proposedPersonId:this.proposedPersonId, offset:this.v_Offset})
            .then(result => {
               let data = result.reassigndata;
               let tempdata = [];                                   
               for (let i = 0; i < data.length; i++) {              
                   tempdata.push({ 'id' : data[i].act.Id,
                                   'Name':data[i].act.Name,
                                   'Account_Number__c': data[i].act.Account_Number__c,
                                   'Sales_PersonID__c'  : (data[i].act.Sales_PersonID__r != undefined) ? data[i].act.Sales_PersonID__r.Name:'',                                
                                   'Owner' : (data[i].act.Owner != undefined) ? data[i].act.Owner.Name:'',
                                   'Industry_OD_SIC_Rep__c': data[i].act.Industry_OD_SIC_Rep__c,                              
                                   'Org_WCW_Count_Rep__c': data[i].act.Org_WCW_Count_Rep__c,
                                   'Zip__c': data[i].act.Zip__c,
                                   'Status__c'   : data[i].act.Status__c,
                                   'Assignment_Status__c': (data[i].act.Assignment_Status__c != undefined) ? data[i].act.Assignment_Status__r.Status__c:'',                              
                                   'New_Owner__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.New_Owner__c !=undefined) ? data[i].act.Assignment_Status__r.New_Owner__r.Name:'',
                                   'Approver__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.Approver__c != undefined) ? data[i].act.Assignment_Status__r.Approver__r.Name:''
                               });
                 }               
                 this.data = tempdata;
                 this.v_TotalRecords = result.totalSearchRows;
                 
                 this.countPage = Math.ceil(this.v_TotalRecords / this.page_size);
                 this.currentPage = Math.ceil(this.v_Offset / this.page_size)+1;
                 if(this.v_TotalRecords >= this.page_size){
                    this.v_Offset = this.page_size;
                 }
                 
                 if(tempdata.length >0){
                    this.showResult = true;
                 }          
                 this.isLoaded = false;
            })
            .catch(error => {
                this.isLoaded = false;
            });
        }        
    }
    handleAssigneSelectedClick(event){
        if(this.newsalesPersonlId == ''){
            this.showToastMessage('Message','Please select New Sales Person.','info');
        }else{
            this.isLoaded = true;
            this.showResult = false;
            reassign({ customerName: this.customerName, customerNumber: this.customerNumber,
                odEmpID: this.odEmpID, zipCodes: this.zipCodes,salesRepName:this.salesRepName,
                industry:this.industry, WCWRangeValue:this.WCWRangeValue, state:this.state,
                salesPersonId:this.salesPersonId,   proposedPersonId:this.proposedPersonId,
                newsalesPersonlId:this.newsalesPersonlId, ReassignData:JSON.stringify(this.reassignData), offset:this.v_Offset})
            .then(result => {
               let data = result.reassigndata;
               this.v_TotalRecords = result.totalSearchRows;
               let tempdata = [];                                   
               for (let i = 0; i < data.length; i++) {              
                   tempdata.push({ 'id' : data[i].act.Id,
                                   'Name':data[i].act.Name,
                                   'Account_Number__c': data[i].act.Account_Number__c,
                                   'Sales_PersonID__c'  : (data[i].act.Sales_PersonID__r != undefined) ? data[i].act.Sales_PersonID__r.Name:'',                                
                                   'Owner' : (data[i].act.Owner != undefined) ? data[i].act.Owner.Name:'',
                                   'Industry_OD_SIC_Rep__c': data[i].act.Industry_OD_SIC_Rep__c,                              
                                   'Org_WCW_Count_Rep__c': data[i].act.Org_WCW_Count_Rep__c,
                                   'Zip__c': data[i].act.Zip__c,
                                   'Status__c'   : data[i].act.Status__c,
                                   'Assignment_Status__c': (data[i].act.Assignment_Status__c != undefined) ? data[i].act.Assignment_Status__r.Status__c:'',                               
                                   'New_Owner__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.New_Owner__c !=undefined) ? data[i].act.Assignment_Status__r.New_Owner__r.Name:'',
                                   'Approver__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.Approver__c != undefined) ? data[i].act.Assignment_Status__r.Approver__r.Name:''
                               });
                 }               
                 this.data = tempdata;
                 if(tempdata.length >0){
                    this.showResult = true;
                 }
                 this.countPage = Math.ceil(this.v_TotalRecords / this.page_size);
                 this.currentPage = Math.ceil(this.v_Offset / this.page_size)+1;
                          
                 this.isLoaded = false;
                 this.showToastMessage('Message',result.message,'info');
            })
            .catch(error => {
                this.isLoaded = false;
                this.showToastMessage('Error',error.body.message,'error');
            });
        }      
    }

    handleAssigneAllClick(event){
        if(this.newsalesPersonlId == ''){
            this.showToastMessage('Message','Please select New Sales Person.','info');
        }else{
            this.isLoaded = true;
            this.showResult = false;
            reassignall({ customerName: this.customerName, customerNumber: this.customerNumber,
                odEmpID: this.odEmpID, zipCodes: this.zipCodes,salesRepName:this.salesRepName,
                industry:this.industry, WCWRangeValue:this.WCWRangeValue, state:this.state,
                salesPersonId:this.salesPersonId,   proposedPersonId:this.proposedPersonId,
                newsalesPersonlId:this.newsalesPersonlId, offset:this.v_Offset})
            .then(result => {
            let data = result.reassigndata;
            this.v_TotalRecords = result.totalSearchRows;
            let tempdata = [];                                   
            for (let i = 0; i < data.length; i++) {              
                tempdata.push({ 'id' : data[i].act.Id,
                                'Name':data[i].act.Name,
                                'Account_Number__c': data[i].act.Account_Number__c,
                                'Sales_PersonID__c'  : (data[i].act.Sales_PersonID__r != undefined) ? data[i].act.Sales_PersonID__r.Name:'',                                
                                'Owner' : (data[i].act.Owner != undefined) ? data[i].act.Owner.Name:'',
                                'Industry_OD_SIC_Rep__c': data[i].act.Industry_OD_SIC_Rep__c,                              
                                'Org_WCW_Count_Rep__c': data[i].act.Org_WCW_Count_Rep__c,
                                'Zip__c': data[i].act.Zip__c,
                                'Status__c'   : data[i].act.Status__c,
                                'Assignment_Status__c': (data[i].act.Assignment_Status__c != undefined) ? data[i].act.Assignment_Status__r.Status__c:'',                               
                                'New_Owner__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.New_Owner__c !=undefined) ? data[i].act.Assignment_Status__r.New_Owner__r.Name:'',
                                'Approver__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.Approver__c != undefined) ? data[i].act.Assignment_Status__r.Approver__r.Name:''
                            });
                }               
                this.data = tempdata;
                if(tempdata.length >0){
                    this.showResult = true;
                }
                this.countPage = Math.ceil(this.v_TotalRecords / this.page_size);
                this.currentPage = Math.ceil(this.v_Offset / this.page_size)+1;
                         
                this.isLoaded = false;
                this.showToastMessage('Message',result.message,'info');
            })
            .catch(error => {
                this.isLoaded = false;
                this.showToastMessage('Error',error.body.message,'error');
            });
        }
    }
    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        this.reassignData = selectedRows;        
    }

    handleCustomerNameChange(event){
        this.customerName = event.detail.value;
    }
    handleCustomerNumberChange(event){
        this.customerNumber = event.detail.value;
    }
    handleODEmpIDChange(event){
        this.odEmpID = event.detail.value;
    }
    handleZipCodesChange(event){
        this.zipCodes = event.detail.value;
    }
    handleSalesRepNameChange(event){
        this.salesRepName = event.detail.value;
    }

    handleWCWRangeChange(event){
        this.WCWRangeValue = event.detail.value;
    }

    showToastMessage(t, m, v){
        const event = new ShowToastEvent({
            title: t,
            message: m,
            variant: v
        });
        this.dispatchEvent(event);
    }

    handleStateChange(event) {
        this.state = event.detail.selectedValue;
        event.stopPropagation();
    }

    handleIndustryChange(event) {
        this.industry = event.detail.selectedValue;
        event.stopPropagation();
    }

    handleSalesPersonChange(event){
        this.salesPersonId = event.detail.recordId;
        event.stopPropagation();              
    }

    handleProposedPersonChange(event){
        this.proposedPersonId = event.detail.recordId;
        event.stopPropagation();
    }

    handleNewSalesPersonlChange(event){
        this.newsalesPersonlId = event.detail.recordId;
        event.stopPropagation();
    }

        
    previousHandler2(){
        if(this.countPage === this.currentPage){this.v_Offset=this.v_Offset-this.page_size}
        if(this.v_Offset >= 0){            
            this.isLoaded = true;
            getSearchData({ customerName: this.customerName, customerNumber: this.customerNumber,
                odEmpID: this.odEmpID, zipCodes: this.zipCodes,salesRepName:this.salesRepName,
                industry:this.industry, WCWRangeValue:this.WCWRangeValue, state:this.state,
                salesPersonId:this.salesPersonId,   proposedPersonId:this.proposedPersonId, offset:this.v_Offset})
            .then(result=>{
                let data = result.reassigndata;
                let tempdata = [];                                   
                for (let i = 0; i < data.length; i++) {              
                    tempdata.push({ 'id' : data[i].act.Id,
                                    'Name':data[i].act.Name,
                                    'Account_Number__c': data[i].act.Account_Number__c,
                                    'Sales_PersonID__c'  : (data[i].act.Sales_PersonID__r != undefined) ? data[i].act.Sales_PersonID__r.Name:'',                                
                                    'Owner' : (data[i].act.Owner != undefined) ? data[i].act.Owner.Name:'',
                                    'Industry_OD_SIC_Rep__c': data[i].act.Industry_OD_SIC_Rep__c,                              
                                    'Org_WCW_Count_Rep__c': data[i].act.Org_WCW_Count_Rep__c,
                                    'Zip__c': data[i].act.Zip__c,
                                    'Status__c'   : data[i].act.Status__c,
                                    'Assignment_Status__c': (data[i].act.Assignment_Status__c != undefined) ? data[i].act.Assignment_Status__r.Status__c:'',                               
                                    'New_Owner__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.New_Owner__c !=undefined) ? data[i].act.Assignment_Status__r.New_Owner__r.Name:'',
                                    'Approver__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.Approver__c != undefined) ? data[i].act.Assignment_Status__r.Approver__r.Name:''
                                });
                    }               
                this.data = tempdata;
                if(tempdata.length >0){
                    this.showResult = true;
                }
                this.countPage = Math.ceil(this.v_TotalRecords / this.page_size);
                this.currentPage = Math.ceil(this.v_Offset / this.page_size)+1;          
                if( this.v_Offset > 0){
                    this.v_Offset =  this.v_Offset - this.page_size;
                }                         
                if(this.v_Offset === 0){
                   // this.template.querySelector('c-pagination').changeView('trueprevious');
                }else{
                   // this.template.querySelector('c-pagination').changeView('falsenext');
                }
                this.isLoaded = false;
            });
        }
    }

    nextHandler2(){
        if(this.currentPage ===1 && this.v_Offset===0){this.v_Offset=this.v_Offset+this.page_size}
        //if(this.v_Offset >= 0){}
        this.isLoaded = true;
        getSearchData({ customerName: this.customerName, customerNumber: this.customerNumber,
            odEmpID: this.odEmpID, zipCodes: this.zipCodes,salesRepName:this.salesRepName,
            industry:this.industry, WCWRangeValue:this.WCWRangeValue, state:this.state,
            salesPersonId:this.salesPersonId,   proposedPersonId:this.proposedPersonId, offset:this.v_Offset})
        .then(result=>{
            let data = result.reassigndata;
            let tempdata = [];                                   
            for (let i = 0; i < data.length; i++) {              
                tempdata.push({ 'id' : data[i].act.Id,
                                'Name':data[i].act.Name,
                                'Account_Number__c': data[i].act.Account_Number__c,
                                'Sales_PersonID__c'  : (data[i].act.Sales_PersonID__r != undefined) ? data[i].act.Sales_PersonID__r.Name:'',                                
                                'Owner' : (data[i].act.Owner != undefined) ? data[i].act.Owner.Name:'',
                                'Industry_OD_SIC_Rep__c': data[i].act.Industry_OD_SIC_Rep__c,                              
                                'Org_WCW_Count_Rep__c': data[i].act.Org_WCW_Count_Rep__c,
                                'Zip__c': data[i].act.Zip__c,
                                'Status__c'   : data[i].act.Status__c,
                                'Assignment_Status__c': (data[i].act.Assignment_Status__c != undefined) ? data[i].act.Assignment_Status__r.Status__c:'',                               
                                'New_Owner__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.New_Owner__c !=undefined) ? data[i].act.Assignment_Status__r.New_Owner__r.Name:'',
                                'Approver__c': (data[i].act.Assignment_Status__c != undefined && data[i].act.Assignment_Status__r.Approver__c != undefined) ? data[i].act.Assignment_Status__r.Approver__r.Name:''
                            });
                }               
            this.data = tempdata;
            if(tempdata.length >0){
                this.showResult = true;
            } 
            this.countPage = Math.ceil(this.v_TotalRecords / this.page_size);
            this.currentPage = Math.ceil(this.v_Offset / this.page_size)+1;         
            if(tempdata.length === this.page_size){
                this.v_Offset =  this.v_Offset + this.page_size; 
            }           
            if(this.v_Offset + 100 > this.v_TotalRecords){
                //this.template.querySelector('c-pagination').changeView('truenext');
            }else{
               // this.template.querySelector('c-pagination').changeView('falseprevious');
            }
            this.isLoaded = false;
        });
    }

    changeHandler2(event){
        //const det = event.detail;
        //this.page_size = det;
    }

    firstpagehandler(){
        this.v_Offset = 0;
        //this.template.querySelector('c-pagination').changeView('trueprevious');
        //this.template.querySelector('c-pagination').changeView('falsenext');
    }

    lastpagehandler(){
        this.v_Offset = this.v_TotalRecords - (this.v_TotalRecords)%(this.page_size);
        //this.template.querySelector('c-pagination').changeView('falseprevious');
        //this.template.querySelector('c-pagination').changeView('truenext');
    }
}