/* eslint-disable no-void */
/* eslint-disable no-console */
import {LightningElement,wire, track} from 'lwc';
import * as EAU from 'c/endlessAisleUtilities';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import VENDOR_NAME_FIELD from '@salesforce/schema/QuoteLineItem.Vendor_Name__c';



export default class EndlessAisleManualEntry extends LightningElement 
{

//The recordtype Id is dummy/Hardcoded as per the standard syntax as record type is mandetory to call picklist field.
	@wire(getPicklistValues, {recordTypeId: '012000000000000AAA',fieldApiName: VENDOR_NAME_FIELD })
	nameSuppliers;
	nameSupplier = "";
	
	

	// Contains all the input values that are available on the form.
	// Must be updated if new fields are added
	@track input = {
		vendorManufacturerName: null,
		supplierName: null,
		vendorManufacturerId: null,
		sku: null,
		manufacturerPartNumber: null,
		upc: null,
		shipping: null,
		originalCost: null,
		adjustedCost: null,
		unitPrice: null,
		margin: null,
		itemDescription: null,
		quantity: null,
// Entered for List Price
		maxListPrice: null 
	};

	// Stores true or false value of whether the form is valid or not.
	// The form is not valid if required inputs are missing.
	@track isFormValid = false;
	@track hasRendered = false;
	
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

	// Constructs an object that has the item information that we want to add, and sends it to the parent.
	// The parent handles adding the item to the Scratchpad.
	onAddToScratchpad ()
	{
		try
		{
			let product =
			{
				'vendorManufacturerName': this.input.vendorManufacturerName || null,
				'supplierName': this.input.nameSupplier || null,
				'vendorManufacturer': this.input.vendorManufacturerId || null,
				'odSKuNumber': this.input.sku || null,
				'mfgPartNumber': this.input.manufacturerPartNumber || null,
				'upcCode': this.input.upc || null,
				'itemDescription': this.input.itemDescription || '',
				'shipping': EAU.toSimpleNumber(this.input.shipping) || 0,
				'originalCost': EAU.toSimpleNumber(this.input.originalCost) || EAU.toSimpleNumber(this.input.adjustedCost) || 0,
				'adjustedCost': EAU.toSimpleNumber(this.input.adjustedCost) || 0,
				'maxListPrice': EAU.toSimpleNumber(this.input.maxListPrice) || 0, //Entered for List Price
				//'maxListPrice': 0,
				'price': EAU.toSimpleNumber(this.input.unitPrice) || 0,
				'customerPrice': EAU.toSimpleNumber(this.input.unitPrice) || 0,
				'quantity': parseInt(this.input.quantity, 10) || 0,
				'totalPrice': EAU.toSimpleNumber(parseInt(this.input.quantity, 10) * EAU.toSimpleNumber(this.input.unitPrice)) || 0
			};
			this.dispatchEvent(new CustomEvent('addtoscratchpad', {detail: {item: EAU.clone(product)}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onAddToScratchpad]: ${ exception.message }`);
		}
	}

	// Send an event to the parent, and the parent handles action on close click
	onClose ()
	{
		try
		{
			this.dispatchEvent(new CustomEvent('close'));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onClose]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onItemDescriptionChange (event)
	{
		try
		{
			this.input.itemDescription = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onItemDescriptionChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onSupplierNameChange (event)
	{
		try
		{

			
				this.input.nameSupplier = event.target.value;
				this.validateAllInputs();
			

			
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onSupplierNameChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onAdjustedCostChange (event)
	{
		try
		{
			this.input.adjustedCost = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onAdjustedCostChange]: ${ exception.message }`);
		}
	}


	// Stores value and validates input
	onUnitPriceChange (event)
	{
		try
		{
			this.input.unitPrice = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onUnitPriceChange]: ${ exception.message }`);
		}
	}

// Stroes Value and validate input for List Price NAIT-135515

onListPriceChange (event)
	{
		try
		{
			this.input.maxListPrice = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onListPriceChange]: ${ exception.message }`);
		}
	}





	// Stores value and validates input
	onQuantityChange (event)
	{
		try
		{
			this.input.quantity = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onQuantityChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onOriginalCostChange (event)
	{
		try
		{
			this.input.originalCost = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onOriginalCostChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onManufacturerIdChange (event)
	{
		try
		{
			this.input.vendorManufacturerId = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onManufacturerIdChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onManufacturerNameChange (event)
	{
		try
		{
			this.input.vendorManufacturerName = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onManufacturerNameChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onManufacturerPartNumberChange (event)
	{
		try
		{
			this.input.manufacturerPartNumber = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onManufacturerPartNumberChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onSkuChange (event)
	{
		try
		{
			this.input.sku = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onSkuChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onUpcChange (event)
	{
		try
		{
			this.input.upc = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onUpcChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onShippingChange (event)
	{
		try
		{
			this.input.shipping = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onShippingChange]: ${ exception.message }`);
		}
	}

	// Stores value and validates input
	onMarginChange (event)
	{
		try
		{
			this.input.margin = event.target.value;
			this.validateAllInputs();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleManualEntry@onMarginChange]: ${ exception.message }`);
		}
	}

	validateAllInputs ()
	{
		this.isFormValid = true;

		// Validate the Scratchpad inputs first (the global margin, the tax, etc)
		const lightningInputs = this.template.querySelectorAll('lightning-input');
		for (let input of lightningInputs)
		{
			if (input.reportValidity() === false)
			{
				// This input has an error
				this.isFormValid = false;
			}
		}
		//supplierName change NAIT-135518
		const lightningcombobox = this.template.querySelectorAll('lightning-combobox');
		for (let input of lightningcombobox)
		{
			if (input.reportValidity() === false)
			{
				// This input has an error
				this.isFormValid = false;
			}
		}
		//<!--supplierName change NAIT-135518-->
	}
}