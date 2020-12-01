import { LightningElement, track } from 'lwc';
import getQuote from '@salesforce/apex/EndlessAisleInternalApproval.getQuote';
import getApprovalUsers from '@salesforce/apex/EndlessAisleInternalApproval.getApprovalUsers';
import getApprovalGroups from '@salesforce/apex/EndlessAisleInternalApproval.getApprovalGroups';
import initiateApprovalProcess from '@salesforce/apex/EndlessAisleInternalApproval.initiateApprovalProcess';

export default class Endless_Aisle_Internal_Approval extends LightningElement {
    @track quote;
    @track approvalGroups;
    @track approvalUsers;
    @track noApprovalGroups
    @track noApprovalUsers;
    @track submitted;
    @track errorMessage;

    // Called on page initialization.
    connectedCallback() {
        this.preparePage();
    }

    // Loads in the data used by the page.
    async preparePage() {
        try {
            let quoteId = this.getQuoteIdFromUrlParams();
            
            this.quote = await getQuote({ quoteId: quoteId });
            if(this.quote.Internal_Approval_Status__c) {
                throw { body: { message: 'Quote has already been submitted for internal approval.' } };
            }
            
            this.approvalGroups = await getApprovalGroups({ quoteId: quoteId });
            if(this.approvalGroups.length === 0) this.noApprovalGroups = true;
            
            this.approvalUsers = await getApprovalUsers({ quoteId: quoteId });
            if(this.approvalUsers.length === 0) this.noApprovalUsers = true;
        } catch(ex) {
            this.errorMessage = ex.body.message;
        }
    }

    getQuoteIdFromUrlParams() {
        let quoteId = '';
        let splitUrl = window.location.search.split('id=');
        if(splitUrl.length < 2) {
            throw { body: { message: 'Quote Id not present in the URL parameters.' } };
        }
        quoteId = window.location.search.split('id=')[1];
        return quoteId;
    }

    async submit() {
        try {
            await initiateApprovalProcess({ quoteId: this.quote.Id });
            this.submitted = true;
        } catch(ex) {
            this.errorMessage = ex.body.message;
        }
    }
}