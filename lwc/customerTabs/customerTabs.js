import { LightningElement, api, track } from 'lwc'
import getRecordType from '@salesforce/apex/Customer360Service.getRecordType'
import getGrandParent from '@salesforce/apex/Customer360Service.getGrandParent'
import getCustomer360Data from '@salesforce/apex/Customer360_New.getCustomer360Data'

export default class CustomerTabs extends LightningElement
{
	@api recordId

	@track aopsCustId
	@track employeeId
	@track isLoading
	@track hasGhostCard = null;
	@track EbizBillTerms = {};
	@track EbizARBalances = {};
	@track EbizCreditLimits = [];
	@track EbizBillContacts = [];
	@track EbizARCollector = {};
	@track EbizGrandParent = {};
	@track EbizAgingBucket = [];
	@track AOPSCustMasterDetails = {};
	@track AOPSCustPreferences = [];
	@track AOPSCustInstructions = [];
	@track AOPSTaxInfo = [];
	@track AOPSCorePricing = [];
	@track AOPSUniversalPricing = [];
	@track AOPSCustTierDisc = [];
	@track hasCorrectRecordType = false;
	@track factSheetData = {}

	connectedCallback ()
	{
		this.isLoading = true
		this.handleUrlParameters()
		this.handleCallOut()
	}

	handleUrlParameters ()
	{
		if (!this.recordId)
		{
			this.recordId = this.getUrlParameter()[ 'recordId' ] || this.getUrlParameter()[ 'id' ]
		}
		this.aopsCustId = this.getUrlParameter()[ 'aopscustid' ]
		this.employeeId = this.getUrlParameter()[ 'employeeid' ]
	}

	checkRecordType ()
	{
		const params = {
			'recordId': this.recordId,
			'aopsCustId': this.aopsCustId,
			'employeeId': this.employeeId
		}

		getRecordType({ params: params })
			.then(result =>
			{
				if (result == 'Customer' || result == 'Parent')
				{
					this.hasCorrectRecordType = true
				}
				else
				{
					this.hasCorrectRecordType = false
				}
			})
			.catch(error =>
			{
			})
	}

	handleCallOut ()
	{
		this.hasError = false

		const params = {
			'recordId': this.recordId,
			'aopsCustId': this.aopsCustId,
			'employeeId': this.employeeId
		}

		getRecordType({ params: params })
			.then(result =>
			{
				if (result == 'Customer' || result == 'Parent')
				{
					this.hasCorrectRecordType = true

					getCustomer360Data({ params })
						.then(response =>
						{
							this.hasGhostCard = response.ghostCard.hasGhostCard || null

							if (response.ebizCustomerInformation != null)
							{
								const ebizCustomerInformation = response.ebizCustomerInformation
								this.EbizBillTerms = ebizCustomerInformation.paymenttermstab != null ? ebizCustomerInformation.paymenttermstab.paymenttermstabitem : []
								this.EbizARBalances = ebizCustomerInformation.arcollectortab != null ? ebizCustomerInformation.arcollectortab.arcollectortabitem : []
								this.EbizCreditLimits = ebizCustomerInformation.creditlimtstab != null ? ebizCustomerInformation.creditlimtstab.creditlimtstabitem : []
								this.EbizBillContacts = ebizCustomerInformation.ebillcontacttab != null ? ebizCustomerInformation.ebillcontacttab.ebillcontacttabitem : []
								this.EbizARCollector = ebizCustomerInformation.arcollectortab != null ? ebizCustomerInformation.arcollectortab.arcollectortabitem : []
								this.EbizGrandParent = ebizCustomerInformation.grandparenttab != null ? ebizCustomerInformation.grandparenttab.grandparenttabitem : []
								this.EbizAgingBucket = ebizCustomerInformation.agingbuckettab != null ? ebizCustomerInformation.agingbuckettab.agingbuckettabitem : [];
								
								if (this.EbizCreditLimits != null)
								{
									this.EbizCreditLimits = this.EbizCreditLimits.filter(creditLimit => creditLimit.currencycode == 'USD')
								}
							}

							this.AOPSCustMasterDetails = response.customerMasterDetails || {}
							this.AOPSCustInstructions = response.customerInstructions || {}
							this.AOPSTaxInfo = response.taxInformation || {}
							this.AOPSCorePricing = response.corePricings || {}
							this.AOPSUniversalPricing = response.universalPricings || {}
							this.AOPSCustTierDisc = response.customerTierDiscounts || {}
							this.AOPSCustPreferences = response.customerPreferences || {}
							this.AOPSCustMasterDetails.SMALLORDERFEE = response.freightCharge ? response.freightCharge.freightFlag : null
							this.AOPSCustMasterDetails.DELIVER_CHARGE_CODE = response.deliveryChargeCode ? response.deliveryChargeCode.deliveryChargeCode : null
							this.factSheetData = response.factSheetData

							if (this.recordId == null) this.recordId = response.recordId

							getGrandParent({ params })
								.then(response =>
								{
									if (response && this.AOPSCustMasterDetails)
									{
										this.AOPSCustMasterDetails.GP_ID = response.AOPS_Cust_Id__c
										this.AOPSCustMasterDetails.GP_NAME = response.Name
									}
								})
								.catch(exception =>
								{
									console.error('Error while retrieving C360 data: ' + exception)
								})
								.finally(() =>
								{
									this.isLoading = false
								})
						})
						.catch(exception =>
						{
							console.error('Error while retrieving C360 data: ' + exception)
							this.isLoading = false
						})
				}
				else
				{
					this.hasCorrectRecordType = false
					this.isLoading = false
				}
			})
			.catch(error =>
			{
				console.error(error)
				this.hasCorrectRecordType = false
				this.isLoading = false
			})
	}

	getUrlParameter ()
	{
		var vars = {}
		var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value)
		{
			vars[ key ] = value
			vars[ key.toLowerCase() ] = value
			vars[ key.toUpperCase() ] = value
		})
		return vars
	}
}