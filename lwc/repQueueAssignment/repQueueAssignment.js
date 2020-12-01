import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQueueAssignments from '@salesforce/apex/RepQueueAssignment.getQueueAssignments';
import getLeadQueues from '@salesforce/apex/RepQueueAssignment.getLeadQueues';
import setQueueAssignments from '@salesforce/apex/RepQueueAssignment.setQueueAssignments';

Object.byString = function (o, s) {
    s = s.replace(/\[(\w+)\]/g, '.$1');
    s = s.replace(/^\./, '');
    var a = s.split('.');
    for (var i = 0, n = a.length; i < n; ++i) {
        var k = a[i];
        if (k in o) {
            o = o[k];
        } else {
            return;
        }
    }
    return o;
}

const STRING_FUNCTIONS = {
    STARTS_WITH: (a, b) => String(a).toLowerCase().startsWith(String(b).toLowerCase()),
    ENDS_WITH: (a, b) => String(a).toLowerCase().endsWith(String(b).toLowerCase()),
    CONTAINS: (a, b) => String(a).toLowerCase().contains(String(b).toLowerCase()),
    EQUALS: (a, b) => String(a).toLowerCase().equals(String(b).toLowerCase())
}
const MINIMUM_PRIORITY = 1, MAXIMUM_PRIORITY = 10;

export default class RepQueueAssignment extends LightningElement {
    @api enableFilters;

    @track columns = [];
    @track data = [];
    @track isLoading = true;
    @track errorMessage = null;
    @track repNameFilterValue = null;
    @track queueNameFilterValue = null;
    @track dataFilters = [
        {
            component: this,
            property: 'repName',
            get value() { return this.component.repNameFilterValue },
            fn: STRING_FUNCTIONS.STARTS_WITH
        },
    ]
    @track columnFilters = [
        {
            component: this,
            property: 'label',
            get value() { return this.component.queueNameFilterValue },
            fn: STRING_FUNCTIONS.STARTS_WITH
        }
    ]

    get filteredData() {
        let _filteredData = [];
        this.data.forEach(row => {
            const isValid = this.doesRowPassFilterValidation(row)
            if (isValid) {
                _filteredData.push(row);
            }
        })
        return _filteredData;
    }

    get filteredColumns() {
        let _filteredColumns = [];
        this.columns.forEach(column => {
            const isValid = this.doesColumnPassFilterValidation(column)
            if (isValid) {
                _filteredColumns.push(column);
            }
        })
        return _filteredColumns;
    }

	/**
	 * Returns whether the row object passes the filters in the dataFilters array.
	 * @param {*} row 
	 */
    doesRowPassFilterValidation(row) {
        let isValid = true;
        for (let filter of this.dataFilters) {
            if (filter.value !== null) {
                const value = Object.byString(row, filter.property);
                isValid = isValid && filter.fn(value, filter.value)
            }
        }
        return isValid;
    }

	/**
	 * Returns whether the column object passes the filters in the columnFilters array.
	 * @param {*} column 
	 */
    doesColumnPassFilterValidation(column) {
        let isValid = true;
        for (let filter of this.columnFilters) {
            if (filter.value !== null && column.fieldName !== 'repName') {
                const value = Object.byString(column, filter.property);
                isValid = isValid && filter.fn(value, filter.value);
            }
        }
        return isValid;
    }

    connectedCallback() {
        this.init();
    }

	/**
	 * Initializes the component. Can be used to reset the component to its base state (as a Refresh).
	 */
    init() {
        this.columns = [];
        this.data = [];
        this.isLoading = true;
        this.errorMessage = null;
        this.repNameFilterValue = null;
        this.queueNameFilterValue = null;
        this.dataFilters = [
            {
                component: this,
                property: 'repName',
                get value() { return this.component.repNameFilterValue },
                fn: STRING_FUNCTIONS.STARTS_WITH
            },
        ]
        this.columnFilters = [
            {
                component: this,
                property: 'label',
                get value() { return this.component.queueNameFilterValue },
                fn: STRING_FUNCTIONS.STARTS_WITH
            }
        ]

        const queueAssignmentsPromise = getQueueAssignments()
            .then(response => {
                this.handleQueueAssignmentsResponse(response);
            })
        const leadQueuePromise = getLeadQueues()
            .then(response => {
                this.handleLeadQueuesResponse(response);
            })

        Promise.all([queueAssignmentsPromise, leadQueuePromise])
            .catch(exception => {
                this.handleApexException(exception);
            })
            .finally(() => this.isLoading = false)
    }

