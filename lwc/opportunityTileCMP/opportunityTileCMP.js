import { LightningElement,api,track,wire } from 'lwc';

import { refreshApex } from '@salesforce/apex';
import { getListUi } from 'lightning/uiListApi';
import Opportunity_Object from '@salesforce/schema/Opportunity';

const columns = [
    { label:  'Name',fieldName:'Name', type: 'string', sortable: true, cellAttributes: { alignment: 'left' },wrapText: true, initialWidth:"auto"},
    { label: 'Stage',fieldName:'StageName', type: 'string', sortable: true, cellAttributes: { alignment: 'left' },initialWidth:"auto"},
    { label: 'Opp Amount',fieldName:'OppAmt', type: 'number', sortable: true, cellAttributes: { alignment: 'left' },initialWidth:"auto"},
    { label: 'Close Date',fieldName:'CloseDate', type: "string",cellAttributes: { alignment: 'left'},initialWidth:"auto"},
    
];

export default class CustomSearchInLWC extends LightningElement {
    @track data;
    @track noPrevious;
    @track noNext;
    @track OppDetails = [];
    @track strSearchProdName = '';
    result;
//this is initialize for 1st page
    @track page = 1; 
//it contains all the Product records.
    @track items = [];
//To display the data into datatable 
    @track data = [];
//holds column info. 
    @track columns;
//start record position per page 
    @track startingRecord = 1; 
//end record position per page
    @track endingRecord = 0; 
//10 records display per page
    @track pageSize = 10; 
//total count of record received from all retrieved records
    @track totalRecountCount = 0;
//total number of page is needed to display all records 
    @track totalPage = 0; 
//To display the column into the data table
    @track columns = columns;

//call the apex method and pass the search string into apex method.
@wire(getListUi,{ objectApiName: Opportunity_Object, listViewApiName: 'OpportunityTileView' })
wiredGetOppNames({error,data }) {
        if (data) {
            console.log('test-->'+JSON.stringify(data.records.records));
            for(let i =0; i<data.records.records.length; i++)
            {
                let newEntry = {"Name" : data.records.records[i].fields.Name.value , "StageName" : data.records.records[i].fields.StageName.value , "OppAmt" : data.records.records[i].fields.Opportunity_Amount__c.value , "CloseDate" : data.records.records[i].fields.CloseDate.value}
                this.OppDetails.push(newEntry);
                
            }

            this.data = this.OppDetails;
            this.items = this.data;
            this.totalRecountCount = this.data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
//initial data to be displayed ----------->
//slice will take 0th element and ends with 10, but it doesn't include 10th element
//so 0 to 9th rows will be displayed in the table
            this.data = this.items.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;

            this.error = undefined;
            this.noPrevious = true;
          } else if (error) {
            this.error = error;
            this.data = undefined;
          }
       }
//this method is called when you clicked on the previous button 
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
            this.noPrevious = false;
            this.noNext = false;
            if(this.page == 1)
                this.noPrevious = true;
            
        }
        else
        {
            this.noNext = false;
            this.noPrevious = true;
        }
            
    }
//this method is called when you clicked on the next button 
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);       
            this.noNext = false;
            this.noPrevious = false;  
            if(this.page == this.totalPage)
                this.noNext = true;   
        }
        else
        {
            this.noPrevious = false;
            this.noNext = true;
        }
                         
    }
//this method displays records page by page
    displayRecordPerPage(page){
    this.startingRecord = ((page -1) * this.pageSize) ;
    this.endingRecord = (this.pageSize * page);
    this.endingRecord = 
 (this.endingRecord > this.totalRecountCount) ?   this.totalRecountCount : this.endingRecord; 
 this.data = this.items.slice(this.startingRecord,   this.endingRecord);
 this.startingRecord = this.startingRecord + 1;
 }    
  
   handleProductName(event) {
       this.strSearchProdName = event.target.value;
       return refreshApex(this.result);
   }   
 /* eslint-disable no-console */
 // eslint-disable-next-line no-console
//this method holds the selected product.
   handleConfig(){
   var el = this.template.querySelector('lightning-datatable');
   var selected = el.getSelectedRows();
}
}