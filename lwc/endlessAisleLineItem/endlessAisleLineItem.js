/* eslint-disable no-console */
import {LightningElement, track, api} from 'lwc';
import * as EAU from 'c/endlessAisleUtilities';

export default class EndlessAisleLineItem extends LightningElement
{
	@api index;
	// This variable receives the line item data
	@api lineItemData;
	// This variable receives whether the line item is selected/checked or not.
	@api isSelected = false;

	@track _lineItemData;
	@track isExpanded = false;
	@track expandedDivClass = 'display: none';
	@track isMarginPercentSelected = true;
	@track isMarginDollarSelected = false;
	@track isValid = false;
	@track expandButtonClass = 'slds-transition-show';
	@track collapseButtonClass = 'slds-transition-hide';
	@track editValuesButtonMenuLabel = 'Show Edit Values';
	@track hasRendered = false;

	get isUpcAvailable ()
	{
		return this._lineItemData.upcCode || this._lineItemData.upcCode === 0 ? true : false;
	}
	get isMpnAvailable ()
	{
		return this._lineItemData.mfgPartNumber || this._lineItemData.mfgPartNumber === 0 ? true : false;
	}
	get isMfgIdAvailable ()
	{
		return this._lineItemData.vendorManufacturerId || this._lineItemData.mfgPartNumber === 0 ? true : false;
	}
	get wasCostModified ()
	{
		return EAU.toSimpleNumber(this._lineItemData.originalCost) !== EAU.toSimpleNumber(this._lineItemData.adjustedCost);
	}
	get lineItemClass ()
	{
		return 'slds-grid slds-card slds-m-bottom_medium od-small-boxshadow-onhover od-line-item'.concat(!this.isValid ? ' has-error' : '');
	}

