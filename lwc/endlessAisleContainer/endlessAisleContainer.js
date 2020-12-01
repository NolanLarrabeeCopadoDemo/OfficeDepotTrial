/* eslint-disable no-void */
/* eslint-disable no-console */
import { LightningElement, track, api } from 'lwc';
import getQuoteLineItems from '@salesforce/apex/EndlessAisleScratchPad.getQuoteLineItems';
import isQuoteLocked from '@salesforce/apex/EndlessAisleScratchPad.isQuoteLocked';
import getAopsCustIdFromQuote from '@salesforce/apex/EndlessAisleScratchPad.getAopsCustIdFromQuote';
import getContractPrice from '@salesforce/apex/EndlessAisleScratchPad.getContractPrice';
import getManufacturers from '@salesforce/apex/EndlessAisleScratchPad.getManufacturers';
import getQuoteTaxAmount from '@salesforce/apex/EndlessAisleScratchPad.getQuoteTaxAmount';
import getQuoteNotesToCustomer from '@salesforce/apex/EndlessAisleScratchPad.getQuoteNotesToCustomer';
import * as EAU from 'c/endlessAisleUtilities';

export default class EndlessAisleContainer extends LightningElement {
	/*
	This is a container Lightning Web Component. Inside it are:
		* Loader
		* Manual Entry pop-up
		* More Details pop-up
		* Modal
		* Product Search
		* Scratchpad
		* Manufacturer Lookup
	*/
	/*
	Prefixes:
	LDR = Loader
	ME = Manual Entry
	MD = More Details
	MDL = Modal
	PS = Product Search
	SP = Scratchpad
	ML = Manufacturer Lookup
	*/

	@api get isQuoteIdAvailable() { return this.SP.recordId ? true : false; };

	@track isQuoteLocked = false;
	@track aopsCustId;

	connectedCallback() {
		let urlParameters = location.search.substring(1).split('&');
		for (let parameter of urlParameters) {
			let split = parameter.split('=');
			let key = split[0];
			let value = split[1];

			if (key.toLowerCase() === 'recordid') {
				this.SP_setRecordId(value);
			}
			else if (key.toLowerCase() === 'id') {
				this.SP_setRecordId(value);
			}
		}

		this.init();
	}
	async init() {
		this.hideEverything();
		this.LDR_show();

		if (this.SP.recordId) {
			isQuoteLocked({ quoteId: this.SP.recordId })
				.then(result => {
					this.isQuoteLocked = result;
					if (result === false) {
						getAopsCustIdFromQuote({ quoteId: this.SP.recordId })
							.then(result => {
								this.aopsCustId = result;
							})
							.catch(error => {
								console.error(`Error in [endlessAisleContainer@init@getAopsCustIdFromQuote]: ${error.message}`);
							});
						getQuoteTaxAmount({ quoteId: this.SP.recordId })
							.then(async result => {
								let value = result;
								if (!value && value !== 0) {
									value = 0;
								}
								this.SP.tax.dollar = value;
								this.SP.tax.isPercent = false;
								this.SP.tax.isDollar = true;
								await (this.SP_show());
								this.SP.htmlElement.setTaxDollar(value);
								this.SP_hide();
							})
							.catch(error => {
								console.error(`Error in [endlessAisleContainer@init@getQuoteTaxRate]: ${error.message}`);
							});
						getQuoteNotesToCustomer({ quoteId: this.SP.recordId })
							.then(async result => {
								this.SP.customerNotes = result;
							})
							.catch(error => {
								console.error(`Error in [endlessAisleContainer@init@getQuoteNotesToCustomer]: ${error.message}`);
							});

						this.SP_loadFromQuote();
					}
				})
				.catch(error => {
					console.error(`Error in [endlessAisleContainer@init]: ${error.message}`);
				});
		}
		else {
		}
	}

