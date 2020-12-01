/* eslint-disable no-void */
/* eslint-disable no-console */
import {LightningElement, api, track} from 'lwc';
import * as EAU from 'c/endlessAisleUtilities';

export default class EndlessAisleMoreDetails extends LightningElement
{
	@api product;
	@api isReplacing;

	@track _product;
	@track supplier;
	@track errors = {
		table: {
			title: 'Your entry cannot be saved. Fix the errors and try again.',
			messages: [
				'Please enter a valid quantity.'
			]
		}
	};
	@track hasError = false;
	@track availableSuppliers = [];
	@track columns =
		[
			{label: 'Supplier', fieldName: 'Supplier'},
			{label: 'SKU', fieldName: 'sku'},
			{label: 'Description', fieldName: 'Description'},
			{label: 'Supplier Part #', fieldName: 'SupplierPart'},
			{label: 'Quantity', fieldName: 'Quantity', type: 'number', typeAttributes: {minimumIntegerDigits: '1'}, editable: true},
			{label: 'Original Cost', fieldName: 'Cost', type: 'currency', typeAttributes: {currencyCode: 'USD'}},
			{label: 'Adjusted Cost', fieldName: 'AdjustedPrice', type: 'currency', typeAttributes: {currencyCode: 'USD', minimumIntegerDigits: '1'}, editable: true},
			{label: 'Unit Price', fieldName: 'CustomerPrice', type: 'currency', typeAttributes: {currencyCode: 'USD', minimumIntegerDigits: '1'}, editable: true},
			{label: 'Margin %', fieldName: 'margin', type: 'number', typeAttributes: {minimumIntegerDigits: '1'}, editable: true},
			{label: 'Subtotal', fieldName: 'subtotal', type: 'currency', typeAttributes: {currencyCode: 'USD'}}
		];
	@api get isSomeLineItemSelected () {return this.supplier ? true : false;}
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
	connectedCallback ()
	{
		try
		{
			this._product = EAU.clone(this.product);
			this._product.results.forEach(element => 
			{
				let vendor = EAU.clone(element);
				vendor.uniqueId = '_' + Math.random().toString(36).substr(2, 9);
				this.availableSuppliers.push(vendor);
			});

			this.refreshMargins();
			this.refreshTotals();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@connectedCallback]: ${ exception.message }`);
		}
	}
	onTableRowSelection (event)
	{
		try
		{
			if (event.detail.selectedRows.length !== 0)
			{
				let selected_row = event.detail.selectedRows[ 0 ];
				this.supplier = selected_row;
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@onTableRowSelection]: ${ exception.message }`);
		}
	}
	onChangeSupplier ()
	{
		try
		{
			this._product.supplierName = this.supplier.Supplier || null;
			this._product.odSkuNumber = this.supplier.odSkuNumber || null;
			this._product.itemDescription = this.supplier.Description || '';
			this._product.supplierPartNumber = this.supplier.SupplierPart || null;
			this._product.quantity = parseInt(this.supplier.Quantity, 10) || 1;
			this._product.originalCost = EAU.toSimpleNumber(this.supplier.Cost);
			this._product.adjustedCost = EAU.toSimpleNumber(this.supplier.AdjustedPrice);
			this._product.customerPrice = EAU.toSimpleNumber(this.supplier.CustomerPrice);
			this._product.totalPrice = EAU.toSimpleNumber(parseInt(this.supplier.Quantity, 10) * EAU.toSimpleNumber(this.supplier.CustomerPrice));
			this._product.vendorNumber = this.supplier.Id || null;
			this._product.isVirtualWarehouseItem = this.supplier.is_virtual_warehouse_item || null;
			this._product.packageSize = this.supplier.package_size || null;
			this._product.unitOfMeasure = this.supplier.package_units_of_measure || null;
			this._product.vendorManufacturerId = this.supplier.manufacturer_id || null;

			this.dispatchEvent(new CustomEvent('changesupplier', {detail: {item: EAU.clone(this._product)}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@onChangeSupplier]: ${ exception.message }`);
		}
	}
	onAddToScratchpad ()
	{
		try
		{
			this._product.supplierName = this.supplier.Supplier || null;
			this._product.odSkuNumber = this.supplier.odSkuNumber || null;
			this._product.itemDescription = this.supplier.Description || '';
			this._product.supplierPartNumber = this.supplier.SupplierPart || null;
			this._product.quantity = parseInt(this.supplier.Quantity, 10) || 1;
			this._product.originalCost = EAU.toSimpleNumber(this.supplier.Cost);
			this._product.adjustedCost = EAU.toSimpleNumber(this.supplier.AdjustedPrice);
			this._product.customerPrice = EAU.toSimpleNumber(this.supplier.CustomerPrice) || 0;
			this._product.totalPrice = EAU.toSimpleNumber(parseInt(this.supplier.Quantity, 10) * EAU.toSimpleNumber(this.supplier.CustomerPrice));
			this._product.vendorNumber = this.supplier.Id || null;
			this._product.isVirtualWarehouseItem = this.supplier.is_virtual_warehouse_item || null;
			this._product.packageSize = this.supplier.package_size || null;
			this._product.unitOfMeasure = this.supplier.package_units_of_measure || null;
			this._product.vendorManufacturerId = this.supplier.manufacturer_id || null;

			this.dispatchEvent(new CustomEvent('addtoscratchpad', {detail: {item: EAU.clone(this._product)}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@onAddToScratchpad]: ${ exception.message }`);
		}
	}
	refreshMargins ()
	{
		try
		{
			let updatedSuppliers = [];
			for (let supplier of this.availableSuppliers)
			{
				supplier.margin = EAU.toSimpleNumber((EAU.toSimpleNumber(supplier.CustomerPrice) - EAU.toSimpleNumber(supplier.AdjustedPrice)) * 100 / EAU.toSimpleNumber(supplier.CustomerPrice));
				updatedSuppliers.push(supplier);
			}
			this.availableSuppliers = updatedSuppliers;
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@refreshTotals]: ${ exception.message }`);
		}
	}
	refreshTotals ()
	{
		try
		{
			let updatedSuppliers = [];
			for (let supplier of this.availableSuppliers)
			{
				supplier.subtotal = EAU.toSimpleNumber(parseInt(supplier.Quantity, 10) * EAU.toSimpleNumber(supplier.CustomerPrice));
				updatedSuppliers.push(supplier);
			}
			this.availableSuppliers = updatedSuppliers;
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@refreshTotals]: ${ exception.message }`);
		}
	}
	onClose ()
	{
		try
		{
			this.dispatchEvent(new CustomEvent('close'));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@onClose]: ${ exception.message }`);
		}
	}
	refreshUnitPrices ()
	{
		try
		{
			let updatedSuppliers = [];
			for (let supplier of this.availableSuppliers)
			{
				supplier.CustomerPrice = EAU.toSimpleNumber(EAU.toSimpleNumber(supplier.AdjustedPrice) / (1 - (EAU.toSimpleNumber(supplier.margin) / 100)));
				updatedSuppliers.push(supplier);
			}
			this.availableSuppliers = updatedSuppliers;
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@refreshUnitPrice]: ${ exception.message }`);
		}
	}
	onTableSave (event)
	{
		try
		{
			this.hasError = false;
			for (let values of event.detail.draftValues)
			{
				for (let supplier of this.availableSuppliers)
				{
					if (supplier.Id === values.Id)
					{
						for (let property in values)
						{
							if (property != 'Id')
							{
								supplier[ property ] = values[ property ];
							}
						}

						if (values.AdjustedPrice || values.AdjustedPrice === 0)
						{
							supplier.AdjustedPrice = EAU.toSimpleNumber(values.AdjustedPrice);
							this.refreshMargins();
						}

						if (values.CustomerPrice || values.CustomerPrice === 0)
						{
							supplier.CustomerPrice = EAU.toSimpleNumber(values.CustomerPrice);
							this.refreshMargins();
						}

						if (values.margin || values.margin === 0)
						{
							supplier.margin = EAU.toSimpleNumber(values.margin);
							this.refreshUnitPrices();
						}

						if (values.Quantity || values.Quantity === 0)
						{
							values.Quantity = EAU.toSimpleNumber(values.Quantity);
							if (values.Quantity <= 0)
							{
								this.hasError = true;
							}
							else
							{
								supplier.Quantity = values.Quantity;
								this.refreshUnitPrices();
							}
						}
					}
					if (this.supplier && this.supplier.Id === supplier.Id)
					{
						this.supplier = supplier;
					}
					continue;
				}
			}

			if (this.hasError === false)
			{
				this.refreshTotals();

				// Removes the yellow color from the edited cells and hides the Save and Cancel buttons
				let datatable = this.template.querySelector('lightning-datatable');
				datatable.draftValues = null;
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleMoreDetails@onTableSave]: ${ exception.message }`);
		}
	}
	onTableCellChange (event)
	{
		for (let values of event.detail.draftValues)
		{
			if (EAU.toSimpleNumber(values.Quantity) <= 0)
			{
				this.errors = {
					rows: {
						a: {
							title: 'We found 1 error.',
							messages: [ 'Enter a valid quantity.' ],
							fieldNames: [ 'Quantity' ]
						}
					},
					table: {
						title: 'Your entry cannot be saved. Fix the errors and try again.',
						messages: [
							'Quantity cannot be 0 or negative.'
						]
					}
				};
			}
			else
			{
				this.errors = {};
			}
		}
	}
}