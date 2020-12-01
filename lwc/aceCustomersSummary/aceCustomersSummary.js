import { LightningElement, track } from 'lwc';
import getCustomersApprovalRequired from '@salesforce/apex/ACECustomersSummary.getCustomersApprovalRequired';
import getCustomersNotificationRequired from '@salesforce/apex/ACECustomersSummary.getCustomersNotificationRequired';
import getCustomersNoRequirements from '@salesforce/apex/ACECustomersSummary.getCustomersNoRequirements';
import getCustomersApprovalRequiredSummary from '@salesforce/apex/ACECustomersSummary.getCustomersApprovalRequiredSummary';
import getCustomersNotificationRequiredSummary from '@salesforce/apex/ACECustomersSummary.getCustomersNotificationRequiredSummary';
import getCustomersNoRequirementsSummary from '@salesforce/apex/ACECustomersSummary.getCustomersNoRequirementsSummary';

export default class AceCustomersSummary extends LightningElement {
    @track batch;
    @track isLoading = true;
    @track searchValue;
    @track activeSections = ['approvalRequired', 'notificationRequired', 'noRequirements'];
    @track ownership = 'all';
    @track ownershipOptions = [
        { label: 'All', value: 'all' },
        { label: 'Owned by me', value: 'ownedByMe' },
        { label: 'Owned by my team', value: 'ownedByMyTeam' }
    ]
    @track approvalRequired = {
        component: this,
        columns: [],
        allData: [],
        filteredData: [],
        summaryData: [],
        get data() {
            return this.component.searchValue ? this.filteredData : this.allData;
        }
    }
    @track notificationRequired = {
        component: this,
        columns: [],
        allData: [],
        filteredData: [],
        summaryData: [],
        get data() {
            return this.component.searchValue ? this.filteredData : this.allData;
        }
    }
    @track noRequirements = {
        component: this,
        columns: [],
        allData: [],
        filteredData: [],
        summaryData: [],
        get data() {
            return this.component.searchValue ? this.filteredData : this.allData;
        }
    }

    connectedCallback() {
        this.init();
    }

    onOwnershipChange(event) {
        this.ownership = event.detail.value;
        this.getData();
    }

    onSearchValueChange(event) {
        this.searchValue = event.detail.value;
        this.updateFilteredData();
    }

    init() {
        this.isLoading = true;
        this.getUrlParameters();
        this.initializeColumns();
        this.getData();
    }

    updateFilteredData() {
        if (this.searchValue) {
            const isTableRowValid = (tableRow) => {
                return (tableRow.customerId && tableRow.customerId.toLowerCase().startsWith(this.searchValue.toLowerCase())) ||
                    (tableRow.customerName && tableRow.customerName.toLowerCase().startsWith(this.searchValue.toLowerCase())) ||
                    (tableRow.repName && tableRow.repName.toLowerCase().startsWith(this.searchValue.toLowerCase()));
            }
            this.approvalRequired.filteredData = this.approvalRequired.allData.filter(isTableRowValid);
            this.notificationRequired.filteredData = this.notificationRequired.allData.filter(isTableRowValid);
            this.noRequirements.filteredData = this.noRequirements.allData.filter(isTableRowValid);
        }
        else {
            this.approvalRequired.filteredData = this.approvalRequired.allData;
            this.notificationRequired.filteredData = this.notificationRequired.allData;
            this.noRequirements.filteredData = this.noRequirements.allData;
        }
    }

    getUrlParameters() {
        let urlParameters = location.search.substring(1).split('&');
        for (let parameter of urlParameters) {
            let split = parameter.split('=');
            let key = split[0];
            let value = split[1];

            if (key.toLowerCase() === 'batch') {
                this.batch = value;
            }
        }
    }

