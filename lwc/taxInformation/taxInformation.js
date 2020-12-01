import { LightningElement, api } from 'lwc';
export default class TaxInformation extends LightningElement
{
	@api aopsCustMasterDetails = {};
	@api aopsTaxInfo = [];

	get hasError ()
	{
		return !this.aopsCustMasterDetails || !this.aopsTaxInfo;
	}
}