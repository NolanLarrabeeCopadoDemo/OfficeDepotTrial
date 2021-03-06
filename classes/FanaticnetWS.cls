//Generated by wsdl2apex

public class FanaticnetWS {
    public class DispatchSaveOperationResponse_element {
        public String DispatchSaveOperationResult;
        public String Status;
        public String ErrorMessage;
        private String[] DispatchSaveOperationResult_type_info = new String[]{'DispatchSaveOperationResult','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] ErrorMessage_type_info = new String[]{'ErrorMessage','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'DispatchSaveOperationResult','Status','ErrorMessage'};
    }
    public class FanaticOperation {
        public String OperationName;
        public String OperationKey;
        public String OperationKeyType;
        public String DataType;
        private String[] OperationName_type_info = new String[]{'OperationName','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] OperationKey_type_info = new String[]{'OperationKey','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] OperationKeyType_type_info = new String[]{'OperationKeyType','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] DataType_type_info = new String[]{'DataType','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'OperationName','OperationKey','OperationKeyType','DataType'};
    }
    public class FanaticOperationResultTransport {
        public String OperationName;
        public String OpResult;
        public String OperationKey;
        public String OperationKeyType;
        public String DataType;
        public String ResultDS;
        public String CompressedData;
        public Boolean ReadFromCache;
        public Boolean Cacheable;
        public FanaticnetWS.ArrayOfString CacheOpToInvalidate;
        private String[] OperationName_type_info = new String[]{'OperationName','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] OpResult_type_info = new String[]{'OpResult','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] OperationKey_type_info = new String[]{'OperationKey','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] OperationKeyType_type_info = new String[]{'OperationKeyType','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] DataType_type_info = new String[]{'DataType','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] ResultDS_type_info = new String[]{'ResultDS','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] CompressedData_type_info = new String[]{'CompressedData','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] ReadFromCache_type_info = new String[]{'ReadFromCache','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] Cacheable_type_info = new String[]{'Cacheable','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] CacheOpToInvalidate_type_info = new String[]{'CacheOpToInvalidate','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'OperationName','OpResult','OperationKey','OperationKeyType','DataType','ResultDS','CompressedData','ReadFromCache','Cacheable','CacheOpToInvalidate'};
    }
    public class DispatchLoadOperation_element {
        public FanaticnetWS.FanaticOperationList OpList;
        private String[] OpList_type_info = new String[]{'OpList','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'OpList'};
    }
    public class ArrayOfFanaticOperationResultTransport {
        public FanaticnetWS.FanaticOperationResultTransport[] FanaticOperationResultTransport;
        private String[] FanaticOperationResultTransport_type_info = new String[]{'FanaticOperationResultTransport','http://www.techdepot.com/FanaticNet/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'FanaticOperationResultTransport'};
    }
    public class FanaticSaveOperationList {
        public FanaticnetWS.ArrayOfString SaveOperations;
        public String InputDS;
        public String SerializedDS;
        private String[] SaveOperations_type_info = new String[]{'SaveOperations','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] InputDS_type_info = new String[]{'InputDS','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] SerializedDS_type_info = new String[]{'SerializedDS','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'SaveOperations','InputDS','SerializedDS'};
    }
    public class FanaticBaseOperationList {
        public String ModuleName;
        public String Guid;
        public String OperationType;
        public String ServResult;
        public Boolean Compressed;
        private String[] ModuleName_type_info = new String[]{'ModuleName','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] Guid_type_info = new String[]{'Guid','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] OperationType_type_info = new String[]{'OperationType','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] ServResult_type_info = new String[]{'ServResult','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] Compressed_type_info = new String[]{'Compressed','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'ModuleName','Guid','OperationType','ServResult','Compressed'};
    }
    public class FanaticOperationList {
         /* Added by me*/
        public String ModuleName;
        public String Guid;
        public String OperationType;
        public String ServResult;
        public Boolean Compressed;
        private String[] ModuleName_type_info = new String[]{'ModuleName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Guid_type_info = new String[]{'Guid','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OperationType_type_info = new String[]{'OperationType','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] ServResult_type_info = new String[]{'ServResult','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Compressed_type_info = new String[]{'Compressed','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] field_order_type_info = new String[]{'ModuleName','Guid','OperationType','ServResult','Compressed','OperationList'};
  /* end Added by me*/
        public FanaticnetWS.ArrayOfFanaticOperation OperationList;
        private String[] OperationList_type_info = new String[]{'OperationList','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
          /* Added by me*/
       // private String[] field_order_type_info = new String[]{'OperationList'};
         /* end Added by me*/
    }
    public class DispatchSaveOperation_element {
        public FanaticnetWS.FanaticSaveOperationList Oplist;
        private String[] Oplist_type_info = new String[]{'Oplist','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'Oplist'};
    }
    public class ArrayOfString {
        public String[] string_x;
        private String[] string_x_type_info = new String[]{'string','http://www.techdepot.com/FanaticNet/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'string_x'};
    }
    public class ArrayOfFanaticOperation {
        public FanaticnetWS.FanaticOperation[] FanaticOperation;
        private String[] FanaticOperation_type_info = new String[]{'FanaticOperation','http://www.techdepot.com/FanaticNet/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'FanaticOperation'};
    }
    public class DispatchLoadOperationResponse_element {
        public String DispatchLoadOperationResult;
        public String Status;
        public String ErrorMessage;
        private String[] DispatchLoadOperationResult_type_info = new String[]{'DispatchLoadOperationResult','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] ErrorMessage_type_info = new String[]{'ErrorMessage','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'DispatchLoadOperationResult','Status','ErrorMessage'};
    }
    public class FanaticOperationResultsTransport {
        public String Guid;
        public String ModuleName;
        public String ServResult;
        public String OperationType;
        public FanaticnetWS.ArrayOfFanaticOperationResultTransport Results;
        public Boolean Compressed;
        private String[] Guid_type_info = new String[]{'Guid','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] ModuleName_type_info = new String[]{'ModuleName','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] ServResult_type_info = new String[]{'ServResult','http://www.techdepot.com/FanaticNet/',null,'1','1','false'};
        private String[] OperationType_type_info = new String[]{'OperationType','http://www.techdepot.com/FanaticNet/',null,'1','1','false'};
        private String[] Results_type_info = new String[]{'Results','http://www.techdepot.com/FanaticNet/',null,'0','1','false'};
        private String[] Compressed_type_info = new String[]{'Compressed','http://www.techdepot.com/FanaticNet/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.techdepot.com/FanaticNet/','true','false'};
        private String[] field_order_type_info = new String[]{'Guid','ModuleName','ServResult','OperationType','Results','Compressed'};
    }
}