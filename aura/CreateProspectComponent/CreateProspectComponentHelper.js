({
	createNewOrgRecordHelper: function (component)
	{
		//var orgRec1 = component.get("v.orgRec");
		//if ($A.util.isEmpty(orgRec1))
		//{

			var action = component.get("c.getProspectAndOpp");
			action.setCallback(this, function (response)
			{
				var state = response.getState();
				if (state === "SUCCESS")
				{
					var result = response.getReturnValue();
					component.set("v.newOrgRec", result.orgRec);
					//component.set("v.contactRec", result.contactRec);
				}

			});
			$A.enqueueAction(action);
		//}

	},
	setContactAndOppRecordTypeHelper: function (component)
	{
		var accRT = component.get("v.prospectRec.RecordTypeId");
		var action = component.get("c.setCtAndOppRT");
		action.setParams({
			"accRecordType": accRT
		});
		action.setCallback(this, function (response)
		{
			var state = response.getState();
			if (state === "SUCCESS")
			{
				var result = response.getReturnValue();
				console.log(',result.accRecTypeName...' + result.accRecTypeName);
				component.set("v.accRecTypeName", result.accRecTypeName);

			}
		});
		$A.enqueueAction(action);
	},
	getVericalPickVal: function (component)
	{
		var industryVal = component.get("v.prospectRec.Industry_OD_SIC_Rep__c");
		var accVericalAction = component.get("c.getAccVericalPickValues");
		accVericalAction.setParams({
			"pObjName": "Account",
			"pControllingFieldName": "Industry_OD_SIC_Rep__c",
			"pDependentFieldName": "Verticals__c",
			"ctrlPicklistVal": industryVal
		});
		accVericalAction.setCallback(this, function (response)
		{
			var accVerticalVal = response.getReturnValue();
			if (!$A.util.isEmpty(accVerticalVal))
			{
				component.set("v.accVerticalVal", response.getReturnValue());
				component.set("v.accVerticalsActive", false);
				component.set("v.accVerticalsRequired", true);
			} else
			{
				var emptyList = [];
				component.set("v.accVerticalVal", emptyList);
				component.set("v.prospectRec.Verticals__c", '');
				component.set("v.accVerticalsActive", true);
				component.set("v.accVerticalsRequired", false);
			}
		});
		$A.enqueueAction(accVericalAction);
	},
	formatPhoneNumber: function (component, phone)
	{
		var s2 = ("" + phone).replace(/\D/g, '');
		var l = s2.length;
		// Trim the remaining input to ten characters, to preserve phone number format
		s2 = s2.substring(l - 10, l);
		// Based upon the length of the string, we add formatting as necessary
		var size = s2.length;
		if (size == 0)
		{
			s2 = s2;
		} else if (size < 4)
		{
			s2 = '(' + s2;
		} else if (size < 7)
		{
			s2 = '(' + s2.substring(0, 3) + ') ' + s2.substring(3, 6);
		} else
		{
			s2 = '(' + s2.substring(0, 3) + ') ' + s2.substring(3, 6) + '-' + s2.substring(6, 10);
		}
		return s2;
	},
	createProspectHelper: function (component)
	{
		component.set("v.validationError", false);
		//Lead Record Id Information
		var leadId = component.get("v.leadRecId");
		var leadData;
		if (!$A.util.isEmpty(leadId))
		{
			leadData = JSON.stringify(component.get("v.leadRec"));
		}

		//Prospect Information
		var prospectAcc = component.get("v.prospectRec");
		var prospectAccData = JSON.stringify(prospectAcc);


		//Contact Record Information
		var contactRec = component.get("v.contactRec");
		var contactRecData = JSON.stringify(contactRec);

		//Parent Org Information
		var parentOrgRec = component.get("v.parentOrgRec");
		var parentOrgRecData = JSON.stringify(parentOrgRec);

		//Family org Information
		var familyOrgRec = component.get("v.selectedFamilyOrgRec");
		var formattedFamilyOrgRec = JSON.stringify(familyOrgRec);


		if (parentOrgRec == null)
		{
			parentOrgRec = '';
		}
		var parentOrgSFIdList = [];
		for (var i = 0; i < parentOrgRec.length; i++)
		{
			parentOrgSFIdList.push(parentOrgRec[ i ].Id);
		}
		var parentOrgSFId = parentOrgSFIdList[ 0 ];

		var newOrFamilyOrgRecData;

		var decisionMaking = component.get("v.isDecisionLocationSelected");
		if (decisionMaking == 'No')
		{
			var familyOrgRecSelected = component.get("v.familyOrgSelected");
			if (familyOrgRecSelected)
			{
				var wbRec = component.get("v.selectedFamilyOrgRec");
				newOrFamilyOrgRecData = JSON.stringify(wbRec);
			} else
			{
				var newOrgRec = component.get("v.newOrgRec");
				newOrFamilyOrgRecData = JSON.stringify(newOrgRec);
			}
		}
		else if (decisionMaking == undefined || decisionMaking == 'None')
		{
			var newOrgRec = component.get("v.newOrgRec");
			newOrFamilyOrgRecData = JSON.stringify(newOrgRec);
		}

		var action = component.get("c.saveProspect");
		action.setParams({
			"prospectData": prospectAccData,
			"contactData": contactRecData,
			"parentOrgData": parentOrgRecData,
			"newOrFamiliyOrgRecData": newOrFamilyOrgRecData,
			"decisionMaking": decisionMaking,
			"parentOrgSFId": parentOrgSFId,
			"leadId": leadId,
			"leadData": leadData
		});
		console.log('Contact Data: ' + contactRecData);
		console.log('Prospect Data: ' + prospectAccData);
		console.log('Lead Data: ' + leadData);
		console.log('Parent Org Data: ' + parentOrgRecData);
		action.setCallback(this, function (response)
		{
			var state = response.getState();
			//alert("state" + state);
			if (state === "SUCCESS")
			{
				var result = response.getReturnValue();
				if (result.StatusCode === -1)
				{
					component.set("v.Spinner", false);
					component.set("v.validationError", true);
					console.log(result);
					var ErrorStatus;
					var ErrorMessage;
					if (result.Status.includes("VALIDATION_EXCEPTION,"))
					{
						ErrorStatus = result.Status.split("VALIDATION_EXCEPTION,");
						ErrorMessage = ErrorStatus[ 1 ].replace(/&quot;/g, '"');
					} else if (result.Status.includes("UNKNOWN_EXCEPTION,"))
					{
						ErrorStatus = result.Status.split("UNKNOWN_EXCEPTION,");
						ErrorMessage = ErrorStatus[ 1 ].replace(/&quot;/g, '"');
					} else if (result.Status.includes("REQUIRED_FIELD_MISSING, "))
					{
						ErrorStatus = result.Status.split("REQUIRED_FIELD_MISSING,");
						ErrorMessage = ErrorStatus[ 1 ].replace(/&quot;/g, '"');
					} else if (result.Status.includes("FIELD_INTEGRITY_EXCEPTION, "))
					{
						ErrorStatus = result.Status.split("FIELD_INTEGRITY_EXCEPTION,");
						ErrorMessage = ErrorStatus[ 1 ].replace(/&quot;/g, '"');
					} else
					{
						ErrorMessage = result.Status;
					}
					component.set("v.errorMessage", ErrorMessage);
					component.set("v.validationError", true);
					//alert("ErrorMessage" + ErrorMessage);
				}
				else if (result == null)
				{
					console.log("An error occurred during lead conversion. " +
						"If your problem persists, please contact IT.");
				} else
				{
					component.set("v.Spinner", false);
					var prospectId = result.Id;
					var appEvent = $A.get("e.c:ProcessIndicatorEvent");
					appEvent.setParams({
						"currentStep": "Prospect Created"
					});
					appEvent.fire();
					component.set("v.showOppInfo", false);
					component.set("v.showProspectSection", false);
					component.set("v.createNewOrg", false);
					component.set("v.backToOrgResultsEnable", false);
					component.set("v.isRadioSelected", undefined);
					component.set("v.familyOrgSelected", false);
					component.set("v.isRecordCreated", true);
					window.open('/' + prospectId, '_self');
				}
			}
			else if (state === "ERROR")
			{
				var errors = response.getError();
				if (errors)
				{
					if (errors[ 0 ] && errors[ 0 ].message)
					{
						console.log("Error message: " + errors[ 0 ].message);
						alert("error" + errors[ 0 ].message);
					}
				} else
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	AssignSpecificOwnerName_helper: function (component, event, helper)
	{
		var AssignSpecificOwner = component.get("v.prospectRec.Assign_Specific_Owner__c");
		if (!$A.util.isEmpty(AssignSpecificOwner) && AssignSpecificOwner != undefined && component.get('v.isCreateOpp')) 
		{
			var action = component.get("c.getAssignSpecificOwnerName");
			action.setParams({AssignSpecOwnerName: AssignSpecificOwner});
			action.setCallback(this, function (response)
			{
				var state = response.getState();
				if (state === "SUCCESS")
				{
					var result = response.getReturnValue();
					component.set("v.AssignSpecOwnerName", result.userData);
				}
			});
			$A.enqueueAction(action);
		}
	}
})