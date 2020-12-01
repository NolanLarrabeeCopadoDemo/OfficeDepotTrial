public class FormatString{
public static String preZeroFormat(String input,integer length)
{
    //Convert str=231 to 000231 if length=6
    String str = input;
    Integer len = str.length();
    if((len < length)&&(len>0))
    {
    String newstr=str.reverse();
            for(Integer i=len;i<6;i++) {
            newstr=newstr+'0';
            }
    str=newstr.reverse();
    }

    system.debug('@@@###*** - '+str);
    return str;
}

public static String postZeroFormat(String input,integer length)
{
    //Convert str=231 to 231000 if length=6
    String str = input;
    Integer len = str.length();
    if((len < length)&&(len>0))
    {
            for(Integer i=len;i<6;i++) {
            str=str+'0';
            }
    }
    system.debug('@@@###*** - '+str);
    return str;
}
}