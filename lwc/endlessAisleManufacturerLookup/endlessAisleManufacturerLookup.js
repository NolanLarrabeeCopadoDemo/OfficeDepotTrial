import {LightningElement, track, api} from 'lwc';
import * as EAU from 'c/endlessAisleUtilities';

export default class EndlessAisleManufacturerLookup extends LightningElement
{
	@api manufacturerOptions;
	@api isLoading;

	@track columns = [
		{label: 'Name', fieldName: 'name'},
		{label: 'ID', fieldName: 'id', initialWidth: 100}
	];
	@track allData = [];
	@track _manufacturerOptions = [];
	@track manufacturerName;
	@track isSomeLineItemSelected = false;
	@track hasRendered = false;

	get selectedRows ()
	{
		if (this.template && this.template.querySelector('lightning-datatable'))
		{
			return this.template.querySelector('lightning-datatable').getSelectedRows();
		}
	}
	get lightningDatatable () {return this.template ? this.template.querySelector('lightning-datatable') : null;}

	renderedCallback ()
	{
		if (this.hasRendered === false)
		{
			this.hasRendered = true;
			this.onFirstRender();
		}
	}
	onFirstRender ()
	{
		this.transitionIntoView();
	}
	transitionIntoView ()
	{
		if (this.template)
		{
			const transitionElement = this.template.querySelector('.moe-transition');
			void transitionElement.offsetWidth;
			transitionElement.classList.remove('slds-transition-hide');
		}
	}
	connectedCallback ()
	{
		this.refresh();
	}
	onClose (event)
	{
		this.dispatchEvent(new CustomEvent('close'));
	}
	onSetManufacturer (event)
	{
		this.dispatchEvent(new CustomEvent('setmanufacturer', {detail: {manufacturer: this.selectedRows[ 0 ]}}));
	}
	onSearchClick (event)
	{
		if (!this.manufacturerName && this.manufacturerName !== 0)
		{
			this.clearSearch();
		}
		else
		{
			this.search();
		}
	}
	onSearchChange (event)
	{
		this.manufacturerName = event.target.value;
	}
	onSearchKeyPress (event)
	{
		if (event.key === 'Enter')
		{
			if (!this.manufacturerName && this.manufacturerName !== 0)
			{
				this.clearSearch();
			}
			else
			{
				this.search();
			}
		}
	}
	onTableRowSelection (event)
	{
		this.isSomeLineItemSelected = event.detail.selectedRows.length > 0;
	}
	search (event)
	{
		this.dispatchEvent(new CustomEvent('search', {detail: {manufacturerName: this.manufacturerName}}));
	}
	@api refresh ()
	{
		this.clearSelectedRows();
		this._manufacturerOptions = EAU.clone(this.manufacturerOptions);
	}
	clearSearch ()
	{
		this.refresh();
	}
	clearSelectedRows ()
	{
		if (this.lightningDatatable)
		{
			this.lightningDatatable.selectedRows = [];
			this.isSomeLineItemSelected = false;
		}
	}
}