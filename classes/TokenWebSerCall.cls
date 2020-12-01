global class TokenWebSerCall {
    webservice static TokenWebSerCallResponse methodCall(TokenWebSerCallInput ip){
    
          
            TokenWebSerCallResponse resp=new TokenWebSerCallResponse();
            system.debug('eid' +ip.EmpId );
            system.debug('Tid' +ip.Token );
       List<User> usrList=[Select Manager.name,Manager.OD_Employee_ID__c,Manager.Email,Email,MB_Expiration_Date__c,Name,Region__c,Market__c,District__c,Division,OD_Employee_ID__c,Token_Market_Builder__c,Market_Builder_Role__c,Origanaly_Setup_in__c  from User where  OD_Employee_ID__c=:ip.EmpId];
       System.Debug('usr'+usrList);
        for(User u:usrList){
            if((u.Token_Market_Builder__c == ip.Token)  &&  (System.now() <= u.MB_Expiration_Date__c)){
                 system.debug('Inside' +u.Name );
                resp.Emp_Id = u.OD_Employee_ID__c ;
                resp.MANAGER = u.Manager.name;
                resp.Name = u.Name;
                List<String> str=u.Name.split(' ');  
                resp.Emp_F_Name= str[0];
                resp.Emp_L_Name =str[1];
                resp.Emp_Email = u.Email;
                resp.UserRole = u.Market_Builder_Role__c;
                resp.Company = u.Origanaly_Setup_in__c;
                if(u.Manager.name != null && u.Manager.name !=''){
                    List<String> mngrStr = u.Manager.name.split(' ');
                    resp.Mngr_F_Name = MngrStr[0];
                    resp.Mngr_L_Name = MngrStr[1];
                    resp.Division =u.Division ;           
                    resp.District=u.District__c;
                    resp.Market=u.Market__C;
                    resp.Region= u.Region__C;
                    resp.Manager_Email = u.Manager.Email;
                    resp.ManagerEmpid= u.Manager.OD_Employee_ID__c ;
                }               
            }else
            {
                resp.Emp_Id = '' ;
                resp.MANAGER ='';
                resp.Name = '';  
                resp.ManagerEmpid= '' ;              
            }
       
        }
        if(resp.Emp_Id =='' || resp.Emp_Id== NULL)  {
            resp.status='Failure...';
            
        }
        else{
            resp.status='success';     
        }
        System.Debug('response check'+resp);     
        return resp;
    
    }
    
    global class TokenWebSerCallInput{
    
        Webservice String Token;
        Webservice String EmpId;
    }   
    global class TokenWebSerCallResponse{
        Webservice String Emp_Id;
        Webservice String Name;
        Webservice String Emp_F_Name;
        Webservice String Emp_L_Name;
        Webservice String Emp_Email; 
        Webservice String Division;
        Webservice String District;       
        WebService String Manager;
        Webservice String Market;
        Webservice String Region;        
        Webservice String Mngr_F_Name;
        Webservice String Mngr_L_Name;
        WebService String ManagerEmpid;
        Webservice String Manager_Email; 
        webservice String Status;
        webservice String ErrorMessage;
        WebService String UserRole;
        Webservice String Company;
        
    
    }
}