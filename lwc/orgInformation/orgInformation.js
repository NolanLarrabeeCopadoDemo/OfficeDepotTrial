import { LightningElement,track,api} from 'lwc';
import getOrgInformation from '@salesforce/apex/BulkProspectUploadController.searchCustInformation';

export default class OrgInformation extends LightningElement {
    @track isLoaded = true;
    @api prospectJson=[];
    @track mapData= []; 
    tempmap = [];   
    
    @api
    getOrgInfo() {
      this.isLoaded = true;
      console.log('Before==>',this.prospectJson); 
      let cont = JSON.parse(JSON.stringify(this.prospectJson));
      
      for(var index in cont){
        delete cont[index]['Index'];
        //delete this.accountSetupJson[index]['ProspectId'];
      }
      
      console.log('After==>',cont);
      getOrgInformation({prospectData: JSON.stringify(cont)})
      .then(result => {
          console.log('==>',result); 
          var conts = result;
          for(var key in conts){
              this.mapData.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
              this.tempmap.push({value:conts[key][0], key:key});
            }
          console.log('==>',this.tempmap);  
          this.isLoaded = false;
      })
      .catch(error => {
          console.log(error);
          this.error = error;
          this.isLoaded = false;
      });
    }
  
  connectedCallback(){
    this.isLoaded = true;
      console.log('Before==>',this.prospectJson); 
      let cont = JSON.parse(JSON.stringify(this.prospectJson));
      
      for(var index in cont){
        delete cont[index]['Index'];
        //delete this.accountSetupJson[index]['ProspectId'];
      }
      
      console.log('After==>',cont);
      getOrgInformation({prospectData: JSON.stringify(cont)})
      .then(result => {
          console.log('==>',result); 
          var conts = result;
          for(var key in conts){
              this.mapData.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
              this.tempmap.push({value:conts[key][0], key:key});
            }
          console.log('==>',this.tempmap);  
          this.isLoaded = false;
      })
      .catch(error => {
          console.log(error);
          this.error = error;
          this.isLoaded = false;
      });
  }

  handleChildEvent(event){
    this.isLoaded = true;
    const param = event.detail;
    //alert(textVal);
    var foundIndex = this.tempmap.findIndex(x => x.key == param.key);
    this.tempmap.splice(foundIndex, 1)

    this.tempmap.push({value:JSON.parse(JSON.stringify(param.data)), key:param.key});
    console.log('updated==>',this.tempmap); 
    this.isLoaded = false;
   } 

  handleSpinnerEvent(event){
    //const textVal = event.detail;
    this.isLoaded = event.detail;
  }

  @api
  getJsonData(){
    const fireEvent = new CustomEvent('changejson', {
      detail: {
        screen:'ORG',
        json: this.tempmap
      }
      });
    this.dispatchEvent(fireEvent);
  }
}