import { LightningElement, track, api } from 'lwc';
import getCostCenterResults from '@salesforce/apex/EndlessAisleQuoteSetup.getCostCenterResults';
import getPONumberResults from '@salesforce/apex/EndlessAisleQuoteSetup.getPONumberResults';
import getDesktopNumberResults from '@salesforce/apex/EndlessAisleQuoteSetup.getDesktopNumberResults';
import getReleaseNumberResults from '@salesforce/apex/EndlessAisleQuoteSetup.getReleaseNumberResults';
import getShipToResults from '@salesforce/apex/EndlessAisleQuoteSetup.getShipToResults';
import getContactResults from '@salesforce/apex/EndlessAisleQuoteSetup.getContactResults';
import getFieldRestrictions from '@salesforce/apex/EndlessAisleQuoteSetup.getFieldRestrictions';

export default class EndlessAisleQuoteSetupPopup extends LightningElement
{
	@api recordId;
	@api costCenter;
	@api poNumber;
	@api desktopNumber;
	@api releaseNumber;
	@api shipTo;
	@api contact;

	@track _costCenter = {
		value: '',
		data: [],
		columns: [
			{ label: 'Cost Center', fieldName: 'CCU001F_CUSTOMER_DEPT_KEY__c' }
		],
		code: null,
		get isRequired ()
		{
			return this.code === 'Y';
		},
		get pillLabel ()
		{
			return `Cost Center: ${this.value}`;
		},
		get isVisible ()
		{
			return this.code !== 'H';
		},
		get isChanged () 
		{
			return this.value !== '' && this.value !== null;
		}
	};
	@track _poNumber = {
		value: '',
		data: [],
		columns: [
			{ label: 'PO Number', fieldName: 'FCU009P_PO_NBR__c' }
		],
		code: null,
		get isRequired ()
		{
			return this.code === 'Y';
		},
		get pillLabel ()
		{
			return `PO Number: ${this.value}`;
		},
		get isVisible ()
		{
			return this.code !== 'H';
		},
		get isChanged () 
		{
			return this.value !== '' && this.value !== null;
		}
	};
	@track _desktopNumber = {
		value: '',
		data: [],
		columns: [
			{ label: 'Desktop Number', fieldName: 'CCU003F_CUST_LOCATION_KEY__c' }
		],
		code: null,
		get isRequired ()
		{
			return this.code === 'Y';
		},
		get pillLabel ()
		{
			return `Desktop Number: ${this.value}`;
		},
		get isVisible ()
		{
			return this.code !== 'H';
		},
		get isChanged () 
		{
			return this.value !== '' && this.value !== null;
		}
	};
	@track _releaseNumber = {
		value: '',
		data: [],
		columns: [
			{ label: 'Release Number', fieldName: 'CCU005F_RELEASE_NBR__c' }
		],
		code: null,
		get isRequired ()
		{
			return this.code === 'Y';
		},
		get pillLabel ()
		{
			return `Release Number: ${this.value}`;
		},
		get isVisible ()
		{
			return this.code !== 'H';
		},
		get isChanged () 
		{
			return this.value !== '' && this.value !== null;
		}
	};
	@track _shipTo = {
		value: '',
		data: [],
		columns: [
			{ label: 'Name', fieldName: 'Name' },
			{ label: 'ID', fieldName: 'Cust_ID__c' }
		],
		recordId: null,
		code: null,
		get url ()
		{
			return this.recordId ? `/lightning/r/${this.recordId}/view` : '#';
		},
		get pillLabel ()
		{
			return `Ship To: ${this.value}`;
		},
		get isChanged () 
		{
			return this.value !== '' && this.value !== null;
		}
	};
	@track _contact = {
		value: '',
		data: [],
		columns: [
			{ label: 'Name', fieldName: 'Name' },
			{ label: 'Email', fieldName: 'Email' }
		],
		recordId: null,
		code: null,
		get url ()
		{
			return this.recordId ? `/lightning/r/${this.recordId}/view` : '#';
		},
		get pillLabel ()
		{
			return `Contact: ${this.value}`;
		},
		get isChanged ()
		{
			return this.value !== '' && this.value !== null;
		}
	};
	@track search = {
		key: null,
		value: '',
		isLoading: false,
		parent: this,
		get availableKeys ()
		{
			let costCenterKey = { label: 'Cost Center', value: 'costCenter' };
			let poNumberKey = { label: 'PO Number', value: 'poNumber' };
			let desktopNumberKey = { label: 'Desktop Number', value: 'desktopNumber' };
			let releaseNumberKey = { label: 'Release Number', value: 'releaseNumber' };
			let shipToKey = { label: 'Ship To', value: 'shipTo' };
			let contactKey = { label: 'Contact', value: 'contact' };

			let keys = [];

			if (this.parent._costCenter.code !== 'H')
			{
				if (this.parent._costCenter.code === 'Y')
				{
					costCenterKey.label = '* '.concat(costCenterKey.label);
				}
				keys.push(costCenterKey);
			}
			if (this.parent._poNumber.code !== 'H')
			{
				if (this.parent._poNumber.code === 'Y')
				{
					poNumberKey.label = '* '.concat(poNumberKey.label);
				}
				keys.push(poNumberKey);
			}
			if (this.parent._desktopNumber.code !== 'H')
			{
				if (this.parent._desktopNumber.code === 'Y')
				{
					desktopNumberKey.label = '* '.concat(desktopNumberKey.label);
				}
				keys.push(desktopNumberKey);
			}
			if (this.parent._releaseNumber.code !== 'H')
			{
				if (this.parent._releaseNumber.code === 'Y')
				{
					releaseNumberKey.label = '* '.concat(releaseNumberKey.label);
				}
				keys.push(releaseNumberKey);
			}

			keys.push(shipToKey, contactKey);

			return keys;
		}
	};
	@track hasRendered = false;
	@track isLoading = false;

