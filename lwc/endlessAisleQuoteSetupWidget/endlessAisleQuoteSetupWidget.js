import {LightningElement, track, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getTechQuoteWizardValues from '@salesforce/apex/EndlessAisleQuoteSetup.getTechQuoteWizardValues';
import setTechQuoteWizardValues from '@salesforce/apex/EndlessAisleQuoteSetup.setTechQuoteWizardValues';
import getFieldRestrictions from '@salesforce/apex/EndlessAisleQuoteSetup.getFieldRestrictions';

export default class EndlessAisleQuoteSetupWidget extends LightningElement
{
	@api recordId;
	@track costCenter = {
		value: null,
		code: null,
		get isVisible ()
		{
			return this.code !== 'H';
		}
	};
	@track poNumber = {
		value: null,
		code: null,
		get isVisible ()
		{
			return this.code !== 'H';
		}
	};
	@track desktopNumber = {
		value: null,
		code: null,
		get isVisible ()
		{
			return this.code !== 'H';
		}
	};
	@track releaseNumber = {
		value: null,
		code: null,
		get isVisible ()
		{
			return this.code !== 'H';
		}
	};
	@track shipTo = {
		value: null,
		recordId: null,
		get url ()
		{
			return this.recordId ? `/lightning/r/${ this.recordId }/view` : '#';
		},
		code: null
	};
	@track contact = {
		value: null,
		recordId: null,
		code: null,
		get url ()
		{
			return this.recordId ? `/lightning/r/${ this.recordId }/view` : '#';
		}
	};
	@track isLoading = false;
	@track isEditing = false;

	connectedCallback ()
	{
		this.isLoading = true;
		this.loadInitialValues();
		getFieldRestrictions({quoteId: this.recordId})
			.then(response =>
			{
				response = JSON.parse(response)[ 0 ];
				if (response)
				{
					this.costCenter.code = response.DEPT_REQUIRED_CODE__c;
					this.poNumber.code = response.PO_REQUIRED_CODE__c;
					this.desktopNumber.code = response.LOCATION_REQ_CODE_7__c;
					this.releaseNumber.code = response.RELEASE_REQUIRED_CODE__c;
				}
			})
			.catch(error =>
			{

			})
			.finally(() =>
			{
				this.isLoading = false;
			});
	}
	loadInitialValues ()
	{
		getTechQuoteWizardValues({quoteId: this.recordId})
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this.costCenter.value = response.costCenter;
					this.poNumber.value = response.poNumber;
					this.desktopNumber.value = response.desktopNumber;
					this.releaseNumber.value = response.releaseNumber;
					this.shipTo.value = response.shipTo.name;
					this.shipTo.recordId = response.shipTo.recordId;
					this.contact.value = response.contact.name;
					this.contact.recordId = response.contact.recordId;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
			});
	}
	onEditClick (event)
	{
		this.isEditing = true;
	}
	onPopupCloseClick (event)
	{
		this.isEditing = false;
	}
	onPopupSaveChangesClick (event)
	{
		this.isEditing = false;
		this.isLoading = true;

		this.costCenter = event.detail.costCenter || null;
		this.poNumber = event.detail.poNumber || null;
		this.desktopNumber = event.detail.desktopNumber || null;
		this.releaseNumber = event.detail.releaseNumber || null;
		this.shipTo = event.detail.shipTo || null;
		this.contact = event.detail.contact || null;

		let params =
		{
			costCenter: this.costCenter.value,
			poNumber: this.poNumber.value,
			desktopNumber: this.desktopNumber.value,
			releaseNumber: this.releaseNumber.value,
			shipTo: this.shipTo.recordId,
			contact: this.contact.recordId
		};

		// if (event.detail.costCenter)
		// {
		// 	this.costCenter = event.detail.costCenter;
		// 	params.costCenter = event.detail.costCenter.value;
		// }
		// if (event.detail.poNumber)
		// {
		// 	this.poNumber = event.detail.poNumber;
		// 	params.poNumber = event.detail.poNumber.value;
		// }
		// if (event.detail.desktopNumber)
		// {
		// 	this.desktopNumber = event.detail.desktopNumber;
		// 	params.desktopNumber = event.detail.desktopNumber.value;
		// }
		// if (event.detail.releaseNumber)
		// {
		// 	this.releaseNumber = event.detail.releaseNumber;
		// 	params.releaseNumber = event.detail.releaseNumber.value;
		// }
		// if (event.detail.shipTo)
		// {
		// 	this.shipTo = event.detail.shipTo;
		// 	params.shipTo = event.detail.shipTo.recordId;
		// }
		// if (event.detail.contact)
		// {
		// 	this.contact = event.detail.contact;
		// 	params.contact = event.detail.contact.recordId;
		// }

		if (Object.keys(params).length > 0)
		{
			setTechQuoteWizardValues({quoteId: this.recordId, params: params})
				.then(response =>
				{
					if (response === true)
					{
						this.dispatchEvent(new ShowToastEvent(
							{
								title: 'Quote updated successfully.',
								message: 'The quote\'s accounting fields were updated.',
								variant: 'success'
							}));
						this.loadInitialValues();
					}
					else if (response === false)
					{
						this.dispatchEvent(new ShowToastEvent(
							{
								title: 'Quote failed to update.',
								message: 'The quote\'s accounting fields failed to update. Please try again.',
								variant: 'error'
							}));
					}
				})
				.catch(error =>
				{
					this.dispatchEvent(new ShowToastEvent(
						{
							title: 'Quote failed to update.',
							message: 'The quote\'s accounting fields failed to update. Please try again.',
							variant: 'error'
						}));
				})
				.finally(() =>
				{
					this.isLoading = false;
				});
		}
		else
		{
			this.isLoading = false;
		}
	}
}