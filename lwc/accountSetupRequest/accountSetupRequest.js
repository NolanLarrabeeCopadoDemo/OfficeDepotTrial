import { LightningElement,track,wire,api } from 'lwc';
import getDMLData from '@salesforce/apex/BulkProspectUploadController.getDMLData';
import commitAccountSetupRequests from '@salesforce/apex/BulkProspectUploadController.commitAccountSetupRequests';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import DECISION_MAKER_SEGMENT_FIELD from '@salesforce/schema/DML__c.DECISION_MAKER_SEGMENT__c';
const actions = [
    { label: 'Show details', name: 'show_details' },
];
const columns = [
    { label: 'Name', fieldName: 'Name',type: 'text' },
    { label: 'Street', fieldName: 'Address1__c', type: 'text' },
    { label: 'Street 2', fieldName: 'Address2__c', type: 'text' },
    { label: 'City', fieldName: 'City__c', type: 'text' },
    { label: 'Country', fieldName: 'Country__c', type: 'text' },
    { label: 'State', fieldName: 'State__c', type: 'text' },
    { label: 'Zip', fieldName: 'Zip__c', type: 'text' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];
const states = [ 'AL','AK','AZ','AR','CA','CO','CT','DC','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY'];

export default class AccountSetupRequest extends LightningElement {
    columns = columns;
    states = states; 
    @api prospectJson =[{
        "Id":"0011k00000eI0Iw",
        "Name": "Uptown Pizza",
        "Address1__c": "2235 Seacrest Blvd",
        "Address2__c": "",
        "City__c": "Delray Beach",
        "Country__c": "USA",
        "State__c": "FL",
        "Zip__c": "33444",
        "Phone":"1234567890",
        "FirstName":"Sandesh",
        "LastName":"Ganjare",
        "Phone1_Rep__c":"1234567890",
        "Email":"sandesh@test.com"
      }];
    @track isNewDML = false;
    @track showSpinner= false;
    @track accountSetupJson = [];
    @track accRec = {
        "ACCOUNT_ID__c":"",
        "isSubmitted":false,
        "BillTo_Name__c":"",
        "Account_Phone__c":"",
        "Street_Address_Bill__c":"",
        "Street_Address_2_Bill__c":"",
        "City_Bill__c":"",
        "State_Bill__c":"",
        "Zip_Bill__c":"",
        "BILL_COUNTRY__c":"",
        "Street_Address_Ship__c":"",
        "Street_Address_2_Ship__c":"",
        "City_Ship__c":"",
        "State_Ship__c":"",
        "Zip_Ship__c":"",
        "SHIP_COUNTRY__c":"",
        "Primary_Contact_First_Name__c":"",
        "Primary_Contact_Last_Name__c":"",
        "Primary_Contact_Phone__c":"",
        "Primary_Contact_Fax__c":"",
        "Primary_Contact_Email__c":"",
        "Does_your_Customer_have_any_ordering_pr__c":"",
        "PO__c":"",
        "Desktop__c":"",
        "Cost_Center__c":"",
        "Release__c":"",
        "Rename_Purchase_Order__c":"",
        "Rename_Desktop__c":"",
        "Rename_Cost_Center__c":"",
        "Rename_Release__c":"",
        "Minimum_Order_Value__c":"",
        "Budgets_CC_PO__c":"",
        "Special_Delivery_Requirements__c":"",
        "Print_Invoice__c":"",
        "Display_Purchase_Orders__c":"",
        "Display_Payment_Method__c":"",
        "Display_Prices__c":"",
        "Backorders_displayed_on_packing_list__c":"",
        "Rename_Packlist__c":"",
        "EDI_or_Punch_Out__c":"",
        "Employer_TIN__c":"",
        "Is_IRS_W9_Required_for_AP__c":"",
        "Tax_Exempt__c":"",
        "Tax_Exempt_States__c":"",
        "Why_are_you_tax_exempt__c":"",
        "Goverment_Branch__c":"",
        "DML__c":"",
        "Rep_Comments__c":"",
        "Show_Net_20__c":false,
        "Show_Net_30_Question__c":false,
        "Does_Your_Customer_mandate_net_30_terms__c":"",
        "Billing_Delivery_Method_Media_type__c":"",
        "AP_Contact_Salutation__c":"",
        "AP_Contact_First_Name__c":"",
        "AP_Contact_Last_Name__c":"",
        "AP_Contact_Email__c":"",
        "AP_Contact_Phone__c":"",
        "AP_Contact_Fax__c":"",
        "eBilling_Contact_Salutation__c":"",
        "eBilling_Contact_First_Name__c":"",
        "eBilling_Contact_Last_Name__c":"",
        "eBilling_Contact_Phone__c":"",
        "eBilling_Contact_Email__c":"",
        "Monthly_eStatement_Email__c":"",
        "eBilling_Contact_Salutation2__c":"",
        "eBilling_Contact_First_Name2__c":"",
        "eBilling_Contact_Last_Name2__c":"",
        "eBilling_Contact_Phone2__c":"",
        "eBilling_Contact_Email2__c":"",
        "PD_Incl_Backup_Inc__c":"",
        "Monthly_eStatements__c":"",
        "Early_Pay_Discount_Needed__c":"",
        "PD_multiple_bill_to_locations__c":"",
        "PD_Doc_Name__c":""

    }
    dmlRec = {
        "DECISION_MAKER_NM__c":"",
        "Notes__c":"",
        "DML_State__c":"",
        "DML_City__c":"",
        "DECISION_MAKER_SEGMENT__c":"",
        "DECISION_MAKER_ZIP_CD__c":""
    }
    get orderOptions() {
        return [
            { label: 'choose one...', value: '' },
            { label: 'Yes', value: 'Yes' },
            { label: 'Hide', value: 'Hide' },
            { label: 'Validate', value: 'Validate' },
            { label: 'No', value: 'No' },
        ];
    }
    get options() {
        return [
            { label: 'choose one...', value: '' },
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }
    get governmentBranchOptions() {
        return [
            { label: 'Pick Government Branch', value: '' },
            { label: 'State', value: 'State' },
            { label: 'Local', value: 'Local' },
            { label: 'Federal', value: 'Federal' },
        ];
    }
    get exemptionTypeOptions() {
        return [
            { label: 'Pick Exemption Type', value: '0' },
            { label: 'Government', value: 'Government' },
            { label: 'Non-profit', value: 'Non-profit' },
            { label: 'Reseller', value: 'Reseller' },
            { label: 'School', value: 'School' },
        ];
    }

    get salutationOptions() {
        return [
            { label: 'choose one...', value: '' },
            { label: 'Capt', value: 'Capt' },
            { label: 'Dr.', value: 'Dr' },
            { label: 'Miss', value: 'Miss' },
            { label: 'Mr.', value: 'Mr' },
            { label: 'Mrs.', value: 'Mrs' },
            { label: 'Ms.', value: 'Ms.' },
            { label: 'Rev.', value: 'Rev' },
            { label: 'Sgt.', value: 'Sgt' },
            { label: 'Sir', value: 'Sir' },
        ];
    }
    get deliveryMediaOptions() {
        return [
            { label: 'choose one...', value: '' },
            { label: 'ePDF', value: 'ePDF' },
            { label: 'Paper', value: 'Paper' },
            
        ];
    }
    get invoiceTypeOptions() {
        return [
            { label: 'Standard Invoice', value: 'Standard Invoice' },
            { label: 'Consolidated Bill', value: 'Consolidated Bill' },
            
        ];
    }
    get billLocationOptions() {
        return [
            { label: 'No, Centralized Accts Payable receives bill', value: 'No, Centralized Accts Payable receives bill' },
            { label: 'Yes, some or all Ship To locations receive bill', value: 'Yes, some or all Ship To locations receive bill' },
            
        ];
    }

    @track dmlSegmentOptions =[];
    @track dmlOptions = [];
    @track togglePO = false;
    @track togglePOD = false;
    @track togglePODeskTop = false;
    @track togglePOCost = false;
    @track togglePORelease = false; 
    @track toggleBudgetsCcPo = false;
    @track toggleDelivery = false; 
    @track toggletax = false;
    @track togglegov = false;
    @track togglePaper = false;
    @track togglePDF = false;
    @track togglePDBackup = false;
    @track checkboxValueMap=[];
    index;

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: DECISION_MAKER_SEGMENT_FIELD }) //recordTypeId: Provided dummy value as it is required. 
    wiredPicklistValues({ error, data }) {
        this.showSpinner =true;
        if (data) {
            //this.record = data;
            console.log(data.values);
            var temp=[];
            for(let i in data.values){
                temp.push({ label: data.values[i].label, value:  data.values[i].value });
            }
            this.dmlSegmentOptions = temp;
            this.error = undefined;
            this.bindJSONObject();
            this.showSpinner =false;
        } else if (error) {
            this.error = error;
            this.showSpinner =false;
        }
    }
    bindJSONObject(){
        //alert('Test Method');
        var prospects = JSON.parse(JSON.stringify(this.prospectJson));
        var accountSetupRequests = [];
        if(prospects && prospects.length>0){
            for(var i in prospects){
                console.log('prospects=>',prospects[i]);
                let accRec = {};
                accRec.ACCOUNT_ID__c = prospects[i].Id;
                accRec.ACCOUNT__c = prospects[i].Id;
                accRec.isSubmitted=false;

                accRec.BillTo_Name__c = prospects[i].Name;
                accRec.Street_Address_Bill__c = prospects[i].Address1__c;
                accRec.Street_Address_2_Bill__c = prospects[i].Address2__c;
                accRec.City_Bill__c = prospects[i].City__c;
                accRec.State_Bill__c = prospects[i].State__c;
                accRec.BILL_COUNTRY__c = prospects[i].Country__c;
                accRec.Zip_Bill__c = prospects[i].Zip__c;
                accRec.Account_Phone__c = prospects[i].Phone;
                
                accRec.Street_Address_Ship__c = prospects[i].Address1__c;
                accRec.Street_Address_2_Ship__c = prospects[i].Address2__c;
                accRec.City_Ship__c = prospects[i].City__c;
                accRec.State_Ship__c = prospects[i].State__c;
                accRec.SHIP_COUNTRY__c = prospects[i].Country__c;
                accRec.Zip_Ship__c = prospects[i].Zip__c;

                accRec.Primary_Contact_Job_Title__c = prospects[i].Title;
                accRec.Primary_Contact_First_Name__c = prospects[i].FirstName;
                accRec.Primary_Contact_Last_Name__c = prospects[i].LastName;
                accRec.Primary_Contact_Phone__c = prospects[i].Phone1_Rep__c;
                accRec.Primary_Contact_Fax__c = "";
                accRec.Primary_Contact_Email__c = prospects[i].Email;
                accRec.Primary_Contact_Mobile_Phone__c = prospects[i].MobilePhone;
                accRec.Primary_Contact_Salutation__c = prospects[i].Salutation;

                accRec.Segment__c = prospects[i].Segment__c;
                if(prospects[i].Est_Spend__c){
                    accRec.Est_Spend__c = (prospects[i].Est_Spend__c).toString();
                }else{
                    accRec.Est_Spend__c = '0';
                }
                
                accRec.Number_of_WCW_employees__c = prospects[i].Org_WCW_Count_Rep__c;
                if (prospects[i].Est_Spend__c > 250000 && prospects[i].Payment_Term__c == 'Account Billing') {
                    accRec.Show_Net_30_Question__c = true;
                    accRec.Show_Net_20__c = true;
        
                } else if (prospects[i].Payment_Term__c == 'Credit Card') {
                    accRec.Show_Net_20__c = false;
                    accRec.Show_Net_30_Question__c = false;
        
                } else {
                    accRec.Show_Net_30_Question__c = false;
                    accRec.Show_Net_20__c = true;
                }
                accRec.Rep_ID__c = prospects[i].Sales_PersonID__c;
                
                accRec.Does_your_Customer_have_any_ordering_pr__c="";
                accRec.PO__c="";
                accRec.Desktop__c="";
                accRec.Cost_Center__c="";
                accRec.Release__c="";
                accRec.Rename_Purchase_Order__c="";
                accRec.Rename_Desktop__c="";
                accRec.Rename_Cost_Center__c="";
                accRec.Rename_Release__c="";
                accRec.Minimum_Order_Value__c="";
                accRec.Budgets_CC_PO__c="";
                accRec.Special_Delivery_Requirements__c="";
                accRec.Print_Invoice__c="";
                accRec.Display_Purchase_Orders__c="";
                accRec.Display_Payment_Method__c="";
                accRec.Display_Prices__c="";
                accRec.Backorders_displayed_on_packing_list__c="";
                accRec.Rename_Packlist__c="";
                accRec.EDI_or_Punch_Out__c="";
                accRec.Employer_TIN__c="";
                accRec.Is_IRS_W9_Required_for_AP__c="";
                accRec.Tax_Exempt__c="";
                accRec.Tax_Exempt_States__c="";
                accRec.Why_are_you_tax_exempt__c="";
                accRec.Goverment_Branch__c="";
                accRec.DML__c="";
                accRec.Rep_Comments__c="";
                accRec.Survey_Complete__c = true;

                accRec.Does_Your_Customer_mandate_net_30_terms__c="";
                accRec.Billing_Delivery_Method_Media_type__c="";
                accRec.AP_Contact_Salutation__c="";
                accRec.AP_Contact_First_Name__c="";
                accRec.AP_Contact_Last_Name__c="";
                accRec.AP_Contact_Email__c="";
                accRec.AP_Contact_Phone__c="";
                accRec.AP_Contact_Fax__c="";
                accRec.eBilling_Contact_Salutation__c="";
                accRec.eBilling_Contact_First_Name__c="";
                accRec.eBilling_Contact_Last_Name__c="";
                accRec.eBilling_Contact_Phone__c="";
                accRec.eBilling_Contact_Email__c="";
                accRec.Monthly_eStatement_Email__c="";
                accRec.eBilling_Contact_Salutation2__c="";
                accRec.eBilling_Contact_First_Name2__c="";
                accRec.eBilling_Contact_Last_Name2__c="";
                accRec.eBilling_Contact_Phone2__c="";
                accRec.eBilling_Contact_Email2__c="";
                accRec.PD_Incl_Backup_Inc__c="";
                accRec.Monthly_eStatements__c="";
                accRec.Early_Pay_Discount_Needed__c="";
                accRec.PD_multiple_bill_to_locations__c="";
                accRec.PD_Doc_Name__c="";

                accountSetupRequests.push(accRec);
            }
        }
        this.accountSetupJson = accountSetupRequests;
        console.log('accounts=>',this.accountSetupJson);
    }
    handleChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        console.log('Current value of the input: ' + event.target.name);
        this.accRec[event.target.name] = event.target.value;
    }
    handleDMLChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        console.log('Current value of the input: ' + event.target.name);
        this.dmlRec[event.target.name] = event.target.value;
    }
    handlePOChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.Does_your_Customer_have_any_ordering_pr__c = opt;
        
        if (opt == "Yes") {
            this.togglePO = true;
        } else {
            this.togglePO = false;
        }
    }
    handlePODChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.PO__c = opt;
        if (opt == "Yes" || opt == "Validate") {
            this.togglePOD = true;
        } else {
            this.togglePOD = false;
            this.accRec.Rename_Purchase_Order__c='';
           // component.set("v.accRec.Rename_Purchase_Order__c", "");
        }
        this.toggleBudgetsCcPo1();
    }
    handlePODeskTopChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.Desktop__c= opt;
        if (opt == "Yes" || opt == "Validate") {
            this.togglePODeskTop = true;
        } else {
            this.togglePODeskTop = false;
            this.accRec.Rename_Desktop__c='';
           // component.set("v.accRec.Rename_Desktop__c", "");
        }
        this.toggleBudgetsCcPo1();
    }
    handlePOCostChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.Cost_Center__c= opt;
        if (opt == "Yes" || opt == "Validate") {
            this.togglePOCost = true;
        } else {
            this.togglePOCost = false;
            this.accRec.Rename_Cost_Center__c='';
           // component.set("v.accRec.Rename_Cost_Center__c", "");
        }
        this.toggleBudgetsCcPo1();
    }
    handlePOReleaseChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.Release__c= opt;
        if (opt == "Yes" || opt == "Validate") {
            this.togglePORelease = true;
        } else {
            this.togglePORelease = false;
            this.accRec.Rename_Release__c='';
           //component.set("v.accRec.Rename_Release__c", "");
        }
        this.toggleBudgetsCcPo1();
    }
    toggleBudgetsCcPo1(event){
        if(this.togglePOCost || this.togglePODeskTop || this.togglePOD || this.togglePORelease){
            this.toggleBudgetsCcPo = true;
        }else{
            this.toggleBudgetsCcPo = false;
        }
    }
    handleDeliveryChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.Special_Delivery_Requirements__c= opt;
        if (opt == "Yes") {
            this.toggleDelivery = true;
        } else {
            this.toggleDelivery = false;
        }
    }
    TINValid( event) {
        //var inp = event.getSource();
        var inputCmp = this.template.querySelector(".inputTIN");
        var val = event.target.value;
        var re = new RegExp("[0-9]{2}-[0-9]{7}$");
        console.log(val);
        if (!re.test(val)) {           
            inputCmp.setCustomValidity("Please enter correct TIN.");
        } else {           
            inputCmp.setCustomValidity("");
        }
    }
    handleTaxExemptChange(event){
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.Tax_Exempt__c= opt;
        if (opt == "Yes") {
            this.toggletax = true;
        } else {
            this.toggletax = false;
        }
    }
    handleExemptionTypeChange(event){
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        this.accRec.Why_are_you_tax_exempt__c= opt;
        if (opt == "Government") {
            this.togglegov = true;
        } else {
            this.togglegov = false;
        }
    }
    oncheck(event) {
        console.log('Current value of the input: ' + event.target.value);
        var capturedCheckboxName = event.target.value;
        console.log('capturedCheckboxName' + capturedCheckboxName);
        if(this.checkboxValueMap){
            var foundIndex = this.checkboxValueMap.findIndex(x => x.key == capturedCheckboxName);
            this.checkboxValueMap.splice(foundIndex, 1,{value:true, key:capturedCheckboxName})
            //this.checkboxValueMap.push({value:true, key:capturedCheckboxName});
        }
        
        var selectedCheckBoxes = this.checkboxValueMap;
        var strstate = '';
        for (var key in selectedCheckBoxes) {
            if (selectedCheckBoxes[key].value == true) {
                if (strstate == '') {
                    strstate = selectedCheckBoxes[key].key;
                } else {
                    strstate = strstate + ',' + selectedCheckBoxes[key].key;
                }
            }
        }

        this.accRec.Tax_Exempt_States__c = strstate;
        //component.set("v.accRec.Tax_Exempt_States__c", strstate);
    }
    handleDMLClick(event){
        this.dmlRec.DECISION_MAKER_NM__c = this.accRec.BillTo_Name__c;
        this.dmlRec.Notes__c='';
        this.dmlRec.DML_State__c= this.accRec.State_Bill__c;
        this.dmlRec.DML_City__c= this.accRec.City_Bill__c;
        this.dmlRec.DECISION_MAKER_SEGMENT__c= this.accRec.Segment__c;
        this.dmlRec.DECISION_MAKER_ZIP_CD__c= this.accRec.Zip_Bill__c;

        this.isNewDML = true;
    }
    handleDMLCancel(event){
        this.dmlRec.DECISION_MAKER_NM__c = '';
        this.dmlRec.Notes__c='';
        this.dmlRec.DML_State__c= '';
        this.dmlRec.DML_City__c= '';
        this.dmlRec.DECISION_MAKER_SEGMENT__c= '';
        this.dmlRec.DECISION_MAKER_ZIP_CD__c= '';
        this.isNewDML = false;
    }
    handleDMLSubmit(event){
        console.log('dmlRec'+this.dmlRec);
        if(this.accRec.DML__c === ''){
            this.accRec.DML__c = JSON.stringify(this.dmlRec);
        }
        this.isNewDML = false;
        
    }

    handleSubmit(event){
        console.log('accRec'+this.accRec);
        console.log('Current value of the input: ' + event.target.value);

        var allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
        
            allValid = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);    
            
        if (allValid) {
            //alert('All form entries look valid. Ready to submit!');
            this.accRec.isSubmitted = true;
            this.accountSetupJson[this.index] = this.accRec;
            this.template.querySelector("section").classList.add("slds-hide");
            this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
        } else {
            alert('Please fill all the mandatory fields.');
        }
        
    }
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'show_details':
                this.showRowDetails(row);
                break;
            default:
        }
    }
    /*
    deleteRow(row) {
        const { ProspectId } = row;
        const index = this.findRowIndexById(ProspectId);
        if (index !== -1) {
            this.data = this.data
                .slice(0, index)
                .concat(this.data.slice(index + 1));
        }
    }*/

    findRowIndexById(Id) {
        let ret = -1;
        this.accountSetupJson.some((row, index) => {
            if (row.ACCOUNT_ID__c === Id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    showRowDetails(row) {
        //this.record = row;
        //alert(row);
        this.showSpinner = true;
        //TAX checkbox values populate logic - Start
        let mapData=[];
        for(var key in states){
            mapData.push({value:false, key:states[key]}); //Here we are creating the array to show on UI.           
        }
        let strStates = this.accRec.Tax_Exempt_States__c;
        if(strStates && strStates.indexOf(",") !== -1){
            let arrStates = strStates.split(","); 
            for(var key in arrStates){
                var foundIndex = mapData.findIndex(x => x.key == arrStates[key]);
                mapData.splice(foundIndex, 1,{value:true, key:arrStates[key]})            
            }
        }else if(strStates !=''){
            var foundIndex = mapData.findIndex(x => x.key == strStates);
            mapData.splice(foundIndex, 1,{value:true, key:strStates}) 
        }
        this.checkboxValueMap = mapData;
        //TAX checkbox values populate logic - End

        //
        const { Id } = row;
        this.index = this.findRowIndexById(Id);
        if (this.index !== -1) {
            this.accRec = this.accountSetupJson[this.index];
        }       
        //

        //Get DML Data
        getDMLData({ AccId: this.accRec.ACCOUNT_ID__c})
        .then(result => {
            let data = result;
            console.log('data=>',data);
            var custs = [];
            for (var key in data) {
                custs.push({
                    value: key,
                    label: data[key]
                });
            }
            this.dmlOptions = custs;
            this.showSpinner = false;
            this.template.querySelector("section").classList.remove("slds-hide");
            this.template.querySelector("div.modalBackdrops").classList.remove("slds-hide");
        })
        .catch(error => {
            this.showSpinner = false;
            console.log(error);
        });

       
    }

    handleClick(event){
        this.template.querySelector("section").classList.add("slds-hide");
        this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
    }

    @api
    saveAccountSetupRequests() {
        //alert('In Account Setup component');
        this.showSpinner=true; //
        var isValid = true;
        if(this.accountSetupJson){
            for(var index in this.accountSetupJson){
                if(!this.accountSetupJson[index].isSubmitted){
                    isValid = false;
                    this.showSpinner = false;
                    alert('Some Information is missing for account ',this.accountSetupJson[index].BillTo_Name__c);
                    break;
                }
            }
           
        }
        if(isValid){
            this.showSpinner = true;
            for(var index in this.accountSetupJson){
                delete this.accountSetupJson[index]['isSubmitted'];
                //delete this.accountSetupJson[index]['ProspectId'];
            }

            commitAccountSetupRequests({ accountSetupRequests: JSON.stringify(this.accountSetupJson)})
            .then(result => {
                let data = result;
                console.log('data=>',data);
                this.showSpinner = false;
                const fireEvent = new CustomEvent('changestep', {
                    detail: 'Step5'
                });
                this.dispatchEvent(fireEvent);
            })
            .catch(error => {
                this.showSpinner = false;
                console.log(error);
                alert(error.body.message);
            });
        }
       // this.showSpinner = false;
    }

    handleDeliveryMediaOptions(event){
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        //this.accRec.Why_are_you_tax_exempt__c= opt;
        if (opt == "ePDF") {
            this.togglePDF = true;
            this.togglePaper = true;
        } else if (opt == "Paper") {
            this.togglePDF = false;
            this.togglePaper = true;
        }else{
            this.togglePDF = false;
            this.togglePaper = false;
        }
        this.handleChange(event);
    }

    handlePDBackup(event){
        console.log('Current value of the input: ' + event.target.value);
        var opt = event.target.value;
        if (opt == "Yes") {
            this.togglePDBackup = true;
        }else if(opt == "" || opt == "No"){
            this.togglePDBackup = false;
        }
        this.handleChange(event);
    }
}