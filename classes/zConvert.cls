public class zConvert
{
 /* The Initial Developer of the Original Code is Sam Arjmandi.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved. 
 * 
 * This Code is provided "As Is" without warranty of any kind.
 */
 
  public static String ToString(integer Value)
  {
      if(Value == null)
        return '';
      /* string representation if an Integer value */
      return Value.format();
  }
 
  public static String ToString(Double Value)
  {
     if(Value == null)
        return '';
    /* string representation if a Double value */
     return Value.format();
  }
 
  public static String ToString(Boolean Value)
  {
     /* string representation if a Boolean value */
     if (Value)
       return 'true';
     else
       return 'false';
  }
 
  public static String ToString(Long Value)
  {
     if(Value == null)
        return '';
    /* string representation if a Long value */
    return Value.format();
  }
 
  public static String ToString(Date Value)
  {
     if(Value == null)
        return '';
     /* string representation if a Date value */
     return Value.format();
  }
 
  public static String ToString(Date Value,String format)
  {
     if(Value == null)
        return '';
    /* string representation if a Date value with formatting */
    Datetime temp = Datetime.newInstance(Value.year(), Value.month(), Value.day());
    return temp.format(format);
  }
 
  public static String ToString(Datetime Value)
  {
      if(Value == null)
        return '';
     /* string representation if a Datetime value */
     return Value.format();
  }
 
  public static String ToString(Datetime Value,String format)
  {
      if(Value == null)
        return '';
     /* string representation if a Datetime value with formatting */
     return Value.format(format);
  }
 
  public static String ToString(Time Value)
  {
     if(Value == null)
        return '';
    /* string representation if a Time value */
    return String.valueOf(Value);
  }
 
  public static String ToString(Time Value, String format)
  {
     if(Value == null)
        return '';
    /* string representation if a Time value with formating */
    Datetime temp = Datetime.newInstance(1970, 1, 1, Value.hour(), Value.minute(), Value.second());
    return temp.format(format);
  }

  public static String ToString(Decimal Value)
  {
    if(Value == null)
      return '';
      
    /* string representation if a Decimal value */
    return Value.format();
  }
 
  public static String ToString(Decimal Value, Boolean ScientificNotation)
  {
     if(Value == null)
        return '';
    /* string representation if a Decimal value with or without Scientific Notation */
    if (ScientificNotation)
     return Value.format();
    else
     return Value.toPlainString();
  }
 
  public static String FileSizeToString(Long Value)
  {
     if(Value == null)
        return '';
     /* string representation if a file's size, such as 2 KB, 4.1 MB, etc */
     if (Value < 1024)
       return ToString(Value) + ' Bytes';
     else
     if (Value >= 1024 && Value < (1024*1024))
     {
       //KB
       Decimal kb = Decimal.valueOf(Value);
       kb = kb.divide(1024,2);
       return ToString(kb) + ' KB';
     }
     else
     if (Value >= (1024*1024) && Value < (1024*1024*1024))
     {
       //MB
       Decimal mb = Decimal.valueOf(Value);
       mb = mb.divide((1024*1024),2);
       return ToString(mb) + ' MB';
     }
     else
     {
       //GB
       Decimal gb = Decimal.valueOf(Value);
       gb = gb.divide((1024*1024*1024),2);
      
       return ToString(gb) + ' GB';
     }
    
  }
 
  public static String CurrencyToString(Decimal Value, String CurrencyChar)
  {
     if(Value == null)
        return '';
     return CurrencyChar + ToString(Value);
  }
 
   //=====================================================================================//
   //Test code for coverage
   //====================================================================================//
   @isTest
   private static void Test_AllConversions() {
     zConvert.ToString(true);
     zConvert.ToString(false);
     
     zConvert.ToString(5);
     Integer i = null;
     zConvert.ToString(i);
     
     zConvert.ToString(6.90d);
     Double d = null;
     zConvert.ToString(d);
     
     Date dt = null;
     zConvert.ToString(dt);
     
     DateTime dtTime = null;
     zConvert.ToString(dtTime);
     
     Long l = null;
     zConvert.ToString(l);
     zConvert.FileSizeToString(l);
     
     Decimal deci = null;
     zConvert.ToString(deci);
     zConvert.ToString(deci,true);
     zConvert.CurrencyToString(deci, '$');
     
     zConvert.ToString(System.today());
     zConvert.ToString(System.now());
     zConvert.ToString(System.now(),'dd/MM/yyyy');
     
     zConvert.ToString(System.today(),'dd/MM/yyyy');
     zConvert.ToString(dt,'dd/MM/yyyy');
     zConvert.ToString(dtTime,'dd/MM/yyyy');
     zConvert.ToString(System.now().time());
     
     Time zTime = null;
     zConvert.ToString(zTime);
     zConvert.ToString(zTime,'dd/MM/yyyy');
     
     zConvert.ToString(System.now().time(),'dd/MM/yyyy');
     
     zConvert.ToString(100.90);
     zConvert.ToString(100L);
     zConvert.CurrencyToString(90.9033, '$');
     zConvert.FileSizeToString(890L);
     zConvert.FileSizeToString(89000L);
     zConvert.FileSizeToString(8900001L);
     zConvert.FileSizeToString(1024*1024*1024 * 2L);
     zConvert.ToString(100.90,true);
     zConvert.ToString(100.90,false);
   }
}