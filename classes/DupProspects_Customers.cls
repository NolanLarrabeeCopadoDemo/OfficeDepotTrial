/******************************************************************
*Apex Class :DupProspects_Customers
*Created By : Wipro Offshore(25 July)
*Purpose : Displaying Duplicate Customers and Prospects in a Page
*******************************************************************/

public with sharing class DupProspects_Customers {    
    Map<string,set<id>> accmapid=new Map<string,set<id>>();
    
    public DupProspects_Customers(ApexPages.StandardController controller) {                                  
        Set<Id> RecTypeId= new Set<Id>(); 
       //RecordType rt= [Select SobjectType, Name, Id From RecordType where SobjectType ='Account'and Name='site'];
       for(RecordType rt:[Select SobjectType, Name, Id From RecordType where SobjectType ='Account'and (Name='site' OR Name='site (OfficeMax)')]){
           RecTypeId.add(rt.Id);    
       }
      List<AggregateResult> Lst_acc=[Select count(id)n,name from Account a where RecordTypeId NOT IN: RecTypeId group by name having count(name)>=2 limit 10000];
      
       system.debug('>>>Account List>>>>>'+Lst_acc);
       for(AggregateResult Lst_acc1:Lst_acc ){
      
               // System.debug(Lst_acc1.get('name')+'-'+Lst_acc1.get('n')+'please check');
                wrapperclass wrap1=new wrapperclass();
                wrap1.name=(string)Lst_acc1.get('name');
                wrap1.count1=(Integer)Lst_acc1.get('n');
                
                wrapperlist.add(wrap1);
            }
              
    }
  
    public class wrapperclass{
        public String name{get; set;}
        public Integer count1{get; set;}
        public wrapperclass(){}
        public wrapperclass(Integer count2,String name1){   
        count2=count1;       
        name = name1; 
            }       
        }
        
     public transient List<wrapperclass> wrapperlist = new List<wrapperclass>();     
     public List<wrapperclass> getwrap(){   
       
         return wrapperlist;    
        }
        
               
     public pageReference cancel(){
     PageReference pageRef = new PageReference('/home/home.jsp');
     return pageRef;
    } 
}