/* eslint-disable eqeqeq */
/* eslint-disable guard-for-in */
/* eslint-disable no-console */
import {LightningElement, track, api} from 'lwc';
import MainCallout from '@salesforce/apex/ProductSearchServiceRequest.MainCallOut';
import OD_LOGO from '@salesforce/resourceUrl/ODHorizontalLogoRed';
import * as EAU from 'c/endlessAisleUtilities';


export default class EndlessAisleProductSearch extends LightningElement
{
	@api get isProductsTableEmpty ()
	{
		return this.table.filteredData.length == 0;
	}
	@api get isSomeLineItemSelected ()
	{
		return this.template.querySelector('lightning-datatable') ? this.template.querySelector('lightning-datatable').getSelectedRows().length > 0 : false;
	}
	@api get odLogoUrl ()
	{
		return OD_LOGO;
	}

	@track isInitializing = false;
	@track isFilterContainerVisible = true;
	@track search = {
		availableKeys: [
			{label: 'Product Name', value: 'keyword'},
			{label: 'SKU', value: 'sku'},
			{label: 'MFG Part #', value: 'od_vpn'},
			{label: 'Vendor Part #', value: 'supplier_vpn'}
		],
		key: 'keyword',
		value: '',
		term: '',
		loading: false,
	};
	@track filter = {
		availableManufacturers: [],
		availableSkus: [],
		vendorManufacturer: null,
		sku: null,
		minListPrice: null,
		maxListPrice: null,
		isApplied: false
	};
	@track table = {
		allData: [],
		filteredData: [],
		selectedRows: [],
		limit: 200,
		offset: 0,
		resultsAvailable: 0,
		sortDirection: null,
		sortBy: null,
		columns: [
			{label: 'Product', fieldName: 'itemDescription', sortable: true},
			{label: 'MFG', fieldName: 'vendorManufacturerName', sortable: true, initialWidth: 150},
			{label: 'MFG Part #', fieldName: 'mfgPartNumber', sortable: true, initialWidth: 150},
			{label: 'SKU', fieldName: 'odSkuNumber', sortable: true, initialWidth: 100},
			{label: 'Price', fieldName: 'max_list_price', sortable: true, initialWidth: 100, type: 'currency', typeAttributes: {currencyCode: 'USD'}},
			{type: 'button', fixedWidth: 130, cellAttributes: {alignment: 'center'}, typeAttributes: {label: 'Details', name: 'more_details', variant: 'neutral'}},
		]
	};
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
	clearSelectedRows ()
	{
		try
		{
			if (this.template)
			{
				let datatable = this.template.querySelector('lightning-datatable');
				if (datatable) datatable.selectedRows = [];
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@clearSelectedRows]: ${ exception.message }`);
		}
	}

	onSearchValueChange (event)
	{
		this.search.value = event.target.value;
	}

	onSearchKeyChange (event)
	{
		this.search.key = event.target.value;
	}

	onManufacturerFilterChange (event)
	{
		try
		{
			this.filter.vendorManufacturer = event.target.value;
			this.dispatchEvent(new CustomEvent('filterchange', {detail: {filter: this.filter}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onManufacturerFilterChange]: ${ exception.message }`);
		}
	}

	onOdSkuFilterChange (event)
	{
		try
		{
			this.filter.sku = event.target.value;
			this.dispatchEvent(new CustomEvent('filterchange', {detail: {filter: this.filter}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onOdSkuFilterChange]: ${ exception.message }`);
		}
	}

	onMinListPriceFilterChange (event)
	{
		try
		{
			this.filter.minListPrice = event.target.value;
			this.dispatchEvent(new CustomEvent('filterchange', {detail: {filter: this.filter}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onMinListPriceFilterChange]: ${ exception.message }`);
		}
	}

	onMaxListPriceFilterChange (event)
	{
		try
		{
			this.filter.maxListPrice = event.target.value;
			this.dispatchEvent(new CustomEvent('filterchange', {detail: {filter: this.filter}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onMaxListPriceFilterChange]: ${ exception.message }`);
		}
	}

	onTableRowSelection (event)
	{
		try
		{
			this.table.selectedRows = event.detail.selectedRows;
			this.dispatchEvent(new CustomEvent('selectionchange', {detail: {selectedRows: this.table.selectedRows}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onTableRowSelection]: ${ exception.message }`);
		}
	}

	increaseOffset ()
	{
		if (this.table.offset < this.table.resultsAvailable)
		{
			this.table.offset += this.table.limit;
		}
	}

	onTableLoadMore (event)
	{
		try
		{
			if (this.table.offset < this.table.resultsAvailable)
			{
				this.getProducts();
			}
		}
		catch (exception)
		{

		}
	}

	onMaxListPriceKeyPress (event)
	{
		try
		{
			if (event.key === 'Enter')
			{
				this.applyFilter();
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onMaxListPriceKeyPress]: ${ exception.message }`);
		}
	}

	onMinListPriceKeyPress (event)
	{
		try
		{
			if (event.key === 'Enter')
			{
				this.applyFilter();
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onMinListPriceKeyPress]: ${ exception.message }`);
		}
	}

	onSearchKeyPress (event)
	{
		try
		{
			// Whenver Enter is pressed
			if (event.key === 'Enter')
			{
				this.search.term = `${ this.search.key }=${ this.search.value }`;
				this.clearFilter();
				this.clearSelectedRows();
				this.resetTable();
				this.getProducts();
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onSearchKeyPress]: ${ exception.message }`);
		}
	}

	resetTable ()
	{
		this.table.allData = [];
		this.table.filteredData = [];
		this.table.offset = 0;
		this.table.resultsAvailable = 0;
	}

	onSearchClick ()
	{
		try
		{
			this.search.term = `${ this.search.key }=${ this.search.value }`;
			this.clearFilter();
			this.clearSelectedRows();
			this.resetTable();
			this.getProducts();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onSearchClick]: ${ exception.message }`);
		}
	}

	onTableRowAction (event)
	{
		try
		{
			let actionName = event.detail.action.name;
			let row = event.detail.row;
			if (actionName == 'more_details')
			{
				this.dispatchEvent(new CustomEvent('openmoredetails', {detail: {product: row}}));
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onTableRowAction]: ${ exception.message }`);
		}
	}

	getProducts ()
	{
		try
		{
			if (this.search.value)
			{
				if (!this.table.allData)
				{
					this.isInitializing = true;
				}

				const params = {
					searchKey: this.search.term,
					offset: this.table.offset.toString(),
					limit: this.table.limit.toString()
				};

				if (this.search.loading === false)
				{
					this.search.loading = true;

					MainCallout({params})
						.then(response =>
						{
							if (response)
							{
								this.handleSearchResponse(response);
							}
							else 
							{
								this.handleSearchError();
							}
						})
						.catch(error =>
						{
							this.dispatchEvent(new CustomEvent('search', {detail: {failed: true}}));
						});
				}
			}
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@getProducts]: ${ exception.message }`);
		}
	}

	handleSearchResponse (response)
	{
		this.table.resultsAvailable = response.count;
		this.increaseOffset();

		const newData = this.table.allData.concat(response.product_list);
		this.table.allData = newData;
		this.table.filteredData = this.table.allData;

		this.filter.availableManufacturers = Array.from(new Set(response.manufacturer_names)).sort().map(element => ({label: element, value: element}));
		this.filter.availableSkus = Array.from(new Set(response.od_skus)).sort().map(element => ({label: element, value: element}));

		this.isInitializing = false;
		this.search.loading = false;
		this.dispatchEvent(new CustomEvent('search', {detail: {failed: false, table: this.table, filter: this.filter}}));
	}

	handleSearchError ()
	{
		this.search.loading = false;
		this.isInitializing = false;
		this.dispatchEvent(new CustomEvent('search', {detail: {failed: true}}));
	}

	onAddItemManuallyClick ()
	{
		try
		{
			this.dispatchEvent(new CustomEvent('additemmanually'));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onAddItemManuallyClick]: ${ exception.message }`);
		}
	}

	onApplyFilterClick ()
	{
		try
		{
			this.applyFilter();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onApplyFilterClick]: ${ exception.message }`);
		}
	}

	onClearFilterClick ()
	{
		try
		{
			this.clearFilter();
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onApplyFilterClick]: ${ exception.message }`);
		}
	}

	applyFilter ()
	{
		try
		{
			this.search.loading = true;
			this.clearSelectedRows();

			//let filteredProductsList = JSON.parse(JSON.stringify(this.table.allData));
			let filteredProductsList = EAU.clone(this.table.allData);

			if (this.filter.vendorManufacturer)
			{
				filteredProductsList = filteredProductsList.filter((product) =>
				{
					return product.vendorManufacturerName == this.filter.vendorManufacturer;
				});
			}

			if (this.filter.sku)
			{
				filteredProductsList = filteredProductsList.filter((product) =>
				{
					return product.odSkuNumber == this.filter.sku;
				});
			}

			if (this.filter.minListPrice || this.filter.minListPrice === 0)
			{
				filteredProductsList = filteredProductsList.filter((product) =>
				{
					return EAU.toSimpleNumber(product.maxListPrice) >= EAU.toSimpleNumber(this.filter.minListPrice);
				});
			}

			if (this.filter.maxListPrice || this.filter.maxListPrice === 0)
			{
				filteredProductsList = filteredProductsList.filter((product) =>
				{
					return EAU.toSimpleNumber(product.maxListPrice) <= EAU.toSimpleNumber(this.filter.maxListPrice);
				});
			}

			this.filter.isApplied = true;
			this.table.filteredData = filteredProductsList;

			this.search.loading = false;
			this.dispatchEvent(new CustomEvent('filter', {detail: {table: this.table, filter: this.filter}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@applyFilter]: ${ exception.message }`);
		}
	}

	clearFilter ()
	{
		try
		{
			this.table.filteredData = this.table.allData;
			this.filter.vendorManufacturer = null;
			this.filter.sku = null;
			this.filter.minListPrice = null;
			this.filter.maxListPrice = null;
			this.filter.isApplied = false;
			this.dispatchEvent(new CustomEvent('clearfilter'));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@clearFilter]: ${ exception.message }`);
		}
	}

	onAddToScratchpad ()
	{
		try
		{
			let addedItems = [];
			let selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();

			for (let row of selectedRows)
			{
				let lowCost = 0;
				let selectedSupplier;

				if (row.results.length > 0)
				{
					lowCost = EAU.toSimpleNumber(row.results[ 0 ].Cost);
					selectedSupplier = row.results[ 0 ];
				}

				for (let supplier of row.results)
				{
					if (EAU.toSimpleNumber(supplier.Cost) < lowCost)
					{
						lowCost = EAU.toSimpleNumber(supplier.Cost);
						selectedSupplier = supplier;
					}
				}

				let obj =
				{
					'originalSupplierPartNumber': row.supplierPartNumber || null,
					'vendorManufacturerName': row.manufacturerName || null,
					'odSkuNumber': row.odSkuNumber || null,
					'maxListPrice': EAU.toSimpleNumber(row.max_list_price),
					'mfgPartNumber': row.mfgPartNumber || null,
					'itemDescription': row.itemDescription || '',
					'price': EAU.toSimpleNumber(row.price),
					'vendorManufacturer': row.manufacturer || null,
					'upcCode': row.upcCode || null,
					'supplierPartNumber': row.supplierPartNumber || null,
					'supplierName': selectedSupplier.Supplier || null,
					'vendorNumber': selectedSupplier.Id || null,
					'originalCost': EAU.toSimpleNumber(selectedSupplier.Cost),
					'adjustedCost': EAU.toSimpleNumber(selectedSupplier.AdjustedPrice),
					'customerPrice': EAU.toSimpleNumber(selectedSupplier.CustomerPrice),
					'quantity': parseInt(selectedSupplier.Quantity, 10) || 1,
					'totalPrice': EAU.toSimpleNumber(parseInt(selectedSupplier.Quantity, 10) * EAU.toSimpleNumber(selectedSupplier.CustomerPrice)),
					'marginDollar': 0,
					'marginPercent': 0,
					'shipping': 0,
					'packageSize': selectedSupplier.package_size || null,
					'unitOfMeasure': selectedSupplier.package_units_of_measure || null,
					'vendorManufacturerId': row.manufacturer || null,
					'lineNumber': null,
					'vendorQuoteNumber': null,
					'odManufacturerId': null,
					'odManufacturerName': null,
					'odManufacturer': null,
					'isVirtualWarehouseItem': selectedSupplier.is_virtual_warehouse_item || null,
					'itemType': selectedSupplier.item_number_type || null,
					'results': row.results || null
				};
				addedItems.push(obj);
			}
			this.dispatchEvent(new CustomEvent('addtoscratchpad', {detail: {items: addedItems}}));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onAddToScratchpad]: ${ exception.message }`);
		}
	}

	sortTable ()
	{
		this.search.loading = true;
		this.clearSelectedRows();
		//let filteredProductsList = JSON.parse(JSON.stringify(this.table.filteredData));
		let filteredProductsList = EAU.clone(this.table.filteredData);
		let fieldName = this.table.sortBy;

		if (this.table.sortDirection === 'asc')
		{
			if (this.isNumberField(this.table.sortBy))
			{
				filteredProductsList.sort(function (a, b)
				{
					return EAU.toSimpleNumber(a[ fieldName ]) - EAU.toSimpleNumber(b[ fieldName ]);
				});
			}
			else
			{
				filteredProductsList.sort(function (a, b)
				{
					return a[ fieldName ] > b[ fieldName ] ? -1 : 1;
				});
			}
		}
		else if (this.table.sortDirection === 'desc')
		{
			if (this.isNumberField(this.table.sortBy))
			{
				filteredProductsList.sort(function (a, b)
				{
					return EAU.toSimpleNumber(b[ fieldName ]) - EAU.toSimpleNumber(a[ fieldName ]);
				});
			}
			else
			{
				filteredProductsList.sort(function (a, b)
				{
					return b[ fieldName ] > a[ fieldName ] ? -1 : 1;
				});
			}
		}

		this.table.filteredData = filteredProductsList;
		this.search.loading = false;

		// Also sort the main products list for when the filter is removed
		//let allProductsList = JSON.parse(JSON.stringify(this.table.allData));
		let allProductsList = EAU.clone(this.table.allData);

		if (this.table.sortDirection === 'asc')
		{
			if (this.isNumberField(this.table.sortBy))
			{
				allProductsList.sort(function (a, b)
				{
					return EAU.toSimpleNumber(a[ fieldName ]) - EAU.toSimpleNumber(b[ fieldName ]);
				});
			}
			else
			{
				allProductsList.sort(function (a, b)
				{
					return a[ fieldName ] > b[ fieldName ] ? -1 : 1;
				});
			}
		}
		else if (this.table.sortDirection === 'desc')
		{
			if (this.isNumberField(this.table.sortBy))
			{
				allProductsList.sort(function (a, b)
				{
					return EAU.toSimpleNumber(b[ fieldName ]) - EAU.toSimpleNumber(a[ fieldName ]);
				});
			}
			else
			{
				allProductsList.sort(function (a, b)
				{
					return b[ fieldName ] > a[ fieldName ] ? -1 : 1;
				});
			}
		}

		this.table.allData = allProductsList;
		this.dispatchEvent(new CustomEvent('sort', {detail: {table: this.table}}));
	}

	onTableSort (event)
	{
		try
		{
			this.table.sortBy = event.detail.fieldName;
			this.table.sortDirection = event.detail.sortDirection;

			this.sortTable();
		}
		catch (exception)
		{
			this.search.loading = false;
			console.error(`Error in [endlessAisleProductSearch@onTableSort]: ${ exception.message }`);
		}
	}

	/**
	 * Determines whether the field fieldName is a numeric one or not
	 * @return {boolean} Returns true if the field fieldName is a numeric one. Returns false otherwise
	 */
	isNumberField (fieldName)
	{
		// These are the types we consider numeric
		let numericTypes = [ 'currency', 'number', 'percent' ];

		// This is the column that corresponds to this field
		let column = this.table.columns.find(element => element.fieldName == fieldName);

		// If the column's type is one of the numeric types
		if (numericTypes.indexOf(column.type) !== -1)
		{
			return true;
		}

		return false;
	}

	onOpenScratchpadClick ()
	{
		try
		{
			this.dispatchEvent(new CustomEvent('gotoscratchpad'));
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onOpenScratchpadClick]: ${ exception.message }`);
		}
	}

	onFilterShowClick ()
	{
		try
		{
			this.isFilterContainerVisible = true;
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onFilterShowClick]: ${ exception.message }`);
		}
	}

	onFilterHideClick ()
	{
		try
		{
			this.isFilterContainerVisible = false;
		}
		catch (exception)
		{
			console.error(`Error in [endlessAisleProductSearch@onFilterHideClick]: ${ exception.message }`);
		}
	}

	// /**
	//  * @param {*} variable The variable to check.
	//  * @return {boolean} Returns true if the parameter is neither null nor undefined.
	//  */
	// notNullUndefinedOrEmptyString (variable)
	// {
	// 	return variable !== null && variable !== undefined && variable !== '';
	// }
}