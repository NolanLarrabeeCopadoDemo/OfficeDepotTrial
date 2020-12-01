/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable @lwc/lwc/no-inner-html */
/* eslint-disable no-console */
import getResults from '@salesforce/apex/lwcCustomLookupController.getResults';
import { LightningElement, api, track } from 'lwc';

export default class LightningCustomLookup extends LightningElement
{
	@api field;
	@api object;
	@api isRequired;

	@track value;
	@track isLoading = false;
	@track results = [];
	@track hasRendered = false;
	@track hasFocus = false;
	@track dropdownClass = "slds-dropdown slds-dropdown_length-5 slds-dropdown_fluid od-dropdown";

	selectedResult;
	error;
	fetchResults;

	get areResultsAvailable ()
	{
		return this.results.length > 0;
	}
	get isResultSelected ()
	{
		return !!this.selectedResult === true;
	}

	connectedCallback ()
	{
	}

	renderedCallback ()
	{
		if (!this.hasRendered)
		{
			this.hasRendered = true;
			this.onFirstRender();
		}
	}

	/**
	 * Adds handlers to the component template to handle onfocusin and onfocusout events.
	 * We need to handle these events so we can keep the dropdown displayed at the proper times.
	 */
	onFirstRender ()
	{
		let that = this;
		this.template.addEventListener('focusin', async function ()
		{
			await (that.hasFocus = true);
			that.updateDropdownState();
		});
		this.template.addEventListener('focusout', function ()
		{
			let hoveredElement = that.template.querySelector(':hover');
			if (!hoveredElement)
			{
				that.hasFocus = false;
			}
			that.updateDropdownState();
		});
	}

	/**
	 * This method displays the dropdown and animates it if our component has focus.
	 * Otherwise, it hides the dropdown.
	 */
	updateDropdownState ()
	{
		if (this.hasFocus === true)
		{
			if (this.template)
			{
				let dropdown = this.template.querySelector('.slds-dropdown');
				if (dropdown)
				{
					void dropdown.offsetWidth;
				}
			}

			if (this.dropdownClass.indexOf('show') === -1)
			{
				this.dropdownClass += ' show';
			}
		}
		else
		{
			this.dropdownClass = this.dropdownClass.replace(' show', '');
		}
	}

	/**
	 * Stores the selected option, dispatches the onselect event, and closes the dropdown.
	 * @param {*} event 
	 */
	onResultClick (event)
	{
		let index = Number(event.currentTarget.getAttribute('data-index'));
		if (index || index === 0)
		{
			if (index >= 0 && index < this.results.length)
			{
				this.selectedResult = this.results[index];
				this.value = this.selectedResult.fieldValue;
			}
			this.fireSelectionEvent();
		}
		this.hasFocus = false;
		this.updateDropdownState();
	}

	/**
	 * On search value change, displays the loader and checks the input value.
	 * Clears the selected result.
	 * Clears results if the value is blank.
	 * Calls the debounced function.
	 * @param {*} event 
	 */
	async onSearchValueChange (event)
	{
		this.selectedResult = null;
		this.value = event.target.value;
		await (this.isLoading = true);
		if (this.value === '')
		{
			this.results = [];
			this.isLoading = false;
			return;
		}
		this.fetchResults();
	}
	fetchResults = this.debounce(this._fetchResults, 500);
	_fetchResults ()
	{
		getResults({ objectApiName: this.object, fieldApiName: this.field, searchValue: this.value })
			.then(response =>
			{
				this.handleResponse(response);
			})
			.catch(error =>
			{
				this.handleError(error);
			})
			.finally(() =>
			{
				this.isLoading = false;
			});
	}

	/**
	 * Handles the response recieved from the Apex class.
	 * @param {*} response 
	 */
	handleResponse (response)
	{
		response = JSON.parse(response);
		if (response)
		{
			this.results = response;
			this.fireFoundEvent();
		}
	}

	/**
	 * Handles errors that occur in the Apex class.
	 * @param {*} error 
	 */
	handleError (error)
	{
		console.log('Found an error in LightningCustomLookup @ onSearchValueChange: ' + error);
		this.error = error.body.message;
		this.fireErrorEvent();
	}

	/**
	 * Dispatches an event when an error is found. Sends the error message.
	 */
	fireErrorEvent ()
	{
		let detail = {
			error: this.error
		}
		this.dispatchEvent(new CustomEvent('error', { detail: detail }));
	}

	/**
	 * Dispatches an event when results are found and parsed. Sends the results.
	 */
	fireFoundEvent ()
	{
		let detail = {
			results: this.results
		}
		this.dispatchEvent(new CustomEvent('found', { detail: detail }));
	}

	/**
	 * Dispatches an event when an option is selected. Sends the record id and the field's value.
	 */
	fireSelectionEvent ()
	{
		let detail = {
			recordId: this.selectedResult.recordId,
			fieldValue: this.selectedResult.fieldValue
		}
		this.dispatchEvent(new CustomEvent('select', { detail: detail }));
	}

	/**
	 * An exposed method to report the validity of all lightning-inputs in this component.
	 */
	@api reportValidity ()
	{
		if (!this.template)
		{
			return false;
		}

		let inputs = this.template.querySelectorAll('lightning-input');
		for (let input of inputs)
		{
			if (input.reportValidty() === false)
			{
				return false
			}
		}
		return true;
	}

	/** An exposed method to allow getting the selected result.
	 * TODO: Decorate selectedResult with @api and add a getter and setter for it instead.
	 * @returns The selected result.
	 */
	@api getSelectedResult ()
	{
		return this.selectedResult;
	}

	/**
	 * Using this to create a debounced version of our Apex call function.
	 * This is done to prevent excessive and unnecessary calls to Apex.
	 * @param {*} func The original function to create a debounced version of.
	 * @param {*} wait The delay until the original function executes.
	 */
	debounce (func, wait)
	{
		let timeout
		return function (...args)
		{
			const context = this
			clearTimeout(timeout)
			timeout = setTimeout(() => func.apply(context, args), wait)
		}
	}
}