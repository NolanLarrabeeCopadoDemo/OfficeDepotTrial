import { LightningElement, api } from 'lwc';
import getHostURL from "@salesforce/apex/MyUtils.getHostURL";
export default class NavigateToObject extends LightningElement {
    @api recordId;

    getRedirectURL = async () => {
        try {
            let home_url = await getHostURL();
            let redirect = home_url + '/' + this.recordId;
            window.location = redirect;
          } catch (error) {
            console.error(JSON.stringify(error));
            this.error = error;
            this.friendly_error =
              "An error occured while retrieving the record url.";
          } finally {
            this.loading_url = false;
          }
    }

    connectedCallback(){
        this.loading_url = true;
        this.getRedirectURL();
    }
}