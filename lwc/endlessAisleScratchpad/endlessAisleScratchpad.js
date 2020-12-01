/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement, track, api } from 'lwc';
import saveScratchPadUpdates from '@salesforce/apex/EndlessAisleScratchPad.saveScratchPadUpdates';
import OD_LOGO from '@salesforce/resourceUrl/ODHorizontalLogoRed';
import * as EAU from 'c/endlessAisleUtilities';

export default class EndlessAisleScratchpad extends LightningElement {
	@api items;
	/*
		margin has the following properties:
		* isPercent (is the global margin in percent)
		* isDollar 	(is the global margin in dollars)
		* percent 	(the percent amount)
		* dollar 	(the dollar ammount)
		* isApplied (is the global margin applied)
	*/
	@api margin;
	/*
		tax has the following properties:
		* isPercent (is the tax in percent)
		* isDollar	(is the tax in dollars)
		* percent	(the percent amount of tax to be applied to grand total)
		* dollar	(the dollar amount of tax to be added to grand total)
	*/
	@api tax;
	@api recordId;
	@api get isRecordIdAvailable() {
		return this.recordId ? true : false;
	}
	@api get isScratchpadEmpty() {
		return this.items.length == 0 || this._items.length == 0;
	}
	@api get shipping() {
		let s = 0;
		for (let element of this._items) {
			s += EAU.toSimpleNumber(element.shipping);
		}
		return s;
	}
	@api get total() {
		let t = 0;
		for (let element of this._items) {
			t += EAU.toSimpleNumber(element.customerPrice) * parseInt(element.quantity, 10) + EAU.toSimpleNumber(element.shipping);

		}

		if (this._tax.isDollar) {
			t += EAU.toSimpleNumber(this._tax.dollar);
		}
		else if (this._tax.isPercent) {
			t *= EAU.toSimpleNumber((EAU.toSimpleNumber(this._tax.percent, 4) / 100 + 1), 4);
		}
		return t || 0;
	}
	@api get odLogoUrl() {
		return OD_LOGO;
	}
	@api customerNotes;

	@track _items = [];
	@track _margin;
	@track _tax;
	@track _customerNotes;
	@track customerNotesVisible = false;
	@track hasError = false;
	@track hasRendered = false;