    /**
     * Sets the data for the datatable table. The back-end formats it properly.
     * @param {*} response 
     */
    handleQueueAssignmentsResponse(response) {
        this.data = response;
    }

    /**
     * Creates a column in the datatable for each queue.
     * @param {*} response 
     */
    handleLeadQueuesResponse(response) {
        let tempColumns = [{ label: 'Rep', fieldName: 'repName' }];
        for (let leadQueue of response) {
            const queueName = leadQueue.Queue.Name;
            const column = { label: queueName, fieldName: queueName, editable: true, type: 'number' }
            tempColumns.push(column);
        }
        this.columns = tempColumns;
    }

	/**
	 * Handles all of our Apex exceptions
	 * @param {*} exception 
	 */
    handleApexException(exception) {
        const UNEXPECTED_ERROR_MESSAGE = 'Unexpected error occurred. Please try again later.';
        try {
            const errorMessage = exception.body.message;
            if (errorMessage) {
                this.errorMessage = errorMessage;
            }
            else {
                this.errorMessage = UNEXPECTED_ERROR_MESSAGE;
            }
        }
        catch (_exception) {
            this.errorMessage = UNEXPECTED_ERROR_MESSAGE;
        }
    }

    /**
     * Updates the datatable's rows with the draft values, then calls an Apex method to handle updating the object.
     * @param {*} event 
     */
    onTableSave(event) {
        this.isLoading = true;
        const draftValues = event.detail.draftValues;
        let numberOfUpdatedRows = 0;
        let hasError = false;

        for (let index = 0; index < draftValues.length; index++) {
            const draftValue = draftValues[index];
            const repName = draftValue.repName;

            for (let property in draftValue) {
                if (property !== 'repName') {
                    const queueName = property;
                    const priority = draftValue[property] ? Number(draftValue[property]) : null;
                    const isPriorityValid = this.validatePriority(priority);

                    if (isPriorityValid) {
                        this.updateRow(repName, queueName, priority);
                        numberOfUpdatedRows++;
                    }
                    else {
                        hasError = true;
                    }
                }
            }
        }

        this.template.querySelector('lightning-datatable').draftValues = [];

        if (numberOfUpdatedRows > 0) {
            setQueueAssignments({ queueAssignments: this.data })
                .then(response => {
                    const title = 'Queue Assignments Updated';
                    const message = 'The queue assignments were successfully updated.';
                    const variant = 'success';
                    this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
                    this.init();
                })
                .catch(exception => {
                    this.handleApexException(exception);
                    this.isLoading = false;
                })
        }
        else {
            this.isLoading = false;
        }
    }

    /**
     * Returns whether the priority is in the valid range or not.
     * @param {Number|String} priority 
     */
    validatePriority(priority) {
        return !priority || Number(priority) >= MINIMUM_PRIORITY && Number(priority) <= MAXIMUM_PRIORITY;
    }

    /**
     * Updates the queue's priority for rep with name repName.
     * @param {String} repName The name of the rep. 
     * @param {String} queueName The name of the queue.
     * @param {Number} priority The priority of this queue for this rep.
     */
    updateRow(repName, queueName, priority) {
        const row = this.data.find(element => element.repName == repName);
        if (row) {
            row[queueName] = priority;
        }
    }

	/**
	 * Changes the rep name filter value when the input changes.
	 * @param {*} event 
	 */
    onRepNameFilterValueChange(event) {
        this.repNameFilterValue = event.target.value;
    }

	/**
	 * Changes the queue name filter value when the input changes.
	 * @param {*} event 
	 */
    onQueueNameFilterValueChange(event) {
        this.queueNameFilterValue = event.target.value;
    }

	/**
	 * Clears all the filter values
	 * @param {*} event 
	 */
    onClearFilterClick(event) {
        this.repNameFilterValue = null;
        this.queueNameFilterValue = null;
    }
}