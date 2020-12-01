import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class Prospect_creation_address_page extends LightningElement {
    @api
    get countryOption() {
        this.countryOptions = [
            { label: 'USA', value: 'USA' },
            { label: 'CAN', value: 'CAN' },
            { label: 'MEX', value: 'MEX' },
            { label: 'United States', value: 'United States' },
            { label: 'Canada', value: 'Canada' },
            { label: 'Mexico', value: 'Mexico' },
            { label: 'US', value: 'US' },
            { label: 'CA', value: 'CA' },
            { label: 'MX', value: 'MX' }
        
    ];return this.countryOptions;
}
stateOptions = [];

@api
    get stOption() {
        this.stOptions = {USA: [
            {label: 'AK', value:'AK'},{ label: 'AL', value:'AL'},{ label: 'AR', value:'AR'},
                               { label: 'AZ', value:'AZ'},{ label: 'CA', value:'CA'},{ label: 'CO', value:'CO'},
                               { label: 'CT', value:'CT'},{ label: 'DC', value:'DC'},{ label: 'DE', value:'DE'},
                               { label: 'FL', value:'FL'},{ label: 'GA', value:'GA'},{ label: 'HI', value:'HI'},
                               { label: 'IA', value:'IA'},{ label: 'ID', value:'ID'},{ label: 'IL', value:'IL'},
                               { label: 'IN', value:'IN'},{ label: 'KS', value:'KS'},{ label: 'KY', value:'KY'},
                               { label: 'LA', value:'LA'},{ label: 'MA', value:'MA'},{ label: 'MD', value:'MD'},
                               { label: 'ME', value:'ME'},{ label: 'MI', value:'MI'},{ label: 'MN', value:'MN'},
                               { label: 'MO', value:'MO'},{ label: 'MS', value:'MS'},{ label: 'MT', value:'MT'},
                               { label: 'NC', value:'NC'},{ label: 'ND', value:'ND'},{ label: 'NE', value:'NE'},
                               { label: 'NH', value:'NH'},{ label: 'NJ', value:'NJ'},{ label: 'NM', value:'NM'},
                               { label: 'NV', value:'NV'},{ label: 'NY', value:'NY'},{ label: 'OH', value:'OH'},
                               { label: 'OK', value:'OK'},{ label: 'OR', value:'OR'},{ label: 'PA', value:'PA'},
                               { label: 'PR', value:'PR'},{ label: 'RI', value:'RI'},{ label: 'SC', value:'SC'},
                               { label: 'SD', value:'SD'},{ label: 'TN', value:'TN'},{ label: 'TX', value:'TX'},
                               { label: 'UT', value:'UT'},{ label: 'VA', value:'VA'},{ label: 'VI', value:'VI'},
                               { label: 'VT', value:'VT'},{ label: 'WA', value:'WA'},{ label: 'WI', value:'WI'},
                               { label: 'WV', value:'WV'},{ label: 'WY', value:'WY'}
        ],
        CAN: [
            {label: 'AB', value: 'AB'}, { label: 'BC', value: 'BC'}, { label: 'MB', value: 'MB'}, 
                              { label: 'NB', value: 'NB'}, { label: 'NL', value: 'NL'}, { label: 'NT', value: 'NT'}, 
                              { label: 'NS', value: 'NS'}, { label: 'NU', value: 'NU'}, { label: 'ON', value: 'ON'}, 
                              { label: 'PE', value: 'PE'}, { label: 'QC', value: 'QC'}, { label: 'SK', value: 'SK'}, 
                              { label: 'YT', value: 'YT'}
        ],
        MEX: []};
        
return this.stOptions;
}
    @api
    get nameInput() {
        return this.nameOutput;
    }
    set nameInput(val) {
        this.nameOutput = val;
    }
    @api
    get address1Input() {
        return this.address1Output;
    }
    set address1Input(val) {
        this.address1Output = val;
    }
    @api
    get address2Input() {
        return this.address2Output;
    }
    set address2Input(val) {
        this.address2Output = val;
    }
    @api
    get cityInput() {
        return this.cityOutput;
    }
    set cityInput(val) {
        this.cityOutput = val;
    }
    @api
    get stateInput() {
        return this.stateOutput;
    }
    set stateInput(val) {
        this.stateOutput = val;
    }
    @api
    get zipInput() {
        return this.zipOutput;
    }
    set zipInput(val) {
        this.zipOutput = val;
    }
    @api
    get countryInput() {
        return this.countryOutput;
    }
    set countryInput(val) {
        this.countryOutput = val;
    }

    @api nameOutput;
    @api address1Output;
    @api address2Output;
    @api cityOutput;
    @api stateOutput;
    @api zipOutput;
    @api countryOutput;

    // Start : Added by Rajendra Shahane for NAIT-146087 - Implement SFDC Out of the Box Address Search for Prospects
    handleChange(event) {
        
        this.address1Output = event.detail.street;
        console.log('address1Output ' + this.address1Output);
        console.log('inputFields street ' + event.detail.street);
        this.cityOutput = event.detail.city;
        console.log('cityOutput ' + this.cityOutput);
        console.log('inputFields city ' + event.detail.city);
        console.log('inputFields country before ' + event.detail.country);
        if(event.detail.country === "US" || event.detail.country === "United States" || this.countryOutput === "United States" || event.detail.country === "USA")   this.countryOutput = 'USA';
        if(event.detail.country === "CA" || event.detail.country === "Canada" || this.countryOutput === "Canada" || event.detail.country === "CAN")   this.countryOutput = 'CAN';
        if(event.detail.country === "MX" || event.detail.country === "Mexico" || this.countryOutput === "Mexico" || event.detail.country === "MEX")   this.countryOutput = 'MEX';
        event.detail.country = this.countryOutput;
        console.log('inputFields country After ' + event.detail.country);
        //this.countryOutput = event.detail.country;
        console.log('countryOutput*' + this.countryOutput);
        var st = event.detail.province;
        this.stateOptions =  this.stOptions[this.countryOutput];
        this.zipOutput = event.detail.postalCode;
        console.log('zipOutput ' + this.zipOutput);
        console.log('inputFields postal-code ' + event.detail.postalCode);
        
        this.stateOutput = st;
        console.log('stateOutput ' + this.stateOutput);
        console.log('inputFields province ' + event.detail.province);
        event.detail.country = this.countryOutput;
    }
    // End  : Added by Rajendra Shahane for NAIT-146087 - Implement SFDC Out of the Box Address Search for Prospects
    
    @api validate() {
        console.log('nameOutput ' + this.nameOutput);
        console.log('In Validate ');
        console.log('address1Output ' + this.address1Output);
        console.log('cityOutput ' + this.cityOutput);
        console.log('stateOutput ' + this.stateOutput);
        console.log('countryOutput ' + this.countryOutput);
        console.log('zipOutput ' + this.zipOutput);
        
        let errorMessage = '';        
        if(!this.nameOutput) errorMessage = 'Please specify a Prospect Name';
        if(this.address1Output && this.address1Output.length > 25) errorMessage = 'Address 1 must be 25 characters or less';
        if(!this.countryOutput) errorMessage = 'Please specify a Country';
        if(!this.zipOutput) errorMessage = 'Please specify a Zip/Postal code';
        if(!this.stateOutput) errorMessage = 'Please specify a State';
        if(!this.cityOutput) errorMessage = 'Please specify a City';
        if(!this.address1Output) errorMessage = 'Please specify an Address 1 value.';
        if(!this.nameOutput) errorMessage = 'Please specify a Prospect Name';
        // Start : Modified by Rajendra Shahane for NAIT-146087 - Implement SFDC Out of the Box Address Search for Prospects
        if(errorMessage !== '') {
            //sessionStorage.setItem('prospectCreationName', this.nameOutput);
            //sessionStorage.setItem('prospectCreationAddress1', this.address1Output);
            //sessionStorage.setItem('prospectCreationAddress2', this.address2Output);
            //sessionStorage.setItem('prospectCreationCity', this.cityOutput);
            //sessionStorage.setItem('prospectCreationState', this.stateOutput);
            //sessionStorage.setItem('prospectCreationZip', this.zipOutput);
            //sessionStorage.setItem('prospectCreationCountry', this.countryOutput);
            // End : Modified by Rajendra Shahane for NAIT-146087 - Implement SFDC Out of the Box Address Search for Prospects
            return {
                isValid: false,
                errorMessage: errorMessage
            };
        } else {
            sessionStorage.clear();
            return {
                isValid: true
            }
        }
    }

    connectedCallback() {
        let name = sessionStorage.getItem('prospectCreationName');
        let address1 = sessionStorage.getItem('prospectCreationAddress1');
        let address2 = sessionStorage.getItem('prospectCreationAddress2');
        let city = sessionStorage.getItem('prospectCreationCity');
        let state = sessionStorage.getItem('prospectCreationState');
        let zip = sessionStorage.getItem('prospectCreationZip');
        let country = sessionStorage.getItem('prospectCreationCountry');

        if(name) this.nameOutput = name;
        if(address1) this.address1Output = address1;
        if(address2) this.address2Output = address2;
        if(city) this.cityOutput = city;
        if(state) this.stateOutput = state;
        if(zip) this.zipOutput = zip;
        if(country) this.countryOutput = country;

        if(!this.countryOutput) this.countryOutput = 'USA';
    }
    /*
    addressSelected(event) {
        let addressInfo = JSON.parse(event.detail);

        this.address1Output = addressInfo.address1;
        this.address2Output = addressInfo.address2;
        this.cityOutput = addressInfo.city;
        this.stateOutput = addressInfo.state;
        this.zipOutput = addressInfo.zip;
        this.countryOutput = addressInfo.country;
        
    }
    
    nameChanged(event) {
        this.nameOutput = event.target.value;
    }

    address1Changed(event) {
        this.address1Output = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('address1Output', this.address1Output));
    }

    address2Changed(event) {
        this.address2Output = event.target.value;
    }

    cityChanged(event) {
        this.cityOutput = event.target.value;
    }

    stateChanged(event) {
        this.stateOutput = event.target.value;
    }

    zipChanged(event) {
        this.zipOutput = event.target.value;
    }

    countryChanged(event) {
        this.countryOutput = event.target.value;
    }*/
}