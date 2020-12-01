public  class OppReAssignCtrl {

    
    Public String OppId {get;set;} 
    public Opportunity opp {get;set;}
    Public String Selected{get;set;}
    Public Boolean SelOwner{get;set;}
    Public Boolean SelType{get;set;}
    Public Boolean ATMOwner{get;set;}
    Public String OppAccId{get;set;}
    Public String Title{get;set;}
    Public String InputValue{get;set;}
    public String InputName{get;set;}
    Public Boolean AutoAssign{get;set;}
    Public String chk {get;set;}
    Public List<Admin_Config__c> tech=new List<Admin_Config__c>();
    public List<sWrapper> wrprLst{get;set;}
    Boolean chkBx=false;
    Public User u = new User();
    Public List<user> TeamMembrLst{get;set;}
    Public List<User> UsrLst{get;set;} 
    public String Auto_Assign_User{get;set;}
    Set<String> TitleSet= new Set<String>();
    public String setOpp(){
    
        return null;
    }
    public String getOpp(){
        return null;
    }
    
    Opportunity op1 = new Opportunity();

    public OppReAssignCtrl(ApexPages.StandardController controller) {
        SelType = true;
        SelOwner = false;
        opp = new Opportunity();
        chk='jasmeet';
        //op1 = (opportunity)controller.getRecord();
        op1 = [Select Id,AccountId from Opportunity where Id =: ApexPages.CurrentPage().getparameters().get('id')];
        System.Debug('record'+ op1);
        System.Debug('Id'+ApexPages.CurrentPage().getparameters().get('id'));
        System.Debug('Id2'+controller.getId());
        tech = [Select Id,Tech_Depot_Title__c,Tech_Depot_Auto_Assign_Opp__c,Tech_Depot_User__c from Admin_Config__c where name ='Default'];
        if((tech.size() >0)){
            for(String s:tech[0].Tech_Depot_Title__c.split(',')){
                TitleSet.add(s);
            }
            System.Debug('Title check'+TitleSet);
            UsrLst= [Select Id,short_title__c, name from user where Short_Title__c IN: TitleSet AND Id IN (Select UserId from AccountTeamMember where AccountId =: op1.AccountId )]; 
            u= [Select Id,name from user where name =: tech[0].Tech_Depot_User__c limit 1];
            System.Debug('default'+u);
        }
    }
   /* public void OppReAssignCtrl(){
        //if(opp.OwnerId !=null && opp.OwnerId != ''){
            //op1.OwnerId = opp.OwnerId; 
            //setOpporId();
            op1.OwnerId = opp.OwnerId;
            Update op1;
        //}   
        
    }
    public OppReAssignCtrl() {
    
        //usr = new User();

    }*/
    public List<selectOption> getaccts() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('none', '- None -')); 
        options.add(new selectOption('Auto', 'Auto Assign'));
        options.add(new selectOption('ATMUsers', 'Team Members'));
        options.add(new selectOption('AllUsers', 'All Users'));
        
        return options;
    }
    
    public void CheckSelection(){
        If(Selected == 'none'){
            SelType = true;
            SelOwner = false ;
            ATMOwner= false;
            AutoAssign =false;
            
        //OppId = System.currentPageReference().getParameters().get('OppId');
       // System.Debug('chek opp'+OppId);
        }
        If(Selected == 'AllUsers'){
            SelType = false;
            SelOwner = true ;
            ATMOwner= false;
            AutoAssign =false;
            
        //OppId = System.currentPageReference().getParameters().get('OppId');
       // System.Debug('chek opp'+OppId);
        }
        if(selected == 'ATMUSers'){
            SelType = false;
            SelOwner = false ; 
            ATMOwner= true;
            AutoAssign =false;
            //OppAccId = Op1.AccountId;
            System.Debug('+++'+ op1);     
            Title = tech[0].Tech_Depot_Title__c;  
            TeamMembers();     
            
           
        }
        if(Selected == 'Auto'){
            SelType = false;
            SelOwner =false ;
            ATMOwner= false; 
            AutoAssign =True;   
            if(usrLst.size() >0){
                Auto_Assign_User ='Auto Assign To: '+ usrLst[0].name;
                System.Debug('chk'+usrLst[0].name);
            }    
            else{
                Auto_Assign_User = 'Auto Assign To: '+u.name;
                System.Debug('chk2'+u.name);
            }          
            System.Debug('chk2'+Auto_Assign_User);
        }
    
    }
    public pagereference UpdateOwner(){
        if(String.valueOf(Opp.OwnerId) ==null || String.ValueOf(Opp.OwnerId) == ''){
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Opportunity Owner:You must enter a value');
            ApexPages.addMessage(message);
        }
        System.Debug('chek opp'+Opp.OwnerId);
        if(Opp.OwnerId != null){  
            op1.OwnerId = Opp.OwnerId;
            Update op1;
        }    
            Pagereference pagref = new pagereference('/'+op1.Id);
            return pagref;
        
    }
    Public pagereference UpdateATMOwner(){
       //if(InputName == null || InputName == ''){\
        System.Debug('entered'+inputValue);
       Integer count=0;
       String SelectedId='';
       for(sWrapper w:wrprLst){
           if(w.chek==true){
               count +=1;
               SelectedId=w.us.Id;
           }    
       }
       if(count != 1){
           ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Please Select single value');
           ApexPages.addMessage(message);
           return null;
       }
      
       else{
           op1.OwnerId = SelectedId;
           Update op1;
           System.Debug('Ownr'+ op1.OwnerId);
       }    
           Pagereference pagref2 = new pagereference('/'+op1.Id);
           return pagref2;
       
    }
    Public pagereference AutoAsgn(){
    
           //List<TechDepotsetting__c> tech = [Select Id,User_Title__c,Auto_Assign__c,default_User__c from TechDepotSetting__c where name ='Title & Auto Assign'];
          // List<User> UsrLst= [Select Id,short_title__c, name from user where Short_Title__c =: tech[0].Tech_Depot_Title__c AND Id IN (Select UserId from AccountTeamMember where AccountId =: op1.AccountId )]; 
           if(UsrLst.size() > 0 && tech[0].Tech_Depot_Auto_Assign_Opp__c == true){
               op1.OwnerId =UsrLst[0].Id;
               Update op1;
           }           
           
           else{
               //User u= [Select Id from user where name =: tech[0].Tech_Depot_User__c limit 1];
               op1.OwnerId = u.Id;
               Update op1;
           }           
           Pagereference pagref = new pagereference('/'+op1.Id);
           return pagref;    
    }
    Public Pagereference cancleButn(){
        Pagereference pagref = new pagereference('/'+op1.Id);
        return pagref;
    }
    public class sWrapper{
        public User us{get;set;}
        public Boolean Chek{get;set;}
        
        public sWrapper(User u,Boolean b){
         this.Us = u;
         this.Chek = b;    
        
        }
    }
    public void TeamMembers(){
        wrprLst = new List<sWrapper>();
        System.Debug('Title check2'+TitleSet);
        
        //for(User u: [Select Id,Name,IsActive,Short_title__c from User where short_title__c IN: TitleSet AND  Id IN (Select UserId from AccountTeamMember where AccountId =:op1.AccountId) AND IsActive=true]){
          for(User u: [Select Id,Name,IsActive,Short_title__c from User where Id IN (Select UserId from AccountTeamMember where AccountId =:op1.AccountId) AND IsActive=true]){
            wrprLst.add(new sWrapper(u,Chkbx));
        }  
    }
    
   
    
    

}