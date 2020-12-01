import {LightningElement, track} from 'lwc';

export default class EndlessAisleLoader extends LightningElement
{
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
}