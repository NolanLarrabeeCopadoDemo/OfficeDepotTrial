import { LightningElement, track } from 'lwc';
import getPricingInformationByGroup from '@salesforce/apex/ACEPricingInformation.getPricingInformationByGroup';
import isCurrentUserValidTeamMember from '@salesforce/apex/ACEPricingInformation.isCurrentUserValidTeamMember';

export default class AcePricingInformation extends LightningElement {
    @track isLoading = true;
    @track columns = [
        {
            label: 'Period',
            fieldName: 'batchUrl',
            type: 'url',
            typeAttributes: { label: { fieldName: 'batch' }, target: '_blank' }
        },
        {
            label: '# of Impacted Customers',
            fieldName: 'customerCount',
            type: 'number'
        },
        {
            label: 'Estimated Total Annual Spend Change',
            fieldName: 'annualSpend',
            type: 'currency',
            typeAttributes: { currencyCode: 'USD' }
        },
        {
            label: 'Average SKU Increase Amount',
            fieldName: 'percentIncrease',
            type: 'percent'
        },
        {
            label: 'Total SRM Impact',
            fieldName: 'summaryTotal',
            type: 'currency',
            typeAttributes: { currencyCode: 'USD' }
        }
    ]
    @track data = [];
    @track isValidTeamMember = false;

    get hasData() {
        return this.data && this.data.length;
    }

    connectedCallback() {
        this.init();
    }

    init() {
        this.isLoading = true;
        this.columns = [
            {
                label: 'Period',
                fieldName: 'batchUrl',
                type: 'url',
                typeAttributes: { label: { fieldName: 'batch' }, target: '_blank' }
            },
            {
                label: '# of Impacted Customers',
                fieldName: 'customerCount',
                type: 'number',
                cellAttributes: { alignment: 'left' }
            },
            {
                label: 'Estimated Total Annual Spend Change',
                fieldName: 'annualSpend',
                type: 'currency',
                typeAttributes: { currencyCode: 'USD' },
                cellAttributes: { alignment: 'left' }
            },
            {
                label: 'Average SKU Increase Amount',
                fieldName: 'percentIncrease',
                type: 'percent',
                typeAttributes: { minimumFractionDigits: '2' },
                cellAttributes: { alignment: 'left' }
            },
            {
                label: 'Total SRM Impact',
                fieldName: 'summaryTotal',
                type: 'currency',
                typeAttributes: { currencyCode: 'USD' },
                cellAttributes: { alignment: 'left' }
            }
        ];
        this.data = [];
        this.isValidTeamMember = false;

        isCurrentUserValidTeamMember()
            .then(response => {
                this.isValidTeamMember = response;
            })
            .catch(exception => {
                this.handleApexExceptions(exception);
            })
            .finally(() => {
                getPricingInformationByGroup()
                    .then(response => {
                        this.handlePricingInformationResponse(response);
                    })
                    .catch(exception => {
                        this.handleApexExceptions(exception);
                    })
                    .finally(() => {
                        this.isLoading = false;
                    })
            })
    }

    handlePricingInformationResponse(batches) {
        // const endpoint = this.isValidTeamMember ? '/c/AceCustomersSummaryApp.app?batch=' : '/apex/ACE_Customer_List_Page?batch=';
        const endpoint = '/c/AceCustomersSummaryApp.app?batch=';
        batches.slice().forEach((value, index) => {
            batches[index].batchUrl = endpoint + value.batch;
            batches[index].percentIncrease = Math.abs(value ? value.percentIncrease / 100 : value);
            batches[index].annualSpend = Math.abs(value ? parseInt(value.annualSpend, 10) : value);
            batches[index].summaryTotal = Math.abs(value ? parseInt(value.summaryTotal, 10) : value);
        })
        this.data = batches;
    }

    handleApexExceptions(exception) {
        console.error(exception);
    }
}