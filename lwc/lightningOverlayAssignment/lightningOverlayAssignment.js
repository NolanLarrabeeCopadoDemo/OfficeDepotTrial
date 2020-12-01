import { LightningElement, api, track } from 'lwc';
import getAccountTeamMembers from '@salesforce/apex/OverlayListViewExtension.getAccountTeamMembers';

export default class LightningOverlayAssignment extends LightningElement
{
	@api recordId;
	@track data = [];
	@track columns = [
		{ label: 'Name', fieldName: 'name' },
		{ label: 'Title', fieldName: 'title' },
		{ label: 'Role', fieldName: 'role' },
		{ label: 'Phone', fieldName: 'phone' },
		// { label: 'Sales Rep ID', fieldName: 'salesRepId' },
	];
	get hasData () { return this.data.length > 0; }

	connectedCallback ()
	{
		this.fetchData();
	}
	handleResponse (teamMembers)
	{
		this.data = [];
		for (let teamMember of teamMembers)
		{
			let formattedTeamMember = {
				id: teamMember.Id,
				// salesRepId: teamMember.TeamMemberRole
			}
			
			if (teamMember.User)
			{
				formattedTeamMember.name = teamMember.User.Name;
				formattedTeamMember.title = teamMember.User.Short_Title__c;
				formattedTeamMember.phone = teamMember.User.Phone;

				if (teamMember.User.UserRole)
				{
					formattedTeamMember.role = teamMember.User.UserRole.Name;
				}
			}

			this.data.push(formattedTeamMember);
		}
	}
	fetchData ()
	{
		getAccountTeamMembers({ accountId: this.recordId })
			.then(response =>
			{
				if (response)
				{
					this.handleResponse(response);
				}
			})
			.catch(error =>
			{

			})
			.finally(() =>
			{

			})
	}
}