/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';
import getCustomLinks from '@salesforce/apex/CustomLinks.getCustomLinks';

export default class CustomLinks extends LightningElement
{
	@api recordId;
	@api objectApiName;

	@track isLoading = false;
	@track sections = [];

	get hasLinks ()
	{
		return this.sections.length > 0;
	}

	connectedCallback ()
	{
		this.isLoading = true;
		getCustomLinks({ objectApiName: this.objectApiName, recordId: this.recordId })
			.then(response =>
			{
				response = JSON.parse(response);
				this.sections = response;
			})
			.catch(error =>
			{
				console.log(error);
			})
			.finally(() =>
			{
				this.isLoading = false;
			})
	}
}