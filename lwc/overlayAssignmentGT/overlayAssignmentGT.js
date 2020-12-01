import getAccountTeamMembers from '@salesforce/apex/OverlayListViewExtension.getAccountTeamMembers';
import GT_Name from '@salesforce/label/c.GT_Name';
import GT_Title from '@salesforce/label/c.GT_Title';
import GT_Role from '@salesforce/label/c.GT_Role';
import GT_Phone from '@salesforce/label/c.GT_Phone';
import GT_SalesRep from '@salesforce/label/c.GT_SalesRep';
import GT_NoRecords from '@salesforce/label/c.GT_NoRecords';
import { LightningElement, api, track } from 'lwc';

export default class OverlayAssignmentGT extends LightningElement
{
	@api recordId;

	@track data = [];
	@track columns = [
		{ label: GT_Name, fieldName: 'name' },
		{ label: GT_Title, fieldName: 'title' },
		{ label: GT_Role, fieldName: 'role' },
		{ label: GT_Phone, fieldName: 'phone' },
		// { label: GT_SalesRep, fieldName: 'salesRepId' },
	];

	get hasData () { return this.data.length > 0; }

	label = {
		GT_Name,
		GT_Title,
		GT_Role,
		GT_Phone,
		GT_SalesRep,
		GT_NoRecords
	}

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