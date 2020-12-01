import { LightningElement, api } from 'lwc';
export default class TaxInformation extends LightningElement
{
	@api aopsCustInstructions = [];

	get hasError ()
	{
		return !this.aopsCustInstructions;
	}
}