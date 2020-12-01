import { LightningElement,
    api,
    wire,
    track } from 'lwc';
    
import {
    getRecord,
    getFieldValue
    } from 'lightning/uiRecordApi';  

import { NavigationMixin } from 'lightning/navigation';

export default class BulkProspectupload extends NavigationMixin(LightningElement) {

    @track selectedStep = 'Step1';
    @track fileName = '';
    filesUploaded = [];
    @track jsonfile;
    @track jsonorg;
    @track showLoadingSpinner = false;
    @track fileId = '0691k000001PyelAAC';

    get acceptedFormats() {
        console.log("Hi123@@");
        return ['.csv'];
        
    } 

    handleFilesChange(event) {
        this.showLoadingSpinner = true;
        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
            
        }

        var fileInput = event.target.files;
        var file = event.target.files[0];
        var result = [];
       if(file) {
        console.log("UPLOADED")
        var reader = new FileReader();
        reader.readAsText(file, 'UTF-8');
        reader.onload = function(evt) {
            var csv = evt.target.result;
            //console.log('csv+++',csv);
            var lines=csv.split(/\r\n|\n/);         
            var headers=lines[0].split(",");         
            for(var i=1;i<lines.length;i++){
                if(lines[i] && lines[i] !== ""){
                    var obj = {};
                    var currentline=lines[i].split(",");          
                    for(var j=0;j<headers.length;j++){
                        obj[headers[j]] = currentline[j];
                    }         
                    result.push(obj); 
                }                       
            }
             console.log('result:',result); 
        }
        }
        this.jsonfile =result;   
        console.log('jsonfile:',this.jsonfile);
        alert('File uploaded successfully');
        this.showLoadingSpinner=false;
    }

    


    handleNext() {
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step1'){
            if(this.jsonfile && this.jsonfile != null){
                if(this.template.querySelector('c-org-Information')!=null){
                    this.template.querySelector('c-org-Information').getOrgInfo();
                }
                this.selectedStep = 'Step2';
            }else{
                alert('Please upload csv file.');
            }                       
        }
        else if(getselectedStep === 'Step2'){
            this.template.querySelector('c-org-Information').getJsonData();
            this.selectedStep = 'Step3';
        }
        else if(getselectedStep === 'Step3'){
            this.template.querySelector('c-bulk-prospect-edit-insert').saveProspects();
            //this.selectedStep = 'Step4';
        }
        else if(getselectedStep === 'Step4'){
            this.template.querySelector('c-account-setup-request').saveAccountSetupRequests();
            //this.selectedStep = 'Step5';
        }
    }
    
    handlePrev() {
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step1';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step3';
        }
        else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step4';
        }
    }
      
    handleFinish() {
        alert('Finished...');
        this.selectedStep = 'Step1';
    }
      
    selectStep1() {
        //this.selectedStep = 'Step1';
    }
    
    selectStep2() {
        //this.selectedStep = 'Step2';
    }
    
    selectStep3() {
        //this.selectedStep = 'Step3';
    }
    
    selectStep4() {
        //this.selectedStep = 'Step4';
    }
    selectStep5() {
        //this.selectedStep = 'Step5';
    }
    
    get isSelectStep4() {
        return this.selectedStep === "Step4";
    }
    
    get isSelectStep1() {
      return this.selectedStep === "Step1";
    }
    
    get isSelectStep2() {
      return this.selectedStep === "Step2";
    }

    get isSelectStep3() {
      return this.selectedStep === "Step3";
    }

    get isSelectStep5() {
        return this.selectedStep === "Step5";
    }


    readFiles(event){
        alert(JSON.stringify(this.jsonfile));
    }

    handleJson(event){
        const screen = event.detail.screen;
        if(screen === 'ORG'){
            this.jsonorg = event.detail.json;
        }else if(screen === 'PROSPECT'){
            this.selectedStep = 'Step4';
            this.jsonfile = event.detail.json;
        }
        
    }  
    handleStepChange(event){
        const param = event.detail;
        this.selectedStep = param;
    }  
    downloadClick() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/sfc/servlet.shepherd/document/download/0691k000001PyelAAC'
            }
        }).then(generatedUrl => {
            let myWindow = window.open(generatedUrl);

            window.setTimeout(function(){
                myWindow.close();
            }, 8000);
            
        });
    }
}