public class LiveSerialInfoExt {
    public final Case c;
    public String liveDetails {get;set;}
    public String storedDetails {get;set;}
    public Boolean shouldRefresh {get;set;}
    public String redirectUrl {get;set;}
    public LiveSerialInfoExt(ApexPages.StandardController ctrl){
        liveDetails = '';
        storedDetails = '';
        c = (Case)ctrl.getRecord();
        if(c.Serial_Number__c == null)
            return;

        liveDetails = formatText(SerialNumberSupportInfo.getSNInfo(c.Serial_Number__c));
        storedDetails = formatText(c.Serial_Number_Details__c);
        
    }
    
    private String formatText(String text){
        if(text == null)
            return text;
        return text.trim().replaceAll('\n','<br/>');
    }
}