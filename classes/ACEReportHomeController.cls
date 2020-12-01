public class ACEReportHomeController 
{

    public PageReference SearchRecords() {
        return null;
    }
    
    public ACEReportHomeController() 
    {
        getmainnodes();
    }

    public String OwnerValue { get; set; }
    public List<Contact> Root=new List<Contact>();
    /* Wrapper class to contain the nodes and their children */
    public class cNodes
    {
     public String gparent {get; set;}
     Public List<String> parent {get;set;}
     public String URL{get;set;}
    }
    /* end of Wrapper class */ 

    Public List<cNodes> hierarchy;
    public String AccessLevelOps{get;set;}
    public String AccessLevelOpsMargin {get;set;}
    Public List<cNodes> getmainnodes()
     {
             AccessLevelOps = '';
             AccessLevelOpsMargin = '';
             For (Group g : [select id,name from group where name in ('Sales Ops Team')]) 
                 for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()])
                    AccessLevelOps = 'Sales Ops Team';
                
             For (Group g : [select id,name from group where name in ('Sales Ops Margin Team')]) 
                 for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()])
                    AccessLevelOpsMargin = 'Sales Ops Margin Team';
            
           System.debug('>>>>>>>>>>>>>>>>AccessLevelOps >>' + AccessLevelOps );
            
         	List<String> lValues = new List<String>{'Revenue Reporting','Exception Reporting','Customer Notification Reporting','Remediation Reporting','Hosted Catalog Reporting','Vendavo Dashboard Reporting','Customers Not Receiving Full Increase'};//910713 - hiding PipeLine Reporting
            //List<String> lValues = new List<String>{'Revenue & Margin Reporting','Exception Reporting','Customer Notification Reporting','Remediation Reporting','Hosted Catalog Reporting','Vendavo Dashboard Reporting','PipeLine Reporting','Customers Not Receiving Full Increase'};//910713 - removed 'Customer Response Reporting'
            
            //List<String> lValues = new List<String>{'Exception Reporting','Customer Notification Reporting','Remediation Reporting','Hosted Catalog Reporting','Vendavo Dashboard Reporting','Process Progress/PipeLine Reporting','Customers Not Receiving Full Increase'};//sfdc-910706, 910713 -- Removed 'Customer Response Reporting'
            List<String> sString = new List<String>();
            
            for(String s : lValues)
            {
                     sString.add(s);
            }
            if(AccessLevelOps == 'Sales Ops Team')
                 sString.add('Change Type Reporting');   
            hierarchy = new List<cNodes>();
            for(String s : sString)
            {
                CnOdes  c1 = new CNodes();
                c1.gparent = s;
                if((s == 'Revenue Reporting'))
                        //c1.parent = new List<String>{'Overview','Region','Sector','By Participation', 'By Industry'};//910703, 910701,861332
                        c1.parent = new List<String>{'Summary','Summary by Region','Summary by Sector/Segment','Summary by Participation (Buying Group/GPO)', 'Summary by Industry/Vertical Market'};//910703, 910701
                else if((s == 'Exception Reporting'))
                        c1.parent = new List<String>{'Exception Report'};
                else if((s == 'Remediation Reporting'))
                        c1.parent = new List<String>{'Remediation Report'};
                else if((s == 'Hosted Catalog Reporting'))
                        c1.parent = new List<String>{'Hosted Catalog Report'};        
                else if((s == 'Customer Notification Reporting'))
                        c1.parent = new List<String>{'Customer Notification Report','Customer Approval Report','Compliance Summary Report'};//sfdc sfdc 00910704,00910706,00910713 
                //else if((s == 'Customer Response Reporting'))//sfdc 00910706,00910713
                   //     c1.parent = new List<String>{'Response','Compliance'};//sfdc 00910706,00910713  
                else if((s == 'Change Type Reporting'))
                        c1.parent = new List<String>{'Change Type'}; 
                else if((s == 'PipeLine Reporting'))
                        c1.parent = new List<String>{'PipeLine Report'}; 
                else if((s == 'Customers Not Receiving Full Increase'))
                        c1.parent = new List<String>{'Customers Not Receiving Full Increase'}; 
                else if((s== 'Vendavo Dashboard Reporting'))
                        c1.parent = new List<String>{'Vendavo Dashboard Report'}; 
                        
                hierarchy.add(c1);
            }
            return hierarchy;
    }   
}