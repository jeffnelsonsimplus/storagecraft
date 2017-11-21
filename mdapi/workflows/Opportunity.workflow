<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deal_Registration_DMR</fullName>
        <description>Deal Registration: DMR</description>
        <protected>false</protected>
        <recipients>
            <recipient>suzanne.arnold@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales/Deal_Registration_DMR</template>
    </alerts>
    <alerts>
        <fullName>Deal_Registration_Lifeboat</fullName>
        <ccEmails>storagecraft@lifeboatdistribution.com</ccEmails>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <description>Deal Registration Lifeboat</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Workflow_Internal_Opp_Deal_Registration_Synnex</template>
    </alerts>
    <alerts>
        <fullName>Deal_Registration_Synnex_CA</fullName>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <ccEmails>lucg@synnex.com</ccEmails>
        <description>Deal Registration Synnex - CA</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Workflow_Internal_Opp_Deal_Registration_Synnex</template>
    </alerts>
    <alerts>
        <fullName>Deal_Registration_Synnex_US</fullName>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <ccEmails>StorageCraft@synnex.com</ccEmails>
        <description>Deal Registration Synnex - US</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Workflow_Internal_Opp_Deal_Registration_Synnex</template>
    </alerts>
    <alerts>
        <fullName>Deal_Registration_Tech_Data</fullName>
        <ccEmails>tracy.beyer@techdata.com</ccEmails>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <description>Deal Registration Tech Data</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Workflow_Internal_Opp_Deal_Registration_Synnex</template>
    </alerts>
    <alerts>
        <fullName>Deal_Registration_Unknown_Distributor</fullName>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <description>Deal Registration Unknown Distributor</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Workflow_Internal_Opp_Deal_Registration_Unknown_Distributor</template>
    </alerts>
    <alerts>
        <fullName>Deal_Registration_has_created_new_Opportunity</fullName>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <description>Deal Registration has created new Opportunity</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Deal_Registration_has_created_new_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Distributor_equals_D_H_Distributing</fullName>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <ccEmails>licensedesk@dandh.com</ccEmails>
        <description>Distributor equals D&amp;H Distributing</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Workflow_Internal_Opp_Deal_Registration_Synnex</template>
    </alerts>
    <alerts>
        <fullName>Email_may_not_be_sent_to_partner</fullName>
        <description>Email may not be sent to partner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_Confirmation_to_Partner_Failed</template>
    </alerts>
    <alerts>
        <fullName>Escalation_to_VP</fullName>
        <description>Escalation to VP</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfdc+storagecraft@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <alerts>
        <fullName>Tier_Deal_Registration_Approval</fullName>
        <ccEmails>loch.macleod@storagecraft.com</ccEmails>
        <description>Alert Partner Contact of Tier Deal Registration Approval</description>
        <protected>false</protected>
        <recipients>
            <field>DealRegistrationSubmittingPartner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Workflow_External_Opp_Tier_Deal_Registration_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>End_User_Company</fullName>
        <field>DealCompany__c</field>
        <formula>Account.Name</formula>
        <name>End User Company</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expiration_Date</fullName>
        <field>DealExpiration__c</field>
        <formula>now()+60</formula>
        <name>Expiration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OpportunitySetAmount</fullName>
        <field>Amount</field>
        <formula>EstRevenue__c</formula>
        <name>Opportunity | Set Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Set_Est_Close</fullName>
        <field>CloseDate</field>
        <formula>EstCloseDate__c</formula>
        <name>Opportunity | Set Est Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Partner_Status</fullName>
        <description>Updates to Onboarding Complete</description>
        <field>PartnerStatus__c</field>
        <literalValue>Onboarding Complete</literalValue>
        <name>Update Account Partner Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity DMR</fullName>
        <actions>
            <name>Deal_Registration_DMR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.AccountUserType__c</field>
            <operation>equals</operation>
            <value>Direct Market Reseller (DMR)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Won,Closed Lost,--cancelled--,--duplicate--</value>
        </criteriaItems>
        <description>Send emails when DMR Deal Registration changes</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Approved Deal Reg</fullName>
        <actions>
            <name>Expiration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(
  $Setup.AutomationController__c.ExecuteOpportunityAutomation__c,
  or(
    isnew(),
    ischanged(LeadSource),
    ischanged(DealRegistrationNumber__c )
  ),
  ispickval(LeadSource,&quot;Deal Registration&quot;),
  NOT(
    ISBLANK(DealRegistrationNumber__c )
  )  
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Escalation for VP</fullName>
        <actions>
            <name>Escalation_to_VP</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Checklist on opportunity to send escalation email to VP</description>
        <formula>AND(
  $Setup.AutomationController__c.ExecuteOpportunityAutomation__c,
  ischanged(Needs_Escalation__c ),
  Needs_Escalation__c
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Amount</fullName>
        <actions>
            <name>OpportunitySetAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(
  $Setup.AutomationController__c.ExecuteOpportunityAutomation__c,
  or(
    ischanged(EstRevenue__c),
    isnew()
  ),
  NOT(ISNULL(EstRevenue__c))  
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Est Close</fullName>
        <actions>
            <name>Opportunity_Set_Est_Close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(
  $Setup.AutomationController__c.ExecuteOpportunityAutomation__c,
  or(
    ischanged(EstCloseDate__c),
    isnew()
  ),
  NOT(ISNULL(EstCloseDate__c))  
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Update Account Partner Status</fullName>
        <actions>
            <name>Update_Account_Partner_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,Closed/Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Data_Migration_Source__c</field>
            <operation>notContain</operation>
            <value>AU</value>
        </criteriaItems>
        <description>Updates to Onboarding Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Deal_Registration_is_pending_your_review</fullName>
        <assignedToType>owner</assignedToType>
        <description>Deal Registration is pending your review
Regarding: Opportunity
Category: Deal Registration</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Deal Registration is pending your review</subject>
    </tasks>
</Workflow>
