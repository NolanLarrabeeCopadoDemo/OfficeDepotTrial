import { LightningElement, track, api } from "lwc";
import Id from '@salesforce/user/Id';
import WebCollectCallout from "@salesforce/apex/WebCollectRestRequest.WebCollectCallout";

export default class TaxInformation extends LightningElement
{
	@api recordId;
	@api aopsCustId;
	@api employeeId;
	@api noAgingBuckets = false;//Added by Rajendra Shahane for NAIT-136440 Display Combined Aging for Accounts within a Parent/Child Relationship in Customer 360
	@api noCreditLimit = false;//Added by Rajendra Shahane for NAIT-136440 Display Combined Aging for Accounts within a Parent/Child Relationship in Customer 360
	@api hasGhostCard = null;
	@api ebizBillTerms = {};
	@api ebizArBalances = {};
	@api ebizCreditLimits = [];
	@api ebizAgingBucket = [];
	@api ebizBillContacts = [];
	@api ebizArCollector = {};
	@track userId = Id;
	@track showCeditInfo = false;
	@track webCollectResult = {};
	@track ApAndBilling = {
		parent: this,
		columns: [
			{ label: 'Name', fieldName: 'name', type: 'text' },
			{ label: 'Email', fieldName: 'email', type: 'text' },
			{ label: 'Phone', fieldName: 'phone', type: 'text' }
		],
		get data ()
		{
			let data = [];
			if (this.parent._ebizBillContacts)
			{
				for (let contact of this.parent._ebizBillContacts)
				{
					data.push(
						{
							'id': '_' + Math.random().toString(36).substr(2, 9),
							'name': `${ contact.firstname || '' } ${ contact.lastname }`,
							'email': contact.emailaddress,
							'phone': `${ contact.phonecountrycode }${ contact.phoneareacode }${ contact.phonenumber } ${ contact.phonelntype }`
						}
					);
				}
			}
			return data;
		}
	};

	get isSpecialHandling () { return this.resultsObj && this.ebizBillTerms[0].billdocsspecialhandling; }
	get isSignatureRequired () { return this.resultsObj && this.ebizBillTerms[0].billdocssigreq; }
	get _ebizBillTerms () { return this.ebizBillTerms[0] || {}; }
	get _ebizArBalances () { return this.ebizArBalances || {}; }
	get _ebizCreditLimits () {
		

		return this.ebizCreditLimits || []; }
	get _ebizBillContacts () { return this.ebizBillContacts || []; }
	get _ebizArCollector () { return this.ebizArCollector || {}; }
	//Start: Added by Rajendra Shahane for NAIT-136440 Display Combined Aging for Accounts within a Parent/Child Relationship in Customer 360
	get _ebizAgingBucket () { return this.ebizAgingBucket || []; }
	//End: Added by Rajendra Shahane for NAIT-136440 Display Combined Aging for Accounts within a Parent/Child Relationship in Customer 360
	connectedCallback ()
	{
		this.handleCallOut();
	}
	
	handleCallOut ()
	{
		//Start: Added by Rajendra Shahane for NAIT-136440 Display Combined Aging for Accounts within a Parent/Child Relationship in Customer 360
		if(this.ebizAgingBucket && this.ebizAgingBucket.length > 0) this.noAgingBuckets = false;
		else this.noAgingBuckets = true;
		if(this.ebizCreditLimits && this.ebizCreditLimits.length > 0) this.noCreditLimit = false;
		else  this.noCreditLimit = true;
		//End: Added by Rajendra Shahane for NAIT-136440 Display Combined Aging for Accounts within a Parent/Child Relationship in Customer 360
		const params = {
			'recordId': this.recordId,
			'aopsCustId': this.aopsCustId
		};

		if(this.userId == undefined){
            this.showCeditInfo = true;
        }else{
            this.showCeditInfo = false;
        }

		WebCollectCallout({ params })
			.then(result =>
			{
				if (result != null && result.StatusCode === 200)
				{
					this.webCollectResult = result;
				} else
				{
					this.errorMessageContent = result.errorMessage;
				}
			})
	}
}