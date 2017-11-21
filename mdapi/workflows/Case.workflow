<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_EU_Support_Management_of_Sensitive_Case</fullName>
        <ccEmails>temperance.penrod@storagecraft.com, kevin.steele@storagecraft.com</ccEmails>
        <description>Alert EU Support Management of Sensitive Case</description>
        <protected>false</protected>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Sensitive_Account_Alert_for_Support_Mgmt</template>
    </alerts>
    <alerts>
        <fullName>Alert_Leadership_of_Unassigned_Country_Case</fullName>
        <ccEmails>dl-support-escalations@storagecraft.com</ccEmails>
        <description>Alert Leadership of Unassigned Country Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>frank.theunissen@storagecraft.eu</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.davies@storagecraft.com.au.stc</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nephi.printy@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>torsten.ruether@storagecraft.eu</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Unassigned_Country_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_after_a_new_case_is_created</fullName>
        <ccEmails>crm@storagecraft.com</ccEmails>
        <description>Email the customer after a new case is created</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/New_Case_Acknowledgement</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_after_a_new_case_is_created_French_Rule</fullName>
        <ccEmails>crm@storagecraft.com</ccEmails>
        <description>Email the customer after a new case is created (French Rule)</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/New_Case_Acknowledgement_French</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_after_a_new_case_is_created_German_Rule</fullName>
        <ccEmails>crm@storagecraft.com</ccEmails>
        <description>Email the customer after a new case is created (German Rule)</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/New_Case_Acknowledgement_German</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_after_a_new_case_is_created_Italian_Rule</fullName>
        <ccEmails>crm@storagecraft.com</ccEmails>
        <description>Email the customer after a new case is created (Italian Rule)</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/New_Case_Acknowledgement_Italian</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_after_a_new_case_is_created_Japanese_Rule</fullName>
        <ccEmails>crm@storagecraft.com</ccEmails>
        <description>Email the customer after a new case is created (Japanese Rule)</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/New_Case_Acknowledgement_Japanese</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_after_a_new_case_is_created_Portuguese_Rule</fullName>
        <ccEmails>crm@storagecraft.com</ccEmails>
        <description>Email the customer after a new case is created (Portuguese Rule)</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/New_Case_Acknowledgement_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_after_a_new_case_is_created_Spanish_Rule</fullName>
        <ccEmails>crm@storagecraft.com</ccEmails>
        <description>Email the customer after a new case is created (Spanish Rule)</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/New_Case_Acknowledgement_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Email_the_customer_if_expired_maintenance_is_found_in_AU</fullName>
        <description>Email the customer if expired maintenance is found in AU</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Maintenance_Expired_Email_AU</template>
    </alerts>
    <alerts>
        <fullName>Emergency_Assigned_to_User</fullName>
        <ccEmails>SupportAll@storagecraft.com,</ccEmails>
        <ccEmails>john.stanley@storagecraft.com</ccEmails>
        <description>Emergency Assigned to User</description>
        <protected>false</protected>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Emergency_Notification_Got_It</template>
    </alerts>
    <alerts>
        <fullName>First_Emergency_Alert</fullName>
        <ccEmails>SupportAll@storagecraft.com,</ccEmails>
        <ccEmails>john.stanley@storagecraft.com</ccEmails>
        <description>First Emergency Alert</description>
        <protected>false</protected>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Emergency_Notification</template>
    </alerts>
    <alerts>
        <fullName>Guarantee_Claim_COPS</fullName>
        <ccEmails>DL-100K-Promo@storagecraft.com</ccEmails>
        <ccEmails>DL-Utah-NOC@storagecraft.com</ccEmails>
        <ccEmails>DL-CloudOps@storagecraft.com</ccEmails>
        <description>Guarantee Claim COPS</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>nephi.printy@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Guarantee_Claim</template>
    </alerts>
    <alerts>
        <fullName>Guarantee_Claim_Failed</fullName>
        <ccEmails>DL-100K-Promo@storagecraft.com</ccEmails>
        <ccEmails>DL-Utah-NOC@storagecraft.com</ccEmails>
        <ccEmails>DL-CloudOps@storagecraft.com</ccEmails>
        <ccEmails>cloud.services2@storagecraft.com</ccEmails>
        <ccEmails>DL-ExecStaff@storagecraft.com</ccEmails>
        <description>Guarantee Claim Failed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>nephi.printy@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Guarantee_Claim_Done</template>
    </alerts>
    <alerts>
        <fullName>Guarantee_Claim_Initial</fullName>
        <ccEmails>DL-100K-Promo@storagecraft.com</ccEmails>
        <description>Guarantee Claim Initial</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>nephi.printy@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Guarantee_Claim</template>
    </alerts>
    <alerts>
        <fullName>Guarantee_Claim_NOC</fullName>
        <ccEmails>DL-100K-Promo@storagecraft.com</ccEmails>
        <ccEmails>DL-Utah-NOC@storagecraft.com</ccEmails>
        <description>Guarantee Claim NOC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>nephi.printy@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Guarantee_Claim</template>
    </alerts>
    <alerts>
        <fullName>Guarantee_Claim_SUN</fullName>
        <ccEmails>DL-100K-Promo@storagecraft.com</ccEmails>
        <ccEmails>DL-Utah-NOC@storagecraft.com</ccEmails>
        <ccEmails>DL-CloudOps@storagecraft.com</ccEmails>
        <ccEmails>cloud.services2@storagecraft.com</ccEmails>
        <description>Guarantee Claim SUN</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>nephi.printy@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Guarantee_Claim</template>
    </alerts>
    <alerts>
        <fullName>Guarantee_Claim_Success</fullName>
        <ccEmails>DL-100K-Promo@storagecraft.com</ccEmails>
        <ccEmails>DL-Utah-NOC@storagecraft.com</ccEmails>
        <ccEmails>DL-CloudOps@storagecraft.com</ccEmails>
        <ccEmails>cloud.services2@storagecraft.com</ccEmails>
        <ccEmails>DL-ExecStaff@storagecraft.com</ccEmails>
        <description>Guarantee Claim Success</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>nephi.printy@storagecraft.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Guarantee_Claim_Done</template>
    </alerts>
    <alerts>
        <fullName>Low_Survey_Score_of_5_or_Less_Alert</fullName>
        <ccEmails>DL-Support-Escalations@storagecraft.com</ccEmails>
        <description>Low Survey Score of 5 or Less Alert</description>
        <protected>false</protected>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Low_Survey_Result</template>
    </alerts>
    <alerts>
        <fullName>New_US_Partner_Queue_Case_Alert</fullName>
        <ccEmails>DL-Support-Management@storagecraft.com, DL-Support-Escalations@storagecraft.com, DL-Support-TechLeads@storagecraft.com, DL-Utah-Support-AfterHours@storagecraft.com, nephi.printy@storagecraft.com</ccEmails>
        <description>New US Partner Queue Case Alert</description>
        <protected>false</protected>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/US_Partner_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Owner_When_Assigned</fullName>
        <description>Notify Case Owner When Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Notify_New_Owner</template>
    </alerts>
    <alerts>
        <fullName>Notify_Escalation_Team_of_New_Escalation</fullName>
        <ccEmails>DL-Support-Escalations@storagecraft.com</ccEmails>
        <description>Notify Escalation Team of New Escalation</description>
        <protected>false</protected>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Case_Escalation_Internal_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Case_Survey</fullName>
        <description>Send Case Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Case_Survey</template>
    </alerts>
    <alerts>
        <fullName>Sensitive_Case_Submission_Alert_Support_Management</fullName>
        <ccEmails>DL-Support-Escalations@storagecraft.com</ccEmails>
        <ccEmails>DL-Utah-Support-AfterHours@storagecraft.com</ccEmails>
        <ccEmails>DL-Support-TechLeads@storagecraft.com</ccEmails>
        <ccEmails>john.lorz@storagecraft.com</ccEmails>
        <description>Sensitive Case Submission - Alert Support Management</description>
        <protected>false</protected>
        <senderAddress>crm@storagecraft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Automatic/Sensitive_Account_Alert_for_Support_Mgmt</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_status_to_Reassigned</fullName>
        <field>Status</field>
        <literalValue>Reassigned</literalValue>
        <name>Case status to Reassigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Internal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_Name</fullName>
        <description>Copy the account name into the text name</description>
        <field>Account_Name_Text__c</field>
        <formula>Account.Name</formula>
        <name>Copy Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Emergency_Reminder_Needed</fullName>
        <description>Set the flag to fire emergency email</description>
        <field>Needs_Emergency_Reminder__c</field>
        <literalValue>1</literalValue>
        <name>Emergency Reminder Needed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Emergency_Reminder_Sent</fullName>
        <field>Needs_Emergency_Reminder__c</field>
        <literalValue>0</literalValue>
        <name>Emergency Reminder Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_as_Duplicate</fullName>
        <description>Used as an action for Flagging Erroneously created cases from the Email2Case issue around 32000 character truncation.</description>
        <field>Status</field>
        <literalValue>Duplicate</literalValue>
        <name>Set Case as Duplicate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Name_Text</fullName>
        <field>Contact_Name_Text__c</field>
        <formula>Contact.FirstName +&quot; &quot;+ Contact.LastName</formula>
        <name>Set Contact Name Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Case_Assignment</fullName>
        <field>Assignment_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Last Case Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Partner_Level_on_case</fullName>
        <description>Field to be automatically populated by workflow</description>
        <field>Partner_Level_Text__c</field>
        <formula>TEXT(Account.Partner_Level__c)</formula>
        <name>Update Partner Level on case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_2</fullName>
        <description>Guarantee Claim Timer update to Stage 2</description>
        <field>Claim_Stage__c</field>
        <literalValue>Stage 2</literalValue>
        <name>Update Stage 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_3</fullName>
        <description>Guarantee Claim Timer update to Stage 3</description>
        <field>Claim_Stage__c</field>
        <literalValue>Stage 3</literalValue>
        <name>Update Stage 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_4</fullName>
        <description>Guarantee Claim Timer update to Stage 3</description>
        <field>Claim_Stage__c</field>
        <literalValue>Stage 4</literalValue>
        <name>Update Stage 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_5</fullName>
        <description>Guarantee Claim Timer update to Stage 5</description>
        <field>Claim_Stage__c</field>
        <literalValue>Stage 5</literalValue>
        <name>Update Stage 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_6</fullName>
        <description>Guarantee Claim Timer update to Stage 6</description>
        <field>Claim_Stage__c</field>
        <literalValue>Stage 6</literalValue>
        <name>Update Stage 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_7</fullName>
        <description>Guarantee Claim Timer update to Stage 7</description>
        <field>Claim_Stage__c</field>
        <literalValue>Stage 7</literalValue>
        <name>Update Stage 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_8</fullName>
        <description>Guarantee Claim Timer update to Stage 8</description>
        <field>Claim_Stage__c</field>
        <literalValue>Stage 8</literalValue>
        <name>Update Stage 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Failed</fullName>
        <description>Guarantee Claim Timer update Stage to Failed</description>
        <field>Claim_Stage__c</field>
        <literalValue>Failed</literalValue>
        <name>Update Stage Failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Case_ARK_Notification</fullName>
        <apiVersion>36.0</apiVersion>
        <description>Send case information to ARK</description>
        <endpointUrl>http://crm.storagecraft.com/ArkService/CaseResolved.asmx</endpointUrl>
        <fields>Ark_Article__c</fields>
        <fields>Assistance_Type__c</fields>
        <fields>CaseNumber</fields>
        <fields>Cause__c</fields>
        <fields>Core_Problem_Type__c</fields>
        <fields>CreatedDate</fields>
        <fields>Description</fields>
        <fields>Id</fields>
        <fields>Operating_System__c</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Name__c</fields>
        <fields>Product_Component__c</fields>
        <fields>Product_Sub_Component__c</fields>
        <fields>Product_Version__c</fields>
        <fields>Product__c</fields>
        <fields>Resolution__c</fields>
        <fields>Status</fields>
        <fields>Subject</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>larry.fox@storagecraft.com</integrationUser>
        <name>Case ARK Notification</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Ark Article Value Changed</fullName>
        <actions>
            <name>Case_ARK_Notification</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( AND(  IsClosed,  NOT(ISNULL(Ark_Article__c)),  OR(  ISPICKVAL(Assistance_Type__c , &apos;Technical Assistance&apos;),  ISPICKVAL(Assistance_Type__c , &apos;Licensing Assistance&apos;)  ),  OR(  ISPICKVAL(Status, &apos;Resolved : Environmental&apos;),  ISPICKVAL(Status, &apos;Resolved : Technical Support Issue&apos;),  ISPICKVAL(Status, &apos;Resolved : Activation Problem Solved&apos;)  )  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture Last Case Assignment Change</fullName>
        <actions>
            <name>Update_Last_Case_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Record when Case Assignment was last modified</description>
        <formula>OR(CreatedDate &gt; Assignment_Date_Time__c, ISBLANK(Assignment_Date_Time__c),ISCHANGED(OwnerId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change WebForm Record Type</fullName>
        <actions>
            <name>Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>WebForm</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Copy Account Name</fullName>
        <actions>
            <name>Copy_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy Account Name into text field so it can be searchable.</description>
        <formula>Account.Name !=  Account_Name_Text__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Contact Name</fullName>
        <actions>
            <name>Set_Contact_Name_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy Contact Name into text field so it can be searchable.</description>
        <formula>(Contact.FirstName +&quot; &quot;+ Contact.LastName) !=  Contact_Name_Text__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Notified of New Case</fullName>
        <actions>
            <name>Email_the_customer_after_a_new_case_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email that goes out to a new customer after the case is logged, it should contain the Case Number, SLAs and thier information bounced back to them. ENGLISH AND FALLBACK FOR OTHER LANGUAGES</description>
        <formula>NOT(OR(ISPICKVAL(Language__c,(&quot;Portuguese&quot;)),(ISPICKVAL(Language__c,(&quot;French&quot;))),(ISPICKVAL(Language__c,(&quot;Spanish&quot;))),(ISPICKVAL(Language__c,(&quot;German&quot;))),(ISPICKVAL(Language__c,(&quot;Italian&quot;))),ISPICKVAL(Language__c,(&quot;Japanese&quot;))))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer Notified of New Case %28French%29</fullName>
        <actions>
            <name>Email_the_customer_after_a_new_case_is_created_French_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email that goes out to a new customer after the case is logged, it should contain the Case Number, SLAs and thier information bounced back to them. FRENCH CASES ONLY</description>
        <formula>ISPICKVAL(Language__c,&quot;French&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer Notified of New Case %28German%29</fullName>
        <actions>
            <name>Email_the_customer_after_a_new_case_is_created_German_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email that goes out to a new customer after the case is logged, it should contain the Case Number, SLAs and thier information bounced back to them. GERMAN CASES ONLY</description>
        <formula>ISPICKVAL(Language__c,&quot;German&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer Notified of New Case %28Italian%29</fullName>
        <actions>
            <name>Email_the_customer_after_a_new_case_is_created_Italian_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email that goes out to a new customer after the case is logged, it should contain the Case Number, SLAs and thier information bounced back to them. ITALIAN CASES ONLY</description>
        <formula>ISPICKVAL(Language__c,&quot;Italian&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer Notified of New Case %28Japan%29</fullName>
        <actions>
            <name>Email_the_customer_after_a_new_case_is_created_Japanese_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email that goes out to a new customer after the case is logged, it should contain the Case Number, SLAs and thier information bounced back to them. JAPANESE CASES ONLY</description>
        <formula>ISPICKVAL(Language__c,&quot;Japanese&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer Notified of New Case %28Portuguese%29</fullName>
        <actions>
            <name>Email_the_customer_after_a_new_case_is_created_Portuguese_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email that goes out to a new customer after the case is logged, it should contain the Case Number, SLAs and thier information bounced back to them. PORTUGUESE CASES ONLY</description>
        <formula>ISPICKVAL(Language__c,&quot;Portuguese&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Customer Notified of New Case %28Spanish%29</fullName>
        <actions>
            <name>Email_the_customer_after_a_new_case_is_created_Spanish_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email that goes out to a new customer after the case is logged, it should contain the Case Number, SLAs and thier information bounced back to them. SPANISH CASES ONLY</description>
        <formula>ISPICKVAL(Language__c,&quot;Spanish&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Emergency Assigned</fullName>
        <actions>
            <name>Emergency_Assigned_to_User</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This triggers upon an emergency being assigned to a tech.</description>
        <formula>AND(ISCHANGED(OwnerId), CONTAINS(PRIORVALUE( Case_Owner_Name__c ),&quot;Emergency&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Emergency Reminder</fullName>
        <actions>
            <name>First_Emergency_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Emergency_Reminder_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(CONTAINS(Case_Owner_Name__c, &apos;Emergency&apos;), Needs_Emergency_Reminder__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Expired Maintenance Email AU</fullName>
        <actions>
            <name>Email_the_customer_if_expired_maintenance_is_found_in_AU</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Owner_Name__c</field>
            <operation>equals</operation>
            <value>AU Expired Parking</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Assistance_Type__c</field>
            <operation>equals</operation>
            <value>Technical Assistance</value>
        </criteriaItems>
        <description>a message sent to customers who log a request help case and have expired maintenance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>First Emergency Email</fullName>
        <actions>
            <name>First_Emergency_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Owner_Name__c</field>
            <operation>contains</operation>
            <value>Emergency</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Flag Erroneously Created Cases as Duplicate</fullName>
        <actions>
            <name>Set_Case_as_Duplicate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Assistance_Type__c</field>
            <operation>notContain</operation>
            <value>Licensing Assistance,Technical Assistance,Sales Assistance,Product_Return</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Web,Customer Setup</value>
        </criteriaItems>
        <description>This is a rule that will remove any cases created by Email2Case by mistake caused by the 32,000 character truncation of salesforce.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Guarantee Claim Timer</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Emergency</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Claim_Timer_Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates the claim stage in the case every 3 hours, which kicks off the other events in the &quot;Guarantee Claim&quot; process found in Process Builder</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_4</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_5</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_7</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>18</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_8</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_6</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_3</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Stage_Failed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Low Survey Result</fullName>
        <actions>
            <name>Low_Survey_Score_of_5_or_Less_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.Survey_Quality_of_Service__c</field>
            <operation>lessOrEqual</operation>
            <value>5</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Response_Time__c</field>
            <operation>lessOrEqual</operation>
            <value>5</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Quality_of_Service__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Response_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>LAST 30 DAYS</value>
        </criteriaItems>
        <description>This workflow is to send an email alert when a low result is received in a support case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify New Case Owner</fullName>
        <actions>
            <name>Notify_Case_Owner_When_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to the owner of a case when a case has been reassigned.</description>
        <formula>OR(ISNEW(), ISCHANGED(OwnerId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Partner Level case update</fullName>
        <actions>
            <name>Update_Partner_Level_on_case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update Partner Level Text field on case</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sensitive Account Alert for Europe Support</fullName>
        <actions>
            <name>Alert_EU_Support_Management_of_Sensitive_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@zenzero.co.uk,@nis-it.co.uk,@concise.co.uk,@air-it.co.uk,@air-it.co.uk,@millgate.co.uk,@networkroi.co.uk,@mlinkuk.com,@amshire.co.uk,@tms-scotland.com,@acutec.co.uk,@pro-networks.co.uk,@datapacific.com,@turnkey-is.com,@backup4business.com,@intalect.co.uk</value>
        </criteriaItems>
        <description>An alert to warn EU support management something sensitive has come in</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sensitive Account Alert for Support Mgmt</fullName>
        <actions>
            <name>Sensitive_Case_Submission_Alert_Support_Management</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@wnlaw.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@martinkenwood.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@lansolutions.net</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@globaldatavault.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@ns-data.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@cts.co.uk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@tooeleco.org</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@cti-global.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@lcgassociates.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@managedcaresystems.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@legenditconsulting.com</value>
        </criteriaItems>
        <description>An alert to warn support management something sensitive has come in</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set to Reassigned Status when reassigned</fullName>
        <actions>
            <name>Case_status_to_Reassigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (
or(
not(isnull(Last_Phone_Call__c)),
not(isnull(Last_Received_Email__c))
)
,
ISCHANGED(OwnerId)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US Partner Case Notifier</fullName>
        <actions>
            <name>New_US_Partner_Queue_Case_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Owner_Name__c</field>
            <operation>equals</operation>
            <value>US Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule is to kick off a notification to the support people managing the US Partner Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unassigned Country Case Notifier</fullName>
        <actions>
            <name>Alert_Leadership_of_Unassigned_Country_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Owner_Name__c</field>
            <operation>contains</operation>
            <value>Unassigned Country</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