	renderedCallback ()
	{
		try
		{
			if (this.template)
			{
				if (this.isMarginPercentSelected)
				{
					let marginPercentOption = this.template.querySelector('.percent-1');
					if (marginPercentOption)
					{
						// Workaround to manually toggle the slds-input checkbox button
						marginPercentOption.checked = true;
					}
				}
				else if (this.isMarginDollarSelected)
				{
					let marginDollarOption = this.template.querySelector('.dollar-1');
					if (marginDollarOption)
					{
						// Workaround to manually toggle the slds-input checkbox button
						marginDollarOption.checked = true;
					}
				}
			}
			if (this.hasRendered === false)
			{
				this.hasRendered = true;
				this.onFirstRender();
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@renderedCallback]: ${ exception.message }`);
		}
	}

	onFirstRender ()
	{
	}

	onInputBlur (event)
	{
		try
		{
			this.dispatchEvent(new CustomEvent('inputblur'));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onInputBlur]: ${ exception.message }`);
		}
	}

	connectedCallback ()
	{
		try
		{
			// Must clone the received line item data.
			// Variables decorated with @api cannot be modified, as they are cached.
			this._lineItemData = EAU.clone(this.lineItemData);

			if ((this._lineItemData.max_list_price || this._lineItemData.max_list_price === 0) && !this._lineItemData.maxListPrice)
			{
				this._lineItemData.maxListPrice = this._lineItemData.max_list_price;
			}

			// Calculate the margin and subtotal
			this.refreshMargin();
			this.refreshSubtotal();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@connectedCallback]: ${ exception.message }`);
		}
	}

	/**
	 * Opens the UPC lookup page in a new tab. Triggered whenever the UPC Lookup button is
	 * clicked from the button menu dropdown.
	 */
	onUPCLookupClick ()
	{
		try
		{
			let upcCode = this._lineItemData.upcCode;
			let baseUrl = 'https://www.barcodelookup.com/';
			let endpoint = baseUrl + upcCode;
			window.open(endpoint, '_blank');
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onUPCLookupClick]: ${ exception.message }`);
		}
	}

	/**
	 * Displays the More Details modal.
	 */
	onMoreDetailsClick ()
	{
		try
		{
			this.dispatchEvent(new CustomEvent('openmoredetails', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onMoreDetailsClick]: ${ exception.message }`);
		}
	}

	/**
	 * Dispatches an event to the parent component stating that this line item wants to be removed.
	 */
	onRemoveClick ()
	{
		try
		{
			this.dispatchEvent(new CustomEvent('remove', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onRemoveClick]: ${ exception.message }`);
		}
	}

	/**
	 * Expands the line item to display more fields the user is able to edit.
	 */
	onEditValuesClick (event)
	{
		this.isExpanded = !this.isExpanded;

		if (this.isExpanded === true)
		{
			this.editValuesButtonMenuLabel = 'Hide Edit Values';
			this.expandButtonClass = 'slds-transition-hide';
			this.collapseButtonClass = 'slds-transition-show';
			this.expandedDivClass = 'display: block';
		}
		else if (this.isExpanded === false)
		{
			this.editValuesButtonMenuLabel = 'Edit Values';
			this.expandButtonClass = 'slds-transition-show';
			this.collapseButtonClass = 'slds-transition-hide';
			this.expandedDivClass = 'display: none';
		}
	}

	/**
	 * Handles when percent margin button is clicked.
	 * @param {event} event 
	 */
	onMarginPercentSelection (event)
	{
		try
		{
			if (event.target.checked === true)
			{
				this.isMarginDollarSelected = false;
				this.isMarginPercentSelected = true;
				this.refreshUnitPrice();
				this.refreshSubtotal();
				this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onMarginPercentSelection]: ${ exception.message }`);
		}
	}

	/**
	 * Handles when dollar margin button is clicked.
	 * @param {event} event 
	 */
	onMarginDollarSelection (event)
	{
		try
		{
			if (event.target.checked === true)
			{
				this.isMarginPercentSelected = false;
				this.isMarginDollarSelected = true;
				this.refreshUnitPrice();
				this.refreshSubtotal();
				this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onMarginDollarSelection]: ${ exception.message }`);
		}
	}

	/**
	 * Handles when the shipping amount is changed
	 * @param {event} event 
	 */
	onShippingChange (event)
	{
		try
		{
			this.setShipping(event.target.value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onShippingChange]: ${ exception.message }`);
		}
	}

	/**
	 * Handles selecting the line item.
	 * @param {event} event 
	 */
	onSelectionChange (event)
	{
		try
		{
			this.isSelected = event.target.checked;
			this.dispatchEvent(new CustomEvent('selectionchange', {detail: {selected: this.isSelected, item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onSelectionChange]: ${ exception.message }`);
		}
	}

	/**
	 * Handles when the quantity is changed.
	 * @param {event} event 
	 */
	onQuantityChange (event)
	{
		try
		{
			let value = event.target.value;
			this.setQuantity(value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onQuantityChange]: ${ exception.message }`);
		}
	}

	/**
	 * Handles when the cost is changed.
	 * @param {event} event 
	 */
	onCostChange (event)
	{
		try
		{
			let value = event.target.value;
			this.setCost(value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onCostChange]: ${ exception.message }`);
		}
	}

	/**
	 * Handles when the unit price is changed
	 * @param {event} event 
	 */
	onUnitPriceChange (event)
	{
		try
		{
			let value = event.target.value;
			this.setUnitPrice(value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onUnitPriceChange]: ${ exception.message }`);
		}
	}

	/**
	 * Handles whenever the percent margin is changed
	 * @param {event} event 
	 */
	onMarginPercentChange (event)
	{
		try
		{
			let value = EAU.toSimpleNumber(event.target.value);
			this.setMarginPercent(value);
			this.refreshUnitPrice();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onMarginPercentChange]: ${ exception.message }`);
		}
	}

	/**
	 * Handles whenever the dollar margin is changed
	 * @param {event} event 
	 */
	onMarginDollarChange (event)
	{
		try
		{
			let value = EAU.toSimpleNumber(event.target.value);
			this.setMarginDollar(value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onMarginDollarChange]: ${ exception.message }`);
		}
	}

	/**
	 * Handles whenever the vendor quote number is changed
	 * @param {event} event 
	 */
	onVendorQuoteNumberChange (event)
	{
		try
		{
			let value = event.target.value;
			this.setVendorQuoteNumber(value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onVendorQuoteNumberChange]: ${ exception.message }`);
		}
	}

	onMfgPartNumberChange (event)
	{
		try
		{
			let value = event.target.value;
			this.setMfgPartNumber(value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onMfgPartNumberChange]: ${ exception.message }`);
		}
	}

	onLineNumberChange (event)
	{
		try
		{
			let value = event.target.value;
			this.setLineNumber(value);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@onLineNumberChange]: ${ exception.message }`);
		}
	}

	onManufacturerChange (event)
	{

	}

	@api setLineNumber (value)
	{
		try
		{
			if (isNaN(value) || value === '')
			{
				value = 0;
			}

			value = EAU.toSimpleNumber(value);

			this._lineItemData.lineNumber = value;
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setLineNumber]: ${ exception.message }`);
		}
	}

	@api setMfgPartNumber (value)
	{
		try
		{
			this._lineItemData.mfgPartNumber = value;
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setMfgPartNumber]: ${ exception.message }`);
		}
	}

	/**
	 * Exposed method to set the vendor quote number.
	 * @param {string} value 
	 */
	@api setVendorQuoteNumber (value)
	{
		try
		{
			this._lineItemData.vendorQuoteNumber = value.trim();
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setVendorQuoteNumber]: ${ exception.message }`);
		}
	}

	/**
	 * Exposed method to set the margin dollar.
	 * @param {number} value 
	 */
	@api setMarginDollar (value)
	{
		try
		{
			if (isNaN(value) || value === '')
			{
				value = 0;
			}

			this._lineItemData.marginDollar = EAU.toSimpleNumber(value);
			this.isMarginPercentSelected = false;
			this.isMarginDollarSelected = true;
			this.refreshUnitPrice();
			this.refreshSubtotal();
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setMarginDollar]: ${ exception.message }`);
		}
	}

	/**
	 * Exposed method to set the margin percent.
	 * @param {number} value 
	 */
	@api setMarginPercent (value)
	{
		try
		{
			if (isNaN(value) || value === '')
			{
				value = 0;
			}

			this._lineItemData.marginPercent = EAU.toSimpleNumber(value);
			this.isMarginDollarSelected = false;
			this.isMarginPercentSelected = true;
			this.refreshUnitPrice();
			this.refreshSubtotal();
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setMarginPercent]: ${ exception.message }`);
		}
	}

	/**
	 * Exposed method to set the cost.
	 * @param {number} value 
	 */
	@api setCost (value)
	{
		try
		{
			if (isNaN(value) || value === '')
			{
				value = 0;
			}
			value = EAU.toSimpleNumber(value);

			this._lineItemData.adjustedCost = value;
			this.refreshMargin();
			this.refreshSubtotal();
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setCost]: ${ exception.message }`);
		}
	}

	/**
	 * Exposed method to set the quantity.
	 * @param {integer} value 
	 */
	@api setQuantity (value)
	{
		try
		{
			if (isNaN(value) || value === '')
			{
				value = 0;
			}

			this._lineItemData.quantity = parseInt(value, 10);
			this.refreshSubtotal();
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setQuantity]: ${ exception.message }`);
		}
	}

	/**
	 * Exposed method to set the shipping.
	 * @param {number} value 
	 */
	@api setShipping (value)
	{
		try
		{
			if (isNaN(value) || value === '')
			{
				value = 0;
			}

			this._lineItemData.shipping = EAU.toSimpleNumber(value);
			this.refreshSubtotal();
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setShipping]: ${ exception.message }`);
		}
	}

	/**
	 * Exposed method to set the unit price.
	 * @param {number} value 
	 */
	@api setUnitPrice (value)
	{
		try
		{
			if (isNaN(value) || value === '')
			{
				value = 0;
			}

			this._lineItemData.customerPrice = EAU.toSimpleNumber(value);
			this.refreshMargin();
			this.refreshSubtotal();
			this.dispatchEvent(new CustomEvent('update', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@setUnitPrice]: ${ exception.message }`);
		}
	}

	/**
	 * Trigger this when the Unit Price or Cost get updated
	 */
	refreshMargin ()
	{
		try
		{
			this._lineItemData.marginPercent = EAU.toSimpleNumber((EAU.toSimpleNumber(this._lineItemData.customerPrice) - EAU.toSimpleNumber(this._lineItemData.adjustedCost)) * 100 / EAU.toSimpleNumber(this._lineItemData.customerPrice));
			this._lineItemData.marginDollar = EAU.toSimpleNumber(EAU.toSimpleNumber(this._lineItemData.customerPrice) - EAU.toSimpleNumber(this._lineItemData.adjustedCost));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@refreshMargin]: ${ exception.message }`);
		}
	}

	/**
	 * Trigger this when the Cost or Margin are updated
	 */
	refreshUnitPrice ()
	{
		try
		{
			if (this.isMarginDollarSelected)
			{
				this._lineItemData.customerPrice = EAU.toSimpleNumber(this._lineItemData.adjustedCost) + EAU.toSimpleNumber(this._lineItemData.marginDollar);
			}
			else if (this.isMarginPercentSelected)
			{
				this._lineItemData.customerPrice = EAU.toSimpleNumber(EAU.toSimpleNumber(this._lineItemData.adjustedCost) / (1 - EAU.toSimpleNumber(this._lineItemData.marginPercent) / 100));
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@refreshUnitPrice]: ${ exception.message }`);
		}
	}

	/**
	 * Trigger this when the Unit Price, Quantity, or Margin get updated
	 */
	refreshSubtotal ()
	{
		try
		{
			this._lineItemData.totalPrice = EAU.toSimpleNumber(this._lineItemData.customerPrice) * parseInt(this._lineItemData.quantity, 10);
			this._lineItemData.totalPrice += EAU.toSimpleNumber(this._lineItemData.shipping);
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleLineItem@refreshSubtotal]: ${ exception.message }`);
		}
	}

	/**
	 * Checks whether all inputs in this template are valid or not.
	 * @return True if all inputs are valid. False otherwise.
	 */
	@api reportValidity ()
	{
		this.isValid = true;

		const lightningInputs = this.template.querySelectorAll('lightning-input');
		for (let input of lightningInputs)
		{
			if (input.reportValidity() === false)
			{
				this.isValid = false;
			}
		}

		const inputs = this.template.querySelectorAll('input.slds-input');
		for (let input of inputs)
		{
			if (input.reportValidity() === false)
			{
				this.isValid = false;
			}
		}

		return this.isValid;
	}

	onManufacturerLookupClick (event)
	{
		this.dispatchEvent(new CustomEvent('openmanufacturerlookup', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
	}

	onManufacturerClearClick (event)
	{
		this.dispatchEvent(new CustomEvent('manufacturerclear', {detail: {item: EAU.clone(this._lineItemData), index: this.index}}));
	}
}