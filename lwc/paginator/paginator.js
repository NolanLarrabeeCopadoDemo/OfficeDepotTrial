import { LightningElement,api } from 'lwc';

export default class Paginator extends LightningElement {
@api hidepreviousbutton;
@api hidenextbutton;
//this method handles the previous button with the help of dispatchEvent
    previousHandler() 
    {
     this.dispatchEvent(new CustomEvent('previous'));
    }
//this method handles the Next button with the help of dispatchEvent
    nextHandler() 
    {
     this.dispatchEvent(new CustomEvent('next'));
    }
}