	get isCostCentersTableVisible () 
	{
		return this.search.key === 'costCenter';
	}
	get isPONumbersTableVisible () 
	{
		return this.search.key === 'poNumber';
	}
	get isDesktopNumbersTableVisible () 
	{
		return this.search.key === 'desktopNumber';
	}
	get isReleaseNumbersTableVisible ()
	{
		return this.search.key === 'releaseNumber';
	}
	get isShipTosTableVisible () 
	{
		return this.search.key === 'shipTo';
	}
	get isContactsTableVisible () 
	{
		return this.search.key === 'contact';
	}
	get isAnyValueChanged ()
	{
		return this._costCenter.isChanged || this._poNumber.isChanged || this._desktopNumber.isChanged || this._releaseNumber.isChanged || this._shipTo.isChanged || this._contact.isChanged;
	}
	get isAnyValueEntered ()
	{
		return this.search.value.length > 0;
	}
	get isOverrideSafe ()
	{
		switch (this.search.key)
		{
			case 'costCenter':
				return this._costCenter.code !== 'V';
				break;
			case 'poNumber':
				return this._poNumber.code !== 'V';
				break;
			case 'desktopNumber':
				return this._desktopNumber.code !== 'V';
				break;
			case 'releaseNumber':
				return this._releaseNumber.code !== 'V';
				break;
			default:
				return false;
		}
	}
	get areRequiredFieldsFulfilled ()
	{
		let fulfilled = true;

		if (this._costCenter.code === 'Y' && (this._costCenter.value === null || this._costCenter.value === undefined || this._costCenter.value === ''))
			fulfilled = false;
		if (this._poNumber.code === 'Y' && (this._poNumber.value === null || this._poNumber.value === undefined || this._poNumber.value === ''))
			fulfilled = false;
		if (this._desktopNumber.code === 'Y' && (this._desktopNumber.value === null || this._desktopNumber.value === undefined || this._desktopNumber.value === ''))
			fulfilled = false;
		if (this._releaseNumber.code === 'Y' && (this._releaseNumber.value === null || this._releaseNumber.value === undefined || this._releaseNumber.value === ''))
			fulfilled = false;

		return fulfilled;
	}