	renderedCallback() {
		try {
			if (this.template) {
				if (this._margin.isPercent) {
					let marginPercentOption = this.template.querySelector('.percent-2');
					if (marginPercentOption) {
						marginPercentOption.checked = true;
					}
				}
				else if (this._margin.isDollar) {
					let marginDollarOption = this.template.querySelector('.dollar-2');
					if (marginDollarOption) {
						marginDollarOption.checked = true;
					}
				}

				if (this._tax.isPercent) {
					let taxPercentOption = this.template.querySelector('.percent-1');
					if (taxPercentOption) {
						taxPercentOption.checked = true;
					}
				}
				else if (this._tax.isDollar) {
					let taxDollarOption = this.template.querySelector('.dollar-1');
					if (taxDollarOption) {
						taxDollarOption.checked = true;
					}
				}
			}
			if (this.hasRendered === false) {
				this.hasRendered = true;
				this.onFirstRender();
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@renderedCallback]: ${exception.message}`);
		}
	}
	connectedCallback() {
		try {
			this.refreshItems();
			this.loadQuote();
			this.updateTax();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@connectedCallback]: ${exception.message}`);
		}
	}
	onFirstRender() {
		try {
			this.validateAllInputs();
			this.transitionIntoView();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onFirstRender]: ${exception.message}`);
		}
	}
	transitionIntoView() {
		if (this.template) {
			const transitionElement = this.template.querySelector('.moe-transition');
			void transitionElement.offsetWidth;
			transitionElement.classList.remove('slds-transition-hide');
		}
	}
	updateTax() {
		try {
			if (this.tax.dollar) {
				this.setTaxDollar(this.tax.dollar);
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@updateTax]: ${exception.message}`);
		}
	}
	/**
	 * Event listener for when line item is removed. Triggered whenever 'Remove' is clicked from the line item's button menu.
	 * @param {event} event 
	 */
	async LI_onRemove(event) {
		try {
			const index = event.detail.index;
			if ((index || index === 0) && index !== -1) {
				this._items.splice(index, 1);
			}
			this.validateAllInputs();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@LI_onRemove]: ${exception.message}`);
		}
	}
	/**
	 * Event listener for when line item is updated
	 * @param {event} event 
	 */
	async LI_onUpdate(event) {
		try {
			const index = event.detail.index;

			if ((index || index === 0) && index !== -1) {
				await (this._items[index] = event.detail.item);
			}
			this.validateAllInputs();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@LI_onUpdate]: ${exception.message}`);
		}
	}
	/**
	 * Handles when a line item is selected or unselected.
	 * If the line item has global _margin applied and it gets unselected,
	 * the global _margin is removed.
	 * @param {event} event 
	 */
	LI_onSelectionChange(event) {
		try {
			const index = event.detail.index;

			if ((index || index === 0) && index !== -1) {
				if (this._margin.isApplied === true) {
					if (event.detail.selected === false) {
						this.removeGlobalMarginFromLineItem(this._items[index]);
					}
					else if (event.detail.selected === true) {
						this.applyGlobalMarginToLineItem(this._items[index]);
					}
				}
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@LI_onSelectionChange]: ${exception.message}`);
		}
	}
	LI_onOpenMoreDetails(event) {
		try {
			this.dispatchEvent(new CustomEvent('save', { detail: { items: EAU.clone(this._items) } }));
			this.dispatchEvent(new CustomEvent('openmoredetails', { detail: event.detail }));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@LI_onOpenMoreDetails]: ${exception.message}`);
		}
	}
	LI_onOpenManufacturerLookup(event) {
		try {
			this.dispatchEvent(new CustomEvent('save', { detail: { items: EAU.clone(this._items) } }));
			this.dispatchEvent(new CustomEvent('openmanufacturerlookup', { detail: event.detail }));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@LI_onOpenManufacturerLookup]: ${exception.message}`);
		}
	}
	LI_onManufacturerClear(event) {
		try {
			this.dispatchEvent(new CustomEvent('save', { detail: { items: EAU.clone(this._items) } }));
			this.dispatchEvent(new CustomEvent('manufacturerclear', { detail: event.detail }));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@LI_onOpenManufacturerLookup]: ${exception.message}`);
		}
	}
	LI_onInputBlur(event) {
		try {
			this.validateAllInputs();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@LI_onOpenManufacturerLookup]: ${exception.message}`);
		}
	}
	/**
	 * Handles whenever the _tax percent is changed from the scratchpad.
	 * @param {event} event 
	 */
	onTaxPercentChange(event) {
		try {
			if (event.target.value || event.target.value === 0) {
				let value = event.target.value;
				if (isNaN(value) || value === '') {
					value = 0;
				}
				this._tax.percent = EAU.toSimpleNumber(value);
				this._tax.dollar = EAU.toSimpleNumber((EAU.toSimpleNumber(this.total) - (EAU.toSimpleNumber(this.total) / EAU.toSimpleNumber(EAU.toSimpleNumber(this._tax.percent) / 100 + 1))));
			}
			this.validateAllInputs();
			this.dispatchEvent(new CustomEvent('modifyglobalproperties', { detail: { margin: EAU.clone(this._margin), tax: EAU.clone(this._tax) } }));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onTaxPercentChange]: ${exception.message}`);
		}
	}
	/**
	 * Handles whenever the _tax percent is changed from the scratchpad.
	 * @param {event} event 
	 */
	onTaxDollarChange(event) {
		try {
			let value = event.target.value;
			this.setTaxDollar(value);
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onTaxDollarChange]: ${exception.message}`);
		}
	}
	/**
	 * Exposed this method to set the tax on load, since we save its value on the Quote.
	 */
	@api setTaxDollar(value) {
		if (isNaN(value) || value === '' || (!value && value !== 0)) {
			value = 0;
		}
		this._tax.dollar = EAU.toSimpleNumber(value);
		this._tax.percent = EAU.toSimpleNumber((EAU.toSimpleNumber(this.total) / (EAU.toSimpleNumber(this.total) - EAU.toSimpleNumber(this._tax.dollar)) - 1) * 100) || 0;
		this.validateAllInputs();
		this.dispatchEvent(new CustomEvent('modifyglobalproperties', { detail: { margin: EAU.clone(this._margin), tax: EAU.clone(this._tax) } }));
	}
	onTaxPercentSelection(event) {
		try {
			if (event.target) {
				if (event.target.checked === true) {
					this._tax.isDollar = false;
					this._tax.isPercent = true;
				}
			}
			this.dispatchEvent(new CustomEvent('selectglobalproperties'));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onTaxPercentSelection]: ${exception.message}`);
		}
	}
	onTaxDollarSelection(event) {
		try {
			if (event.target) {
				if (event.target.checked === true) {
					this._tax.isPercent = false;
					this._tax.isDollar = true;
				}
			}
			this.dispatchEvent(new CustomEvent('selectglobalproperties'));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onTaxDollarSelection]: ${exception.message}`);
		}
	}
	/**
	 * Handles whenever the percent _margin is changed
	 * @param {event} event 
	 */
	onMarginPercentChange(event) {
		try {
			if (event.target) {
				let value = event.target.value;
				if (isNaN(value) || value === '') {
					value = 0;
				}
				this._margin.percent = EAU.toSimpleNumber(value);
				if (this._margin.isApplied === true) {
					this.applyGlobalMargin();
				}
			}
			this.validateAllInputs();
			this.dispatchEvent(new CustomEvent('modifyglobalproperties', { detail: { margin: EAU.clone(this._margin), tax: EAU.clone(this._tax) } }));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onMarginPercentChange]: ${exception.message}`);
		}
	}
	/**
	 * Handles whenever the percent _margin is changed
	 * @param {event} event 
	 */
	onMarginDollarChange(event) {
		try {
			if (event.target) {
				let value = event.target.value;
				if (isNaN(value) || value === '') {
					value = 0;
				}
				this._margin.dollar = EAU.toSimpleNumber(value);
				if (this._margin.isApplied === true) {
					this.applyGlobalMargin();
				}
			}
			this.validateAllInputs();
			this.dispatchEvent(new CustomEvent('modifyglobalproperties', { detail: { margin: EAU.clone(this._margin), tax: EAU.clone(this._tax) } }));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onMarginDollarChange]: ${exception.message}`);
		}
	}
	/**
	 * Handles when percent _margin button is clicked.
	 * @param {event} event 
	 */
	onMarginPercentSelection(event) {
		try {
			if (event.target) {
				if (event.target.checked === true) {
					this._margin.isDollar = false;
					this._margin.isPercent = true;

					if (this._margin.isApplied === true) {
						this.applyGlobalMargin();
					}
				}
			}
			this.dispatchEvent(new CustomEvent('selectglobalproperties'));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onMarginPercentSelection]: ${exception.message}`);
		}
	}
	/**
	 * Handles when dollar _margin button is clicked.
	 * @param {event} event 
	 */
	onMarginDollarSelection(event) {
		try {
			if (event.target) {
				if (event.target.checked === true) {
					this._margin.isPercent = false;
					this._margin.isDollar = true;

					if (this._margin.isApplied === true) {
						this.applyGlobalMargin();
					}
				}
			}
			this.dispatchEvent(new CustomEvent('selectglobalproperties'));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onMarginDollarSelection]: ${exception.message}`);
		}
	}
	/**
	 * Applies global _margin to line items with no _margin applied.
	 */
	applyGlobalMargin() {
		try {
			for (let element of this._items) {
				this.applyGlobalMarginToLineItem(element);
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@applyGlobalMargin]: ${exception.message}`);
		}
	}
	/**
	 * Removes global _margin from line items with global _margin applied.
	 */
	removeGlobalMargin() {
		try {
			for (let element of this._items) {
				this.removeGlobalMarginFromLineItem(element);
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@removeGlobalMargin]: ${exception.message}`);
		}
	}
	/**
	 * Removes the global _margin from a single line item.
	 * @param {Element} element An element from the local line item array
	 */
	removeGlobalMarginFromLineItem(element) {
		try {
			const key = 'Id';
			let _lineItems = this.template.querySelectorAll('c-endless-aisle-line-item');

			for (let lineItem of _lineItems) {
				if (lineItem.lineItemData[key] == element[key]) {
					if ((this._margin.isApplied === true && lineItem.isSelected === false) ||
						(this._margin.isApplied === false && lineItem.isSelected === true)) {
						element.marginPercent = 0;
						element.marginDollar = 0;
						lineItem.setMarginPercent(0);
						lineItem.setMarginDollar(0);
						return;
					}
				}
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@removeGlobalMarginFromLineItem]: ${exception.message}`);
		}
	}
	/**
	 * Applies the global margin to a single line item.
	 */
	applyGlobalMarginToLineItem(element) {
		try {
			const key = 'Id';
			let _lineItems = this.template.querySelectorAll('c-endless-aisle-line-item');

			for (let lineItem of _lineItems) {
				if (lineItem.lineItemData[key] == element[key] && lineItem.isSelected === true) {
					if (this._margin.isApplied === true) {
						if (this._margin.isPercent === true) {
							element.marginPercent = EAU.toSimpleNumber(this._margin.percent);
							lineItem.setMarginPercent(element.marginPercent);
							return;
						}
						else if (this._margin.isDollar === true) {
							element.marginDollar = EAU.toSimpleNumber(this._margin.dollar);
							lineItem.setMarginDollar(element.marginDollar);
							return;
						}
					}
				}
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@applyGlobalMarginToLineItem]: ${exception.message}`);
		}
	}
	/**
	 * Handles whenever the global _margin toggle is changed.
	 * @param {event} event 
	 */
	onMarginToggleChange(event) {
		try {
			if (event.target.checked === true) {
				this._margin.isApplied = true;
				this.applyGlobalMargin();
			}
			else if (event.target.checked === false) {
				this._margin.isApplied = false;
				this.removeGlobalMargin();
			}
			this.dispatchEvent(new CustomEvent('selectglobalproperties'));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onMarginToggleChange]: ${exception.message}`);
		}
	}
	/**
	 * Tells the parent (Container) that we're trying to save (usually to display the loader).
	 * Calls an Apex method to save the Scratchpad state to the quote.
	 */
	onSaveToQuoteClick() {
		try {
			this.dispatchEvent(new CustomEvent('savingtoquote'));

			for (let lineItem of this._items) {
				if (!lineItem.maxListPrice) {
					lineItem.maxListPrice = EAU.toSimpleNumber(EAU.toSimpleNumber(lineItem.adjustedCost) * 2) || EAU.toSimpleNumber(EAU.toSimpleNumber(lineItem.originalCost) * 2);
				}

				if (lineItem.maxListPrice < lineItem.adjustedCost) {
					lineItem.maxListPrice = EAU.toSimpleNumber(EAU.toSimpleNumber(lineItem.adjustedCost) * 2);
				}
			}

			let shipping = 0;
			for (let lineItem of this._items) {
				shipping += lineItem.shipping;
			}

			saveScratchPadUpdates({ quoteId: this.recordId, customerNotes: this._customerNotes, lineItems: this._items, estimatedTax: this._tax.dollar, shipping: shipping })
				.then(() => {
					this.dispatchEvent(new CustomEvent('savedtoquote'));
				})
				.catch(error => {
					this.dispatchEvent(new CustomEvent('failedtosave', { detail: { message: error.body.message } }));
					console.error(`Error in [endlessAisleScratchpad@onSaveToQuoteClick@insertQuoteLineItem]: ${error}`);
				});
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onSaveToQuoteClick]: ${exception.message}`);
		}
	}
	/**
	 * Called after changing the supplier from a line item from the MD pop up
	 */
	@api refreshItems() {
		try {
			if (this.items) {
				this._items = EAU.clone(this.items);
				for (let item of this._items) {
					let Id = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
					item.Id = Id;
				}
			}

			if (this.margin) {
				this._margin = EAU.clone(this.margin);
			}

			if (this.tax) {
				this._tax = EAU.clone(this.tax);
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@refreshItems]: ${exception.message}`);
		}
	}
	/**
	 * Sends an event to the parent (Container) which handles action for this event.
	 * The parent will usually hide the Scratchpad and display the Product Search on this event.
	 */
	onAddProductsClick() {
		try {
			this.dispatchEvent(new CustomEvent('save', { detail: { items: EAU.clone(this._items) } }));
			this.dispatchEvent(new CustomEvent('backtosearch'));
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onAddProductsClick]: ${exception.message}`);
		}
	}
	/**
	 * Toggles the visibility of the customer notes section.
	 */
	onAddCustomerNotesClick() {
		try {
			this.customerNotesVisible = !this.customerNotesVisible;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onAddCustomerNotesClick]: ${exception.message}`);
		}
	}
	/**
	 * Stores the input value for customer notes in a variable.
	 */
	onCustomerNotesChange(event) {
		try {
			this._customerNotes = event.target.value;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onCustomerNotesChange]: ${exception.message}`);
		}
	}
	/**
	 * Navigates to the quote page.
	 */
	onReturnToQuote() {
		try {
			window.location.href = window.location.origin + '/lightning/r/Quote/' + this.recordId + '/view';
		}
		catch (exception) {
			console.error(`Error in [endlessAisleScratchpad@onReturnToQuote]: ${exception.message}`);
		}
	}
	/**
	 * Validates all inputs in the Scratchpad and its child components.
	 */
	@api validateAllInputs() {
		this.hasError = false;

		// Validate the Scratchpad inputs first (the global margin, the tax, etc)
		const lightningInputs = this.template.querySelectorAll('lightning-input');
		for (let input of lightningInputs) {
			if (input.reportValidity() === false) {
				// This input has an error
				this.hasError = true;
			}
		}

		//Then let's validate the individual line item inputs
		const endlessAisleLineItems = this.template.querySelectorAll('c-endless-aisle-line-item');
		for (let item of endlessAisleLineItems) {
			if (item.reportValidity() === false) {
				// This item has an input that is invalid
				this.hasError = true;
			}
		}
	}
}