import { LightningElement, api, track } from 'lwc';
import GetSPCCardInfoProcessService from '@salesforce/apex/GetSPCCardInfoProcessService.processMethod';

export default class Customerspcinformationtab extends LightningElement
{
	@api recordId;
	@api aopsCustId;

	@track email;
	@track emailSent = false;
	@track hasError = false;
	@track spcCardInfo = [];

	get hasCustomerInfo () { return !!this._spcCardInfo; }
	get _spcCardInfo () { return this.spcCardInfo || []; }

	connectedCallback ()
	{
		this.handleCallOut();
	}

	handleCallOut ()
	{
		this.hasError = false;

		const params = {
			"recordId": this.recordId,
			"aopsCustId": this.aopsCustId
		};

		GetSPCCardInfoProcessService({ params })
			.then(result =>
			{
				if (result)
				{
					this.spcCardInfo = result;
				}
				else
				{
					this.hasError = true;
				}
			})
			.catch(error =>
			{
				this.hasError = true;
			})
			.finally(() =>
			{

			});
	}
}