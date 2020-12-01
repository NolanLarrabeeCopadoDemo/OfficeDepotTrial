/* eslint-disable @lwc/lwc/valid-wire */
/* eslint-disable no-irregular-whitespace */
/* eslint-disable no-alert */
/* eslint-disable no-unused-vars */
/* eslint-disable no-mixed-spaces-and-tabs */
/* eslint-disable no-console */
import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getQuoteOrderInfo from '@salesforce/apex/OrderCreation.getQuoteOrderInfo';
import PlaceOrderCallout from '@salesforce/apex/OrderCreation.placeOrder';
import PlaceManualOrder from '@salesforce/apex/OrderCreation.placeOrder';
import backToQuote from '@salesforce/apex/OrderCreation.placeOrder';



let selectedIdsArray = [];

export default class ordersList extends  NavigationMixin (LightningElement) {
    @track data;
    @track quoteName;
    @track opportunityName;
    @track accountName;
    @track url;
    @track openmodel = false;
    @api orderList = [];
    modifiedOrderList = [];
    @track isErrorExist;
    @track errorMessage;
    @track showSpinner = false;
    @track isAutomaticOrder;
    @track isManualOrder;

    openmodal() {
        this.openmodel = true
    }
    closeModal() {
        this.openmodel = false
    } 
    saveMethod() {
        alert('save method invoked');
        this.closeModal();
    }

    
   
   
    @wire(CurrentPageReference) pageRef;
    @api quoteId;

    


    @wire(getQuoteOrderInfo, { quoteId: '$quoteId'}) wiredOrders ({ error, data }) {

        var search = location.search.substring(1);
        this.quoteId = search.split('=')[1];       

        if(data) {
            
            this.data = [];
            this.orderList = [];
            this.quoteName = data.quoteHeader.quoteName;
            this.opportunityName = data.quoteHeader.opportunityName;
            this.accountName = data.quoteHeader.accountName;
            this.isErrorExist = data.isErrorExist;
            this.errorMessage = data.errorMessage;
            this.showSpinner = false;
            this.isManualOrder = data.isManualOrder;
            this.isAutomaticOrder = data.isAutomaticOrder;

			for (let order of data.custOrderList)
			{
                this.orderList.push(order);
            }            
        }
        
    }

    handleBackToQuote(evt) {
        //window.parent.close();
        window.location.href = "/lightning/r/Quote/"+this.quoteId+"/view";
    }

    
    handlePlaceOrder(evt) {
        /*for (let order of this.orderList)
        {
            alert(JSON.stringify(order));
        }*/
        this.showSpinner = true;
        
        PlaceOrderCallout({orderListJson: JSON.stringify((this.orderList)), orderType : 'automatic' })
        .then(result => {
            alert('Orders were placed successfully!');
            
            window.location.href = "/lightning/r/Quote/"+this.quoteId+"/view";
            
        })
        .catch(error => {
            alert(error.message);
            this.error = error.message;
        });        
    }

    handleManualOrder(evt) {
        PlaceManualOrder({orderListJson: JSON.stringify((this.orderList)), orderType : 'manual'})
        .then(result =>{
            alert('Manual Orders were placed successfully!');
            window.location.href = "/lightning/r/Quote/"+this.quoteId+"/view";
        })
        .catch(error => {
            alert(error.message);
            this.error = error.message;
        });
    }

    
    @api handleNoteChanges(event) {

        let temp_order_list = JSON.parse(JSON.stringify(this.orderList));
        temp_order_list[event.target.name].orderComments = event.target.value;
        this.orderList = temp_order_list;
    }

    handleItemListExpanded() {
        const elements = this.template.querySelectorAll('.example-accordion');
        // eslint-disable-next-line vars-on-top
        for (var i=0; i<elements.length; i++) {
            elements[i].className = '.slds-is-expanded';
        }
    }

    handleItemListCollapsed() {
        const elements = this.template.querySelectorAll('.example-accordion');
        // eslint-disable-next-line vars-on-top
        for (var i=0; i<elements.length; i++) {
            elements[i].className = '.slds-is-collapsed';
        }
    }
}