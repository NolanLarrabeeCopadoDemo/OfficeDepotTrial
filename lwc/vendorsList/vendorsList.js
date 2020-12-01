import {LightningElement, track, wire, api} from "lwc";
import getVendorList from "@salesforce/apex/VendorsController.getVendorList";
import {NavigationMixin} from "lightning/navigation";
import VendorCaseCreate from "@salesforce/apex/VendorsController.VendorCaseCreate";
import OD_LOGO from '@salesforce/resourceUrl/ODHorizontalLogoRed';

// datatable columns with row actions
const columns = [
	{label: "Vendor Name", fieldName: "name"},
	{
		label: "Vendor Number",
		fieldName: "VenNum",
		cellAttributes: {alignment: "left"}
	},
	{label: "Email", fieldName: "Email", type: "email"},
	{label: "Vendor Comments", fieldName: "Comment"},
	{
		type: "button-icon",
		fixedWidth: 60,
		cellAttributes: {alignment: "center"},
		typeAttributes: {iconName: "utility:edit", name: "add_comment"}
	}
];

var extractedRecordId;

export default class vendorsList extends NavigationMixin(LightningElement) {
	@track data;
	@track columns = columns;
	@api item;
	@api recId;
	@track input;
	@track VenId;
	@track indComm;
	@track AC = false;
	selectedIdsArray = [];
	connectedCallback ()
	{
		var search = location.search.substring(1);
		extractedRecordId = search.split("=")[ 1 ];
		console.log(search);
		console.log(extractedRecordId);
		
	}
	@wire(getVendorList,{qid :'$recId'}) deWired ({error, data})
	{
		if (data)
		{
			this.data = [];
			for (let vendor of data)
			{
				let object = {
					name: vendor.Name,
					VenNum: vendor.VendorNum__c,
					Email: vendor.Email__c,
					Comment: vendor.Rep_Comment__c,
					Id: vendor.Id
				};
				this.data.push(object);
			}
		}
	}

	OnRowSelection (event)
	{
		this.selectedIdsArray = event.detail.selectedRows;
		console.log(event.detail.selectedRows);
	}

	connectedCallback ()
	{
		var search = location.search.substring(1);
		extractedRecordId = search.split("=")[ 1 ];
		console.log(search);
		console.log(extractedRecordId);
		console.log("inside CreateCase");
	}

	onTableCellChange (event)
	{
		for (let vendor of this.data)
		{
			for (let value of event.detail.draftValues)
			{
				if (vendor.Id == value.Id)
				{
					vendor.Comment = value.Comment;
				}
			}
		}
		let datatable = this.template.querySelector("lightning-datatable");
		datatable.draftValues = null;
	}

	changeHandler (event)
	{
		this.input = event.target.value;
	}

	onClose ()
	{
		this.AC = false;
	}

	get odLogoUrl ()
	{
		return OD_LOGO;
	}

	onIndCommChange (event)
	{
		this.indComm = event.target.value;
	}

	onCommentSave ()
	{
		let table = [ ...this.data ];
		let updatedTableRow = table.find(element => element.Id == this.VenId);
		if (updatedTableRow !== undefined)
		{
			updatedTableRow.Comment = this.indComm;
			this.data = table;
		}

		let updatedRows = [ ...this.selectedIdsArray ];
		updatedTableRow = updatedRows.find(element => element.Id == this.VenId);
		if (updatedTableRow !== undefined)
		{
			updatedTableRow.Comment = this.indComm;
			this.selectedIdsArray = updatedRows;
		}

		this.AC = false;
	}

	onTableRowAction (event)
	{
		try
		{
			let actionName = event.detail.action.name;
			let row = event.detail.row;
			this.VenId = event.detail.row.Id;
			if (actionName == "add_comment")
			{
				console.log("AC is true");
				this.AC = true;
				this.indComm = event.detail.row.Comment;
			}
		} catch (exception)
		{
			console.error(
				`Error in [endlessAisleProductSearch@onTableRowAction]: ${ exception.message }`
			);
		}
	}

	sendEmailTocustomer ()
	{
		var selectedRows = [];
		for (let element of this.selectedIdsArray)
		{
			console.log(element);
			console.log("elementid", element.Id);
			selectedRows.push({Id: element.Id, Comment: element.Comment});
			console.log("selected array is", selectedRows);
		}
		VendorCaseCreate({
			qid: extractedRecordId,
			comAndids: selectedRows,
			GlobalComment: this.input
		});
		this.template.querySelector("lightning-datatable").selectedRows = [];
		window.location.href =
			window.location.origin +
			"/lightning/r/Quote/" +
			extractedRecordId +
			"/view";
	}
}