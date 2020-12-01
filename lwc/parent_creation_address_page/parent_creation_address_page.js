import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class Parent_creation_address_page extends LightningElement {
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

    @api validate() {
        let errorMessage = '';
        if(this.address1Output && this.address1Output.length > 25) errorMessage = 'Address 1 must be 25 characters or less';
        if(!this.countryOutput) errorMessage = 'Please specify a Country';
        if(!this.zipOutput) errorMessage = 'Please specify a Zip/Postal code';
        if(!this.stateOutput) errorMessage = 'Please specify a State';
        if(!this.cityOutput) errorMessage = 'Please specify a City';
        if(!this.address1Output) errorMessage = 'Please specify an Address 1 value.';
        if(!this.nameOutput) errorMessage = 'Please specify a Parent Account Name';
        
        if(errorMessage !== '') {
            sessionStorage.setItem('parentCreationName', this.nameOutput);
            sessionStorage.setItem('parentCreationAddress1', this.address1Output);
            sessionStorage.setItem('parentCreationAddress2', this.address2Output);
            sessionStorage.setItem('parentCreationCity', this.cityOutput);
            sessionStorage.setItem('parentCreationState', this.stateOutput);
            sessionStorage.setItem('parentCreationZip', this.zipOutput);
            sessionStorage.setItem('parentCreationCountry', this.countryOutput);
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
        let name = sessionStorage.getItem('parentCreationName');
        let address1 = sessionStorage.getItem('parentCreationAddress1');
        let address2 = sessionStorage.getItem('parentCreationAddress2');
        let city = sessionStorage.getItem('parentCreationCity');
        let state = sessionStorage.getItem('parentCreationState');
        let zip = sessionStorage.getItem('parentCreationZip');
        let country = sessionStorage.getItem('parentCreationCountry');

        if(name) this.nameOutput = name;
        if(address1) this.address1Output = address1;
        if(address2) this.address2Output = address2;
        if(city) this.cityOutput = city;
        if(state) this.stateOutput = state;
        if(zip) this.zipOutput = zip;
        if(country) this.countryOutput = country;

        if(!this.countryOutput) this.countryOutput = 'USA';
    }

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
        this.dispatchEvent(new FlowAttributeChangeEvent('nameOutput', this.nameOutput));
    }

    address1Changed(event) {
        this.address1Output = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('address1Output', this.address1Output));
    }

    address2Changed(event) {
        this.address2Output = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('address2Output', this.address2Output));
    }

    cityChanged(event) {
        this.cityOutput = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('cityOutput', this.cityOutput));
    }

    stateChanged(event) {
        this.stateOutput = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('stateOutput', this.stateOutput));
    }

    zipChanged(event) {
        this.zipOutput = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('zipOutput', this.zipOutput));
    }

    countryChanged(event) {
        this.countryOutput = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('countryOutput', this.countryOutput));
    }
}