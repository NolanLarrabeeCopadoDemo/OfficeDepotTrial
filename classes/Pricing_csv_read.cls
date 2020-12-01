public class Pricing_csv_read 

{

 public string nameFile{get;set;}

 public Blob contentFile{get;set;}
 public list<st> skus {get;set;}

 public Pricing_csv_read()

 {

 

 }
 public class st {
  public String sval {get;set;}
 }
public Pagereference ReadFile()

{

nameFile=contentFile.toString();

return ApexPages.currentPage();

}

public list<st> getsku() {
list<st> s = new list<st>();
list<String> str = new List<String>();
if(!''.equals(nameFile) && nameFile != null)
str = nameFile.split('\n');
for(String ss:str) {
st sss = new st();
sss.sval = ss;
s.add(sss);
}
return s;
}

}