	LDR_show() {
		try {
			this.LDR.isVisible = true;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@LDR_show]: ${exception.message}`);
		}
	}
	LDR_hide() {
		this.LDR.isVisible = false;
	}

	PS_onSelectionChange() { }
	PS_onOpenMoreDetails(event) {
		try {
			this.MD.isReplacing = false;
			this.MD.product = event.detail.product;
			this.MD.itemIndex = -1;
			this.MD_show();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@PS_onOpenMoreDetails]: ${exception.message}`);
		}
	}
	PS_onSearch(event) {
		try {
			if (event.detail.failed === false) {
				this.PS.allData = event.detail.table.allData;
			}
			else if (event.detail.failed === true) {
				console.error('Failure in [endlessAisleContainer@PS_onSearch]');
			}
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@PS_onSearch]: ${exception.message}`);
		}
	}
	PS_onGoToScratchpad() {
		this.hideEverything();
		this.SP_show();
	}
	PS_onAddToScratchpad(event) {
		try {
			for (let newItem of event.detail.items) {
				this.SP_addItem(newItem);
			}
			this.hideEverything();
			this.SP_show();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@PS_onAddToScratchpad]: ${exception.message}`);
		}
	}
	/**
	 * After a filter is applied in Product Search, Product Search sends us the results in the table after the filtering has happened.
	 * This method simply stores those results as long as the filter is active.
	 */
	PS_onFilter(event) {
		this.PS.filteredData = event.detail.table.filteredData;
	}
	/**
	 * Clears the stored filter results.
	 */
	PS_onClearFilter() {
		this.PS.filteredData = [];
	}
	/**
	 * Displays the Manual Entry LWC.
	 */
	PS_onAddItemManually() {
		this.ME_show();
	}
	/**
	 * Hides the Product Search.
	 */
	PS_hide() {
		this.PS.isVisible = false;
	}
	/**
	 * Displays the Product Search.
	 */
	PS_show() {
		try {
			this.PS.isVisible = true;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@PS_show]: ${exception.message}`);
		}
	}

	MD_onSelectSupplier() { }
	MD_onClose() {
		this.MD_hide();
	}
	MD_onAddToScratchpad(event) {
		try {
			this.MD.mode = '';
			this.SP_addItem(event.detail.item);
			this.hideEverything();
			this.SP_show();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@MD_onAddToScratchpad]: ${exception.message}`);
		}
	}
	MD_onChangeSupplier(event) {
		try {
			this.SP_replaceItem(event.detail.item, this.MD.itemIndex);
			this.hideEverything();
			this.SP_show();
			this.SP_tryRefreshItems_EXPERIMENTAL();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@MD_onChangeSupplier]: ${exception.message}`);
		}
	}
	/**
	 * Hides the More Details LWC.
	 */
	MD_hide() {
		this.MD.isVisible = false;
	}
	/**
	 * Displays the More Details LWC.
	 */
	MD_show() {
		try {
			this.MD.isVisible = true;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@MD_show]: ${exception.message}`);
		}
	}


	ML_onClose() {
		this.ML_hide();
	}
	ML_onSearch(event) {
		this.ML.isLoading = true;
		getManufacturers({ name: event.detail.manufacturerName })
			.then(result => {
				this.ML.manufacturerOptions = result;
				this.ML.htmlElement.refresh();
				this.ML.isLoading = false;
			})
			.catch(error => {
				this.ML.isLoading = false;
				console.error(`Error in [endlessAisleContainer@ML_onSearch]: ${exception.message}`);
			});
	}
	ML_onSetManufacturer(event) {
		this.ML_hide();
		let newProduct = EAU.clone(this.ML.product);
		newProduct.odManufacturerId = event.detail.manufacturer.id;
		newProduct.odManufacturer = event.detail.manufacturer.name;
		newProduct.odManufacturerName = event.detail.manufacturer.name;
		this.SP_replaceItem(newProduct, this.ML.itemIndex);
		this.SP_tryRefreshItems_EXPERIMENTAL();
	}
	/**
	 * Hides the Manufacturer Lookup LWC.
	 */
	ML_hide() {
		this.ML.isVisible = false;
	}
	/**
	 * Displays the Manufacturer Lookup LWC.
	 */
	ML_show() {
		try {
			this.ML.isVisible = true;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@ML_show]: ${exception.message}`);
		}
	}
	/**
	 * Hides all other components and displays the Product Search. And saves the current items from the Scratchpad into this.SP.items.
	 * @param {event} event 
	 */
	SP_onBackToSearch(event) {
		this.hideEverything();
		this.PS_show();
	}
	/**
	 * Stores the global tax and margin values from the Scratchpad so we can pre-populate them when going back to Scratchpad from Product Search.
	 */
	SP_onModifyGlobalProperties(event) {
		try {
			this.SP.margin = event.detail.margin;
			this.SP.tax = event.detail.tax;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@SP_onModifyGlobalProperties]: ${exception.message}`);
		}
	}
	/**
	 * Displays the loader while we're trying to save the Scratchpad state to the quote.
	 */
	SP_onSavingToQuote() {
		this.hideEverything();
		this.LDR_show();
	}
	/**
	 * Displays a success modal after we've successfully saved the Scratchpad state to the quote.
	 * Sets the Close and Go to Quote buttons to go to the Quote.
	 */
	SP_onSavedToQuote() {
		this.hideEverything();
		this.MDL.title = 'Well done!';
		this.MDL.message = 'Your changes were successfully committed to the quote.';
		this.MDL.proceedLabel = 'Go to Quote';
		this.MDL.onClose = this.goToQuote;
		this.MDL.onProceed = this.goToQuote;
		this.MDL_show();
	}
	/**
	 * Displays a failure modal after we've successfully saved the Scratchpad state to the quote.
	 * Sets the Close and Refresh Page buttons to refresh the page.
	 * Displays a list of possible reasons for the failure.
	 */
	SP_onFailedToSave(event) {
		this.hideEverything();
		this.MDL.title = 'Uh oh!';
		this.MDL.message = 'I ran into an issue saving your changes to the quote. Please reopen the Scratchpad and try again.';
		this.MDL.proceedLabel = 'Refresh page';
		this.MDL.onClose = this.refreshPage;
		this.MDL.onProceed = this.refreshPage;

		if (event.detail && event.detail.message) {
			let possibleErrors = '<div>Possible issues are: <ul>';
			let errorsAvailable = false;
			if (event.detail.message.toUpperCase().includes('Quote has no price book assigned'.toUpperCase()) || event.detail.message.toUpperCase().includes('FIELD_INTEGRITY_EXCEPTION')) {
				possibleErrors += '<li>The quote has the wrong record type. Please create a new quote.</li>';
				errorsAvailable = true;
			}
			if (event.detail.message.toUpperCase().includes('INSUFFICIENT_ACCESS_OR_READONLY')) {
				possibleErrors += '<li>You weren\'t granted permissions to use the Scratchpad. Please contact support.</li>';
				errorsAvailable = true;
			}
			possibleErrors += '</ul></div>';
			if (errorsAvailable === true) {
				this.MDL.message += possibleErrors;
			}
		}

		this.MDL_show();
	}
	/**
	 * Displays the More Details modal for an item in the Scratchpad.
	 * Sets the More Details mode to replace (the item will be replaced with the More Details selection).
	 * @param {event} event 
	 */
	SP_onOpenMoreDetails(event) {
		try {
			this.MD.isReplacing = true;
			this.MD.product = event.detail.item;
			this.MD.itemIndex = event.detail.index;
			this.MD_show();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@SP_onOpenMoreDetails]: ${exception.message}`);
		}
	}
	SP_onSelectGlobalProperties() { }
	SP_onOpenManufacturerLookup(event) {
		try {
			this.ML.product = event.detail.item;
			this.ML.itemIndex = event.detail.index;
			this.ML_show();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@SP_onOpenManufacturerLookup]: ${exception.message}`);
		}
	}
	SP_onManufacturerClear(event) {
		try {
			let newProduct = EAU.clone(event.detail.item);
			newProduct.odManufacturerId = null;
			newProduct.odManufacturer = null;
			newProduct.odManufacturerName = null;
			this.SP_replaceItem(newProduct, event.detail.index);
			this.SP_tryRefreshItems_EXPERIMENTAL();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@SP_onOpenManufacturerLookup]: ${exception.message}`);
		}
	}
	/**
	 * Hides the Scratchpad.
	 */
	SP_hide() {
		this.SP.isVisible = false;
	}
	/**
	 * Displays the Scratchpad.
	 */
	SP_show() {
		try {
			this.SP.isVisible = true;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@SP_show]: ${exception.message}`);
		}
	}
	SP_setRecordId(value) {
		this.SP.recordId = value;
	}
	SP_setContractPrice(item, index) {
		getContractPrice({ aopsCustId: this.aopsCustId, item: item })
			.then(result => {
				if ((result || result === 0) && !isNaN(result)) {
					this.SP.items[index].contractPrice = EAU.toSimpleNumber(result);
				}
			})
			.catch(error => {
				console.error(`Error in [endlessAisleContainer@SP_setContractPrice]: ${error.message}`);
			});
	}
	/**
	 * Adds an item to the Scratchpad. Updates the quantity instead of creating a new item, if the item is already existing.
	 * @param {*} item A formatted item from Product Search, EndlessAisleScratchpad class, or More Details.
	 */
	SP_addItem(item) {
		for (let currentItem of this.SP.items) {
			if (item.supplierPartNumber && item.supplierPartNumber.length > 0 &&
				currentItem.supplierPartNumber && currentItem.supplierPartNumber.length > 0 &&
				item.supplierPartNumber == currentItem.supplierPartNumber) {
				currentItem.quantity += 1;
				return;
			}
		}
		this.SP.items.push(item);

		if (item.odSkuNumber) {
			let index = this.SP.items.length - 1;
			this.SP_setContractPrice(item, index);
		}
	}
	/**
	 * Triggers a refresh in the Scratchpad.
	 * Calls an exposed (@api) event in the Scratchpad LWC that makes the Scratchpad pull the items from the Container.
	 */
	SP_tryRefreshItems() {
		if (this.SP.htmlElement) {
			this.SP.htmlElement.refreshItems();
			this.SP.htmlElement.validateAllInputs();
		}
	}
	/**
	 * Triggers a refresh in the Scratchpad.
	 * Calls an exposed (@api) event in the Scratchpad LWC that makes the Scratchpad pull the items from the Container.
	 */
	async SP_tryRefreshItems_EXPERIMENTAL() {
		await (this.SP_hide());
		await (this.SP_show());
	}
	/**
	 * Replaces an item with newItem. The old item is found by key and the value.
	 * @param {*} newItem An item to used to find the old item and to replace it with the new item.
	 */
	SP_replaceItem(newItem, index) {
		if ((index || index === 0) && index !== -1) {
			this.SP.items[index] = EAU.clone(newItem);
		}
	}
	SP_handleQuoteLineItems(lineItems) {
		try {
			for (let lineItem of lineItems) {
				let obj = lineItem;

				let supplier;

				// Try to find the supplier that was previously selected, from
				// the updated list of suppliers the Search Service gave us
				if (lineItem.results) {
					for (let result of lineItem.results) {
						if (result.supplier_id == lineItem.vendorNumber) {
							supplier = result;
						}
					}

					if (!supplier && lineItem.results.length > 0) {
						supplier = lineItem.results[0];
					}
				}

				if (supplier) {
					obj['supplierName'] = obj.supplierName || supplier.Supplier || null;
					obj['supplierPartNumber'] = obj.supplierPartNumber || supplier.SupplierPart || null;
					obj['vendorNumber'] = obj.vendorNumber || supplier.Id || null;
					obj['originalCost'] = obj.originalCost || EAU.toSimpleNumber(supplier.Cost);
					obj['totalPrice'] = obj.totalPrice || parseInt(supplier.Quantity, 10) * EAU.toSimpleNumber(supplier.CustomerPrice);
					obj['packageSize'] = obj.packageSize || supplier.package_size || null;
					obj['unitOfMeasure'] = obj.unitOfMeasure || supplier.package_units_of_measure || null;
					obj['isVirtualWarehouseItem'] = obj.isVirtualWarehouseItem || supplier.is_virtual_warehouse_item || null;
					obj['itemType'] = obj.itemType || supplier.item_number_type || null;
				}

				this.SP_addItem(obj);
			}
			this.hideEverything();
			this.SP_show();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@SP_handleQuoteLineItems]: ${exception.message}`);
		}

		this.hideEverything();
		this.SP_show();
	}
	/**
	 * Loads existing QuoteLineItems from the quote. Uses the id this.SP.recordId to find the quote.
	 */
	SP_loadFromQuote() {
		if (this.SP.recordId) {
			getQuoteLineItems({ quoteId: this.SP.recordId })
				.then(results => {
					this.SP_handleQuoteLineItems(JSON.parse(results));
				})
				.catch(error => {
					console.error(`Error in [endlessAisleContainer@SP_loadFromQuote]: ${error}`);
				});
		}
	}
	SP_onSave(event) {
		this.SP.items = event.detail.items;
	}

	MDL_hide() {
		this.MDL.isVisible = false;
	}
	MDL_show() {
		try {
			this.MDL.isVisible = true;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@MDL_show]: ${exception.message}`);
		}
	}

	ME_onClose() {
		this.ME_hide();
	}
	ME_onAddToScratchpad(event) {
		try {
			this.SP_addItem(event.detail.item);
			this.hideEverything();
			this.SP_show();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@ME_onAddToScratchpad]: ${exception.message}`);
		}
	}
	ME_hide() {
		this.ME.isVisible = false;
	}
	ME_show() {
		try {
			this.ME.isVisible = true;
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@ME_show]: ${exception.message}`);
		}
	}

	refreshPage() {
		try {
			window.location.reload();
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@refreshPage]: ${exception.message}`);
		}
	}
	goToQuote() {
		try {
			window.location.assign(window.location.origin + `/${this.SP.recordId}`);
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@goToQuote]: ${exception.message}`);
		}
	}
	goToQuoteHome() {
		try {
			window.location.assign(window.location.origin + '/lightning/o/Quote/home');
		}
		catch (exception) {
			console.error(`Error in [endlessAisleContainer@goToQuote]: ${exception.message}`);
		}
	}
	/**
	 * This hides everything in the Container
	 */
	hideEverything() {
		this.LDR_hide();
		this.PS_hide();
		this.SP_hide();
		this.MDL_hide();
		this.MD_hide();
		this.ME_hide();
		this.ML_hide();
	}

	@track MDL = {
		isVisible: false,
		title: '',
		message: '',
		proceedLabel: '',
		onClose: undefined,
		onProceed: undefined,
		parent: this.template,
		get htmlElement() {
			return this.parent.querySelector('c-endless-aisle-modal');
		}
	};
	@track LDR = {
		isVisible: false,
		parent: this.template,
		get htmlElement() {
			return this.parent.querySelector('c-endless-aisle-loader');
		}
	};
	@track PS = {
		isVisible: false,
		allData: [],
		filteredData: [],
		parent: this.template,
		get htmlElement() {
			return this.parent.querySelector('c-endless-aisle-product-search');
		}
	};
	@track MD = {
		isVisible: false,
		isReplacing: false,
		product: null,
		parent: this.template,
		get htmlElement() {
			return this.parent.querySelector('c-endless-aisle-more-details');
		}
	};
	@track SP = {
		isVisible: false,
		items: [],
		recordId: null,
		customerNotes: null,
		margin: {
			percent: 0,
			dollar: 0,
			isPercent: true,
			isDollar: false,
			isApplied: false
		},
		tax: {
			percent: 0,
			dollar: 0,
			isPercent: true,
			isDollar: false
		},
		parent: this.template,
		get htmlElement() {
			return this.parent.querySelector('c-endless-aisle-scratchpad');
		}
	};
	@track ME = {
		isVisible: false,
		parent: this.template,
		get htmlElement() {
			return this.parent.querySelector('c-endless-aisle-manual-entry');
		}
	};
	@track ML = {
		isVisible: false,
		isLoading: false,
		product: null,
		manufacturerOptions: [],
		parent: this.template,
		get htmlElement() {
			return this.parent.querySelector('c-endless-aisle-manufacturer-lookup');
		}
	};
}