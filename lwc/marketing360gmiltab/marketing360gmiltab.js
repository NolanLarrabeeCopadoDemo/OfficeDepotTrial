import { LightningElement, api, track, wire } from 'lwc';
import getContactDetails from '@salesforce/apex/marketing360GMILController.getContactDetails';
import searchContactDetails from '@salesforce/apex/marketing360GMILController.searchContactDetails';
export default class Marketing360gmiltab extends LightningElement {
    @api recordId;
    @track searchStr='';
    @track hasError = false;
    @track prodSpinner = false;
    @track disableSearch = true;
    @track gmilContactInfo = [];
    @track gmilContactInfoCopy = [];
    @api aopsCustId;
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Open', fieldName: 'et4ae5__Opened__c',type:"boolean" },
        { label: 'Soft Bounce', fieldName: 'et4ae5__SoftBounce__c' ,type:"boolean"},
        { label: 'Hard Bounce', fieldName: 'et4ae5__HardBounce__c' ,type:"boolean"},
        { label: 'Click', fieldName: 'et4ae5__Clicked__c' ,type:"boolean"},
        { label: 'Number Of Click', fieldName: 'et4ae5__NumberOfTotalClicks__c'},
        { label: 'Content', fieldName: 'Sample_Email_Link__c',type: 'url', typeAttributes: { target:'_blank'}}
    ];

    onNameChange (event)
	{
        this.searchStr = event.target.value;
        if(this.searchStr != null && this.searchStr.length > 0 ) this.disableSearch = false;
        else
        {
            this.disableSearch = true;
            this.gmilContactInfo = this.gmilContactInfoCopy;
            if(this.gmilContactInfo != null && this.gmilContactInfo.length > 0 ) this.hasError = false;
        }
	}

    onSearchContactClick()
	{
        //console.log("this.recordId " + this.recordId);
        //console.log("this.searchStr " + this.searchStr);
        this.gmilContactInfo = [];
        this.hasError = true;
        searchContactDetails({accountId: this.recordId,
            strContactName: this.searchStr
                })
            .then(result=>{ 
                for(var key in result){
                    this.gmilContactInfo.push({value:result[key], key:key}); //Here we are creating the array to show on UI.
                    this.hasError = false;
                }
                if(result === null) this.hasError = true;
            })
            .catch(error=>{
                console.log('unknown error' + error);
                this.hasError = true;
            })
        //console.log("this.hasError " + this.hasError);
        //console.log("gmilContactInfo " + this.gmilContactInfo);
    }

    resetSearch()
    {
        this.searchStr = '';
        this.disableSearch = true;
        this.gmilContactInfo = this.gmilContactInfoCopy;
        if(this.gmilContactInfo != null && this.gmilContactInfo.length > 0 ) this.hasError = false;
    }

    @wire(getContactDetails, { accountId: '$recordId'})
wiredContacts({ error, data }) {
    //Check if data exists 
    if (data) {
        console.log("data " + data + ' acc aopsCustId id ' + this.aopsCustId);
        this.hasError = false;
        for(var key in data){
            this.gmilContactInfo.push({value:data[key], key:key}); //Here we are creating the array to show on UI.
            this.gmilContactInfoCopy.push({value:data[key], key:key});
        }
    } else if (error) {
        console.log("error " + error);
        this.hasError = true;
    }
    else
    {
        console.log("No recods "  + ' acc id ' + this.recordId+ ' acc aopsCustId id ' + this.aopsCustId);
        this.hasError = true;
    }
    console.log(' acc id ' + this.recordId+ ' acc aopsCustId id ' + this.aopsCustId);
    this.prodSpinner = true;
}

}