    getData() {
        this.isLoading = true;
        const approvalRequired = getCustomersApprovalRequired({ batch: this.batch, ownership: this.ownership })
            .then(response => {
                response = JSON.parse(response);
                this.approvalRequired.allData = response;
            })
            .catch(exception => {
                console.error(exception);
            })
        const notificationRequired = getCustomersNotificationRequired({ batch: this.batch, ownership: this.ownership })
            .then(response => {
                response = JSON.parse(response);
                this.notificationRequired.allData = response;
            })
            .catch(exception => {
                console.error(exception);
            })
        const noRequirements = getCustomersNoRequirements({ batch: this.batch, ownership: this.ownership })
            .then(response => {
                response = JSON.parse(response);
                this.noRequirements.allData = response;
            })
            .catch(exception => {
                console.error(exception);
            })
        const approvalRequiredSummary = getCustomersApprovalRequiredSummary({ batch: this.batch, ownership: this.ownership })
            .then(response => {
                const data = JSON.parse(response);
                data.customerCount = parseInt(data.customerCount, 10);
                data.annualSpend = parseFloat(data.annualSpend).toFixed(2);
                data.spendImpactPercent = parseFloat(data.spendImpactPercent).toFixed(2);
                data.percentIncrease = parseFloat(data.percentIncrease).toFixed(2);
                data.summaryTotal = parseFloat(data.summaryTotal).toFixed(2);
                this.approvalRequired.summaryData = data;
            })
            .catch(exception => {
                console.error(exception);
            })
        const notificationRequiredSummary = getCustomersNotificationRequiredSummary({ batch: this.batch, ownership: this.ownership })
            .then(response => {
                const data = JSON.parse(response);
                data.customerCount = parseInt(data.customerCount, 10);
                data.annualSpend = parseFloat(data.annualSpend).toFixed(2);
                data.spendImpactPercent = parseFloat(data.spendImpactPercent).toFixed(2);
                data.percentIncrease = parseFloat(data.percentIncrease).toFixed(2);
                data.summaryTotal = parseFloat(data.summaryTotal).toFixed(2);
                this.notificationRequired.summaryData = data;
            })
            .catch(exception => {
                console.error(exception);
            })
        const noRequirementsSummary = getCustomersNoRequirementsSummary({ batch: this.batch, ownership: this.ownership })
            .then(response => {
                const data = JSON.parse(response);
                data.customerCount = parseInt(data.customerCount, 10);
                data.annualSpend = parseFloat(data.annualSpend).toFixed(2);
                data.spendImpactPercent = parseFloat(data.spendImpactPercent).toFixed(2);
                data.percentIncrease = parseFloat(data.percentIncrease).toFixed(2);
                data.summaryTotal = parseFloat(data.summaryTotal).toFixed(2);
                this.noRequirements.summaryData = data;
            })
            .catch(exception => {
                console.error(exception);
            })
        Promise.all([approvalRequired, notificationRequired, noRequirements,
                    approvalRequiredSummary, notificationRequiredSummary, noRequirementsSummary])
            .finally(() => {
                this.isLoading = false;
            })
    }

    initializeColumns() {
        const columns = [
            { label: 'Customer Id', fieldName: 'customerId' },
            { label: 'Customer', fieldName: 'customerName' },
            { label: '# Impacted Cores', fieldName: 'numberOfImpactedCores', type: 'number' },
            { label: '# SKUs Governed by Active Written Agreement', fieldName: 'numberOfSkusGovernedByActiveWrittenAgreement', type: 'number' },
            { label: 'Average SKU Increase', fieldName: 'averageSkuIncrease', type: 'percent' },
            { label: 'Annual Spend', fieldName: 'annualSpend', type: 'currency', typeAttributes: { currencyCode: 'USD' } },
            { label: 'Estimated Total Annual Spend Change', fieldName: 'estimatedTotalAnnualSpendChange', type: 'currency', typeAttributes: { currencyCode: 'USD' } },
            { label: 'Estimated Average Annual Spend Impact', fieldName: 'estimatedAverageAnnualSpendImpact', type: 'percent' },
            { label: 'Total SRM Impact', fieldName: 'totalSrmImpact', type: 'currency', typeAttributes: { currencyCode: 'USD' } },
            { label: 'Notification Status', fieldName: 'notificationStatus' },
            { label: 'Notification Date', fieldName: 'notificationDate' },
            { label: 'Price Change Status', fieldName: 'priceChangeStatus' },
            { label: 'Price Change Effective Date', fieldName: 'priceChangeEffectiveDate' },
        ];

        this.approvalRequired.columns = columns;
        this.notificationRequired.columns = columns;
        this.noRequirements.columns = columns;
    }

    onViewAllImpactedSkusClick() {
        window.open(`/apex/ACE_SKU_List?batch=${this.batch}`);
    }

    onViewAllImpactedCustomersClick() {
        window.open(`/apex/ACE_Customer_List_Page?batch=${this.batch}`);
    }
}