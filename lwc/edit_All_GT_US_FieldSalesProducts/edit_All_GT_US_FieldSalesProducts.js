import { LightningElement, track,api, wire } from 'lwc';
import getProducts from '@salesforce/apex/EditOpportunityProductController.getProducts';

export default class Edit_All_GT_US_FieldSalesProducts extends LightningElement {
@api oppId;
@api hasExistingProducts = false;
@api isBSD = false;
@api prodError = false;
@track oppLineItems= [
    {
        Id:'',
        Product_GT__c:'',
        Product_BSD__c:'',
        Product_Subtype_GT__c:'',
        Product_Subtype_BSD__c:'',
        Product_Subtype__c:'',
        IMU__c: 0,
        Quantity: 0,
        UnitPrice: 0,
        Unit_Cost__c: 0,
        isRequired: false
    }
];
cancel()
{
    window.location.replace(window.location.origin + '/' + this.oppId);
}

updateOLIs() {
    this.prodError = false;
    console.log('oppLineItems[0].Quantity ' + this.oppLineItems[0].Quantity);
    var isUnitPrice = true;
    const inputFields = this.template.querySelectorAll(
        'lightning-input-field'
    );
    if (inputFields) {
        var subprodType = '';
        inputFields.forEach(field => {
            //console.log(' field.value ' + field.value )
            
            if(field.fieldName == 'Product_Subtype_BSD__c' || field.fieldName == 'Product_Subtype_GT__c')
            {
                subprodType = field.value;
            }
            if(field.fieldName == 'Product_Subtype__c')
            {
                field.value = subprodType;
            }
            if(field.fieldName == 'UnitPrice' && (field.value == 0 || field.value == null))
            {
                isUnitPrice = false;
                field.setErrors("Unit Price must be greater than 0.00");
                this.prodError = true;
            }
            else
            {
                isUnitPrice = isUnitPrice && field.reportValidity();
            }
                //console.log('Field Name' + field.fieldName + ' field.value ' + field.value );
                field.reportValidity();
        });
    }
    if(isUnitPrice)
    {
        this.prodSpinner = false;
        var isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });
        
        if (isVal) {
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();
            });
            console.log('salesforce Base URL ' + window.location.origin );
            setTimeout(this.gotoOpportunity.bind(this), this.oppLineItems.length * 1000);
            
                //window.location.replace(window.location.origin + '/lightning/r/Opportunity/' + this.oppId + '/view');            
        } 
        else{this.prodSpinner = true;}
    }
}

gotoOpportunity() {
    console.log('salesforce Base URL oppid ' + this.oppId  + ' second wait ' + this.oppLineItems.length * 1000);
    window.location.replace(window.location.origin + '/' + this.oppId);
}

@wire(getProducts, { oppId: '$oppId' })
wiredContacts({ error, data }) {
    //Check if data exists 
    if (data) {
        var items = JSON.parse(JSON.stringify(data));
        
        for(let i = 0; i < items.length; i++) {
            if(this.isBSD === true && items[i].Product_BSD__c === 'Tech')
            {
                
                items[i]['isRequired'] = true;
            }
        } 
        this.oppLineItems = items;
    } else if (error) {
        console.log(error);
    }else{
            // eslint-disable-next-line no-console
            console.log('unknown error')
    }
    this.prodSpinner = true;
}

}