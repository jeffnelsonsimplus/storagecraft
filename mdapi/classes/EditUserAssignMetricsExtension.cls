public class EditUserAssignMetricsExtension {
	public final User usr;
    public User_Time_Off__c uto {get;set;}
    public EditUserAssignMetricsExtension(ApexPages.StandardController ctrl){
        usr = (User)ctrl.getRecord();
        uto = new User_Time_Off__c(OwnerId = usr.Id);
    }
    
    public PageReference updateUser(){
        PageReference pr = new PageReference(ApexPages.currentPage().getUrl());
        pr.getParameters().clear();
        pr.getParameters().put('id',uto.OwnerId);
        pr.setRedirect(true);
        return pr;
    }
}