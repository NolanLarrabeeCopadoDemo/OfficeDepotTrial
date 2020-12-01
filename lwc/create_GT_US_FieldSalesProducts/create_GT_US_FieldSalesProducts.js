import { LightningElement, track,api, wire } from 'lwc';
import getProducts from '@salesforce/apex/OpportunityProductController.getProducts';
import updatePricebook from '@salesforce/apex/OpportunityProductController.updateOpportunityPricebook';
import { NavigationMixin } from 'lightning/navigation';

export default class Create_GT_US_FieldSalesProducts  extends NavigationMixin(LightningElement)
{

@api oppId;
@api prodSpinner = false;
@api prodError = false;
@api isBSD = false;
@api Pricebook2Id='';
@api isPricebookAvailabel=false;
@api isPricebookSelected = false;
@api isProdAvailabel=false;
@api DefaultPricebook2Id = '';
@api DefaultPricebookName = '';
@api ExistingProductsPricebookName = '';
@api hasExistingProducts = false;
@api numOfExistingProducts = 0;
@track index = 0;
searchInput = '';
@api PbId;
@track products ;

@track oppLineItems= [
    {
        Id:0,
        PriceBookEntryId:'',
        Product2Id:'',
        Product_GT__c:'',
        Product_BSD__c:'',
        OpportunityId:'',
        IMU__c: 0,
        Quantity: 1,
        UnitPrice: 0,
        Unit_Cost__c: 0,
        isRequired: false
    }
];

createOLIs() {
    this.prodError = false;
    //console.log('oppLineItems[0].Quantity ' + this.oppLineItems[0].Quantity);
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
            //Start : Added by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
            if(this.DefaultPricebookName != this.ExistingProductsPricebookName)
            {
                updatePricebook({pricebookId: this.Pricebook2Id,
                    opportunityId: this.oppId
                        })
                    .then(result=>{ 
                        console.log('result updatePricebook' + result);
                        
                    })
                    .catch(error=>{
                        console.log('unknown error' + error);
                    })
            }
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();
                
            });
            //End : Added by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
            console.log('salesforce Base URL ' + window.location.origin );
            setTimeout(this.gotoOpportunity.bind(this), this.oppLineItem.length * 1000);
            
                //window.location.replace(window.location.origin + '/lightning/r/Opportunity/' + this.oppId + '/view');            
        } 
        else{this.prodSpinner = true;}
    }
}

gotoOpportunity() {
    console.log('salesforce Base URL oppid ' + this.oppId  + ' second wait ' + this.oppLineItem.length * 1000);
    window.location.replace(window.location.origin + '/' + this.oppId);
}

cancel()
{
    window.location.replace(window.location.origin + '/' + this.oppId);
}

removeRow(event){
    var selectedRow = event.currentTarget;
    var key = selectedRow.dataset.id;
    if(this.oppLineItem.length>1){
        this.isProdAvailabel = false;
        this.oppLineItem.splice(key, 1);
        this.index--;
        this.isProdAvailabel = true;
    }else if(this.oppLineItem.length == 1){
        this.oppLineItem = [];
        this.index = 0;
        this.isProdAvailabel = false;
        this.isPricebookSelected = true;
    }
} 

selectProducts() {
    this.prodSpinner = false;
    var indx1 = 0;
    var Items=[];
    let selectedRows = this.template.querySelectorAll('lightning-input');
    console.log(' selectProducts ' + selectedRows);
    var prod = this.products;
    console.log(' prod ' + prod);
    for(let i = 0; i < selectedRows.length; i++) {
        if(selectedRows[i].type === 'checkbox' && selectedRows[i].checked)  {
            console.log(' in for ' + i);
            if(this.isBSD === true)
            {
                console.log(' In BSD for ' + ' i ' + i + ' ' + prod[i].Product2.Id);
                var subTypeReq = false;
                if(prod[i].Product2.Name === 'Tech') subTypeReq = true;
                var newItem = [{ Id:indx1,
                            PriceBookEntryId: selectedRows[i].dataset.id,
                            Product_BSD__c: prod[i].Product2.Name,
                            Product2Id: prod[i].Product2.Id,
                            OpportunityId: this.oppId,
                            isRequired: subTypeReq
                                        }];
                Items = Items.concat(newItem);
            }
            else
            {
                console.log(' In GT for ' + ' i ' + i + ' Prod2Id ' + prod[i].Product2.Id);
                console.log(' In GT for ' + ' i ' + i + ' PBEID ' + selectedRows[i].dataset.id);
                var newItem1 = [{ Id:indx1,
                            PriceBookEntryId: selectedRows[i].dataset.id,
                            Product_GT__c: prod[i].Product2.Name,
                            Product2Id: prod[i].Product2.Id,
                            OpportunityId: this.oppId                            
                                }];
                Items = Items.concat(newItem1);
            }
            ++indx1;
            this.isProdAvailabel=true;
            this.isPricebookSelected = false;
        }
    }        
    console.log(' Items ' + Items);
    this.oppLineItem = Items;
    this.index = indx1;
    console.log(' this.oppLineItem ' + this.oppLineItem);
    this.prodSpinner = true;
}

//Start : Added by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
proceed() {
    this.prodSpinner = false;
    
    //console.log(event.target.value);
    this.Pricebook2Id = this.DefaultPricebook2Id; 
    this.PbId = this.DefaultPricebook2Id;
    
    this.isPricebookAvailabel=true;
    this.isPricebookSelected = true;
    this.prodSpinner = true;
    this.hasExistingProducts = false;
    console.log('isPricebookAvailabel: ', this.isPricebookAvailabel);
    console.log('PbId: ' + this.PbId + ' ' + this.Pricebook2Id );
    
}
//End : Added by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products

@wire(getProducts, { pricebookId: '$Pricebook2Id' })
    wiredContacts({ error, data }) {
        //Check if data exists 
        if (data) {
            this.products = data;
            this.prodSpinner = true;
        } else if (error) {
            console.log(error);
        }else{
                // eslint-disable-next-line no-console
                console.log('unknown error')
        }
    }
    
}