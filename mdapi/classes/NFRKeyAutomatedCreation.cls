public class NFRKeyAutomatedCreation implements Queueable, Database.AllowsCallouts {

    public static List<License__c> newLicenseList = new List<License__c>();
    public static List<String> types = new List<String>();
    public List<String> params;
    public NFRKeyAutomatedCreation(List<String> param){
      this.params = param;
    }

    public void execute(QueueableContext context) {
      createNewKeys(params);
    }

    @InvocableMethod(label='Create New Keys')
    public static void invokeAutomatedKeys(List<String> param){
      System.enqueueJob(new NFRKeyAutomatedCreation(param));
    }

    public static void createNewKeys(List<String> param)
    {
      map<id,string> accountsToLanguageMap = new map<id,string>();
    	for(string p:param){
        list<string> thisList = p.split(';', -2);
        accountsToLanguageMap.put(thisList[0],thisList[1]);
      }
      Schema.DescribeFieldResult fieldResult = license__c.type__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      list<account> accounts = [Select Name,Id,NFR_ShadowProtect_Server_Serial__c, NFR_ShadowProtect_Desktop_Serial__c, NFR_ShadowProtect_SPX_Linux__c, NFR_ShadowProtect_ImageManager_Serial__c From Account where id in : accountsToLanguageMap.keySet()];
      list<license__c> ls = new list<license__c>();
      for(account a: accounts){
        for( Schema.PicklistEntry f : ple){
          boolean isLinux = false;
          if(f.getLabel() == 'SPX Linux'){
            isLinux = true;
          }
          NFRKeyCallout callout = new NFRKeyCallout();
          string thisResponse = callout.makeCall('New','None',Date.today().addMonths(12),languageNumFromName(accountsToLanguageMap.get(a.id)),getTypeNum(f.getLabel()),isLinux,a.id,accountsToLanguageMap.get(a.id),f.getLabel());
          if(thisResponse !='Failure'){
            License__c l = new License__c();
            l.Name = thisResponse;
            l.Origin__c = 'User';
            l.Expiration__c = Date.today().addMonths(12);
            l.Language__c = accountsToLanguageMap.get(a.id);
            l.Type__c = f.getLabel();
            l.Linux__c = Islinux;
            l.Class__c = 'NFR';
            l.Activation__c = Date.today();
            l.Status__c = 'Active';
            l.Account__c = a.id;
            ls.add(l);
            if(f.getLabel() == 'Desktop'){
              a.NFR_ShadowProtect_Desktop_Serial__c = thisResponse;
            }
            if(f.getLabel() == 'SPX Linux'){
              a.NFR_ShadowProtect_SPX_Linux__c = thisResponse;
            }
            if(f.getLabel() == 'Image Manager'){
              a.NFR_ShadowProtect_ImageManager_Serial__c = thisResponse;
            }
            if(f.getLabel() == 'Server'){
              a.NFR_ShadowProtect_Server_Serial__c = thisResponse;
            }
          }
        }
      }
      if(ls != null && ls.size() > 0){
        insert ls;
      }
      update accounts;
    }
   public static Integer getTypeNum(String typeName)
    {
        //system.debug('in getTypeNum(): typename: '+typeName);
        if(typeName == 'Desktop')return 1;
        if(typeName == 'SPX Linux')return 2;
        if(typeName == 'Image Manager')return 7;
        if(typeName == 'Server')return 2;
        return null;
    }
    public static Integer languageNumFromName(String Lang)
    {
        //system.debug('in languageNumFromName(): Lang :  '+Lang);
        for(Languages__c l : Languages__c.getAll().values())//(name of custom setting  variableName : name of custom setting.getAll().values()
        {
            if(l.Name == lang){//if(variableName. name of setting to check == variableName passed in)
                //system.debug(l.Number__c);
                return (Integer)l.Number__c; // return variablename.setting you want to output;
            }
        }
        return 0;
    }

}