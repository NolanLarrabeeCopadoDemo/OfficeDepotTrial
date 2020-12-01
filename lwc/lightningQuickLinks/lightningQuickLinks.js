/* eslint-disable no-console */
import { LightningElement, track } from 'lwc';
import getQuickLinks from '@salesforce/apex/QuickLinks.getQuickLinks';
import Id from '@salesforce/user/Id';

export default class LightningQuickLinks extends LightningElement
{
	@track isLoading = false;
	@track sections = [];

	get hasLinks ()
	{
		return this.sections.length > 0;
	}

	connectedCallback ()
	{
		this.isLoading = true;
		getQuickLinks({ userId: Id })
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this.sections = response;
				}
			})
			.catch(error =>
			{
				console.log(error.body.message);
			})
			.finally(() =>
			{
				this.isLoading = false;
			})
	}
}