	connectedCallback ()
	{
		this.isLoading = true;
		this.init();
		getFieldRestrictions({ quoteId: this.recordId })
			.then(response =>
			{
				response = JSON.parse(response)[0];
				if (response)
				{
					this._costCenter.code = response.DEPT_REQUIRED_CODE__c;
					this._poNumber.code = response.PO_REQUIRED_CODE__c;
					this._desktopNumber.code = response.LOCATION_REQ_CODE_7__c;
					this._releaseNumber.code = response.RELEASE_REQUIRED_CODE__c;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
				this.isLoading = false;
			});
	}
	init ()
	{
		this._costCenter.code = JSON.parse(JSON.stringify(this.costCenter.code));
		this._poNumber.code = JSON.parse(JSON.stringify(this.poNumber.code));
		this._desktopNumber.code = JSON.parse(JSON.stringify(this.desktopNumber.code));
		this._releaseNumber.code = JSON.parse(JSON.stringify(this.releaseNumber.code));

		this._costCenter.value = JSON.parse(JSON.stringify(this.costCenter.value));
		this._poNumber.value = JSON.parse(JSON.stringify(this.poNumber.value));
		this._desktopNumber.value = JSON.parse(JSON.stringify(this.desktopNumber.value));
		this._releaseNumber.value = JSON.parse(JSON.stringify(this.releaseNumber.value));
		this._shipTo.value = JSON.parse(JSON.stringify(this.shipTo.value));
		this._contact.value = JSON.parse(JSON.stringify(this.contact.value));

		this._shipTo.recordId = JSON.parse(JSON.stringify(this.shipTo.recordId));
		this._contact.recordId = JSON.parse(JSON.stringify(this.contact.recordId));

		this.forceRerender();
	}
	renderedCallback ()
	{
		if (this.hasRendered === false)
		{
			this.hasRendered = true;
			this.onFirstRender();
		}
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

	onFirstRender ()
	{
		this.transitionIntoView();
	}
	onCloseClick (event)
	{
		this.dispatchEvent(new CustomEvent('close'));
	}
	onSaveChangesClick (event)
	{
		let params =
		{
			detail:
			{
				costCenter: this._costCenter,
				poNumber: this._poNumber,
				desktopNumber: this._desktopNumber,
				releaseNumber: this._releaseNumber,
				shipTo: this._shipTo,
				contact: this._contact
			}
		};

		// if (this._costCenter.isChanged)
		// 	params.detail.costCenter = this._costCenter;
		// if (this._poNumber.isChanged)
		// 	params.detail.poNumber = this._poNumber;
		// if (this._desktopNumber.isChanged)
		// 	params.detail.desktopNumber = this._desktopNumber;
		// if (this._releaseNumber.isChanged)
		// 	params.detail.releaseNumber = this._releaseNumber;
		// if (this._shipTo.isChanged)
		// 	params.detail.shipTo = this._shipTo;
		// if (this._contact.isChanged)
		// 	params.detail.contact = this._contact;

		this.dispatchEvent(new CustomEvent('save', params));
	}
	onSearchKeyChange (event)
	{
		this.search.key = event.target.value;
		this.search.value = '';
	}
	onSearchValueChange (event)
	{
		this.search.value = event.target.value;
	}
	onSearchKeyPress (event)
	{
		if (event.key === 'Enter')
		{
			this.performSearch();
		}
	}
	onSearchClick (event)
	{
		this.performSearch();
	}
	onOverrideClick (event)
	{
		switch (this.search.key)
		{
			case 'costCenter':
				this._costCenter.value = this.search.value;
				this.forceRerender();
				break;
			case 'poNumber':
				this._poNumber.value = this.search.value;
				this.forceRerender();
				break;
			case 'desktopNumber':
				this._desktopNumber.value = this.search.value;
				this.forceRerender();
				break;
			case 'releaseNumber':
				this._releaseNumber.value = this.search.value;
				this.forceRerender();
				break;
			case 'shipTo':
				this._shipTo.value = this.search.value;
				this.forceRerender();
				break;
			case 'contact':
				this._contact.value = this.search.value;
				this.forceRerender();
				break;
		}
	}
	onFieldSelection (event)
	{
		this.search.key = event.detail.name;
		this.search.value = '';
	}

	onCostCenterTableSelection (event)
	{
		this._costCenter.value = event.detail.selectedRows[0].CCU001F_CUSTOMER_DEPT_KEY__c;
		this.forceRerender();
	}
	onPONumberTableSelection (event)
	{
		this._poNumber.value = event.detail.selectedRows[0].FCU009P_PO_NBR__c;
		this.forceRerender();
	}
	onDesktopNumberTableSelection (event)
	{
		this._desktopNumber.value = event.detail.selectedRows[0].CCU003F_CUST_LOCATION_KEY__c;
		this.forceRerender();
	}
	onReleaseNumberTableSelection (event)
	{
		this._releaseNumber.value = event.detail.selectedRows[0].CCU005F_RELEASE_NBR__c;
		this.forceRerender();
	}
	onShipToTableSelection (event)
	{
		this._shipTo.value = event.detail.selectedRows[0].Name;
		this._shipTo.recordId = event.detail.selectedRows[0].Id;
		this.forceRerender();
	}
	onContactTableSelection (event)
	{
		this._contact.value = event.detail.selectedRows[0].Name;
		this._contact.recordId = event.detail.selectedRows[0].Id;
		this.forceRerender();
	}

	onCostCenterRemove (event)
	{
		this._costCenter.value = '';
		if (this.template && this.isCostCentersTableVisible)
		{
			let datatable = this.template.querySelector('lightning-datatable');
			if (datatable) datatable.selectedRows = [];
		}
		this.forceRerender();
	}
	onPONumberRemove (event)
	{
		this._poNumber.value = '';
		if (this.template && this.isPONumbersTableVisible)
		{
			let datatable = this.template.querySelector('lightning-datatable');
			if (datatable) datatable.selectedRows = [];
		}
		this.forceRerender();
	}
	onDesktopNumberRemove (event)
	{
		this._desktopNumber.value = '';
		if (this.template && this.isDesktopNumbersTableVisible)
		{
			let datatable = this.template.querySelector('lightning-datatable');
			if (datatable) datatable.selectedRows = [];
		}
		this.forceRerender();
	}
	onReleaseNumberRemove (event)
	{
		this._releaseNumber.value = '';
		if (this.template && this.isReleaseNumbersTableVisible)
		{
			let datatable = this.template.querySelector('lightning-datatable');
			if (datatable) datatable.selectedRows = [];
		}
		this.forceRerender();
	}
	onShipToRemove (event)
	{
		this._shipTo.value = '';
		this._shipTo.recordId = null;
		if (this.template && this.isShipTosTableVisible)
		{
			let datatable = this.template.querySelector('lightning-datatable');
			if (datatable) datatable.selectedRows = [];
		}
		this.forceRerender();
	}
	onContactRemove (event)
	{
		this._contact.value = '';
		this._contact.recordId = null;
		if (this.template && this.isContactsTableVisible)
		{
			let datatable = this.template.querySelector('lightning-datatable');
			if (datatable) datatable.selectedRows = [];
		}
		this.forceRerender();
	}

	forceRerender ()
	{
		let temp = this.search.value;
		this.search.value = null;
		this.search.value = JSON.parse(JSON.stringify(temp));
	}
	performSearch ()
	{
		switch (this.search.key)
		{
			case 'costCenter':
				this.findCostCenters();
				break;
			case 'poNumber':
				this.findPONumbers();
				break;
			case 'desktopNumber':
				this.findDesktopNumbers();
				break;
			case 'releaseNumber':
				this.findReleaseNumbers();
				break;
			case 'shipTo':
				this.findShipTos();
				break;
			case 'contact':
				this.findContacts();
				break;
		}
	}
	findCostCenters ()
	{
		this.search.isLoading = true;
		getCostCenterResults({ quoteId: this.recordId, searchTerm: this.search.value })
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this._costCenter.data = response;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
				this.search.isLoading = false;
			});
	}
	findPONumbers ()
	{
		this.search.isLoading = true;
		getPONumberResults({ quoteId: this.recordId, searchTerm: this.search.value })
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this._poNumber.data = response;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
				this.search.isLoading = false;
			});
	}
	findDesktopNumbers ()
	{
		this.search.isLoading = true;
		getDesktopNumberResults({ quoteId: this.recordId, searchTerm: this.search.value })
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this._desktopNumber.data = response;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
				this.search.isLoading = false;
			});
	}
	findReleaseNumbers ()
	{
		this.search.isLoading = true;
		getReleaseNumberResults({ quoteId: this.recordId, searchTerm: this.search.value })
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this._releaseNumber.data = response;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
				this.search.isLoading = false;
			});
	}
	findShipTos ()
	{
		this.search.isLoading = true;
		getShipToResults({ quoteId: this.recordId, searchTerm: this.search.value })
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this._shipTo.data = response;
					this._shipTo.recordId = response.Id;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
				this.search.isLoading = false;
			});
	}
	findContacts ()
	{
		this.search.isLoading = true;
		getContactResults({ quoteId: this.recordId, searchTerm: this.search.value })
			.then(response =>
			{
				response = JSON.parse(response);
				if (response)
				{
					this._contact.data = response;
					this._contact.recordId = response.Id;
				}
			})
			.catch(error =>
			{
			})
			.finally(() =>
			{
				this.search.isLoading = false;
			});
	}
}