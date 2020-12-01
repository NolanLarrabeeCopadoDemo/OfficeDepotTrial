import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getAddressAutoComplete from '@salesforce/apex/GoogleMapsController.getAddressAutoComplete';
import getAddressPlaceInfo from '@salesforce/apex/GoogleMapsController.getAddressPlaceInfo';

export default class Google_maps_autocomplete extends LightningElement {
    @track searchKey;
    @track filteredOptions;
    @track dropdownOpen = false;

    async keyUpController(event) {
        this.searchKey = event.target.value;

        if(!this.searchKey || this.searchKey.length < 3) {
            this.dropdownOpen = false;
        } else {
            this.dropdownOpen = true;
        }

        let response = await getAddressAutoComplete({ input: this.searchKey, types: 'geocode' });
        response = JSON.parse(response);

        if(response.status !== 'OK') return;

        let predictions = response.predictions;
        let addresses = [];
        predictions.forEach(prediction => {
            addresses.push(
                {
                    value: prediction.types[0],
                    label: prediction.description,
                    placeid: prediction.place_id
                }
            );
        });
        this.filteredOptions = addresses;
    }

    get inputContainerClass() {
        if(this.dropdownOpen === false) {
            return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-combobox-lookup';
        } else {
            return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
        }
    }

    async selectOption(event) {
        this.dropdownOpen = false;

        this.searchKey = event.currentTarget.dataset.label;
        let key = event.currentTarget.dataset.key;

        let response = await getAddressPlaceInfo({ input: key });
        response = JSON.parse(response);
        if(response.status !== 'OK') return;

        let addrComponents = response.result.address_components
        let address1 = response.result.name;
        let address2 = '';
        let cityObject = addrComponents.find(comp => comp.types.includes('locality') && comp.types.includes('political'));
        let city = cityObject.long_name;
        let stateObject = addrComponents.find(comp => comp.types.includes('administrative_area_level_1') && comp.types.includes('political'));
        let state = stateObject.short_name;
        let zipObject = addrComponents.find(comp => comp.types.includes('postal_code'));
        let zip = zipObject.long_name;
        let countryObject = addrComponents.find(comp => comp.types.includes('country') && comp.types.includes('political'));
        let country = countryObject.short_name;
        if(country === 'US') country = 'USA';
        if(country === 'CA') country = 'CAN';
        if(country === 'MX') country = 'MEX';
        this.country = country;

        this.dispatchEvent(
            new CustomEvent(
                'addressselected',
                {
                    detail: JSON.stringify(
                        {
                            address1: address1,
                            address2: address2,
                            city: city,
                            state: state,
                            zip: zip,
                            country: country
                        }
                    )
                }
            )
        );

        // this.address1 = this.address1Value;
        // console.log(this.address1);
        // console.log(this.address1Value);
        // this.dispatchEvent(new FlowAttributeChangeEvent('address1', this.address1Value));
    }
}