/**
* ===============================================================================================
*   Version     Date              Comment
* ===============================================================================================
*   Initial     3-Mar-2017        - Trigger handler to insert Lead records in connected orgs
*   1.1                           - Code review changes
*/
public with sharing class LeadS2SHandler {

    public static final String STR_EXABLOX_CONNECTION = Label.Exablox_Connection_Name;
    public static final String STR_AU_CONNECTION = Label.AU_Connection_Name;
    public static final String STR_REGION_VALUE = Label.Lead_Region_Value;
    public static final String STR_PRODUCT_INTRESTED_VALUE = Label.Lead_Product_Interested_Value;

    public void insertedLeads(Map<ID,Lead> newLeadMap){
        // Define connection id
        Id networkId1 = ConnectionHelper.getConnectionId(STR_EXABLOX_CONNECTION);
        Id networkId2 = ConnectionHelper.getConnectionId(STR_AU_CONNECTION);

        // only share records created in this org, do not add leads received from another org.
        List<Lead> localAPACRegionLeads = new List<Lead>();
        List<Lead> localProductInterestExabloxLeads = new List<Lead>();
        for (Lead keyLead: newLeadMap.values()) {
            if (keyLead.ConnectionReceivedId == null && String.isNotBlank(keyLead.Region__c) && keyLead.Region__c.equalsIgnoreCase(STR_REGION_VALUE)) { // Hardcoding
                localAPACRegionLeads.add(keyLead);
            }
            if (keyLead.ConnectionReceivedId == null && String.isNotBlank(keyLead.Product_interested_in__c) && keyLead.Product_interested_in__c.containsIgnoreCase(STR_PRODUCT_INTRESTED_VALUE)){
                localProductInterestExabloxLeads.add(keyLead);
            }
        }

        List<PartnerNetworkRecordConnection> leadConnections =  new  List<PartnerNetworkRecordConnection>();

        if (!localAPACRegionLeads.isEmpty()) {
            for (Lead keyLead : localAPACRegionLeads) {
                leadConnections.add(new PartnerNetworkRecordConnection(
                    ConnectionId = networkId2,
                    LocalRecordId = keyLead.Id,
                    SendClosedTasks = true,
                    SendOpenTasks = true,
                    SendEmails = false
                ));
              }
          }

          if(!localProductInterestExabloxLeads.isEmpty()){
              for (Lead keyLead : localProductInterestExabloxLeads) {
                  leadConnections.add(new PartnerNetworkRecordConnection(
                      ConnectionId = networkId1,
                      LocalRecordId = keyLead.Id,
                      SendClosedTasks = true,
                      SendOpenTasks = true,
                      SendEmails = false
                ));
            }
        }
        if (!leadConnections.isEmpty() ) {
            try{
                insert leadConnections;
            }
            catch(DmlException e) {
                // @Developer : Add Error Handling Logic Here.
            }
        }
  }
}