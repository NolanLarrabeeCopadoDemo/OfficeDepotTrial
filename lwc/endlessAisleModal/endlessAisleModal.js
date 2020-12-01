/* eslint-disable no-console */
/* eslint-disable no-void */
import {LightningElement, api, track} from 'lwc';
import * as EAU from 'c/endlessAisleUtilities';


export default class EndlessAisleModal extends LightningElement
{
	// The title of the modal. Displayed in the header
	@api title;
	// The message displayed in the body of the modal
	@api message;
	// The label of the brand button (the blue button, on the right side of the modal footer)
	@api proceedLabel;
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
	onCloseClick ()
	{
		this.dispatchEvent(new CustomEvent('close'));
	}
	onProceedClick ()
	{
		this.dispatchEvent(new CustomEvent('proceed'));
	}
}