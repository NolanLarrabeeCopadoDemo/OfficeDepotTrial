global class TestCommunication{
  
  webservice static String communicate(String testMsg) {
    if (testMsg == '') {
      return '';
    }

    String returnString = '';
    for(Integer i = (testMsg.length()-1); i >= 0; i--){
      returnString += charAt(testMsg,i);
    }
    return returnString;
  }
  
  private static String charAt(String str, Integer index) {
    return str.substring(index, index+1);
  }
}