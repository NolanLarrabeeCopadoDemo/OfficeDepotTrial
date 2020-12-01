import { LightningElement, track, api } from 'lwc';

export default class TaxInformation extends LightningElement
{
	@api aopsCustMasterDetails;
	@api aopsCorePricing = [];
	@api aopsUniversalPricing = [];
	@api aopsCustTierDisc = [];

	get _aopsCustMasterDetails () { return this.aopsCustMasterDetails || {}; }
	get _aopsCorePricing () { return this.aopsCorePricing || []; }
	get _aopsUniversalPricing () { return this.aopsUniversalPricing || []; }
	get _aopsCustTierDisc () { return this.aopsCustTierDisc || []; }
	get offContractPricing () { return `${ this._aopsCustMasterDetails.OFF_CONTRACT_PRICE_CODE }${ Number(this._aopsCustMasterDetails.OFF_CONTRAT_PRCT) * 100 }`; }
	get wholesalerPricing () { return `${ this._aopsCustMasterDetails.WHOLESALER_PRICE_CODE }${ (Number(this._aopsCustMasterDetails.WHOLESALER_PRICE_DISCOUNT_PRCT) * 100) }`; }
	get gpFloor () { return `${ Number(this._aopsCustMasterDetails.GP_FLOOR) * 100 }%`; }

	@track CP = {
		parent: this,
		get data ()
		{
			let data = [];
			if (this.parent._aopsCorePricing)
			{
				for (let corePricing of this.parent._aopsCorePricing)
				{
					data.push(
						{
							'listId': corePricing.itemId,
							'description': corePricing.itemDescription,
							'priority': corePricing.itemPiceCode,
							'startDate': corePricing.startDate,
							'endDate': corePricing.endDate
						}
					);
				}
			}
			return data;
		},
		columns: [
			{ label: 'List ID', fieldName: 'listId', type: 'text' },
			{ label: 'Description', fieldName: 'description', type: 'text' },
			{ label: 'Priority', fieldName: 'priority', type: 'text' },
			{ label: 'Start Date', fieldName: 'startDate', type: 'text' },
			{ label: 'End Date', fieldName: 'endDate', type: 'text' },
		]
	};

	get hasError ()
	{
		return !this.aopsCustTierDisc;
	}
}