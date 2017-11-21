<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_New_Deal_Registration</fullName>
        <description>Lead: New Deal Registration</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales/Lead_New_Deal_Registration</template>
    </alerts>
    <fieldUpdates>
        <fullName>Lead</fullName>
        <field>DisqualifiedReason__c</field>
        <literalValue>Do not contact</literalValue>
        <name>Lead | Disqualified Reason | Do not Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Deal_Reg_Set_User_Type</fullName>
        <field>UserType__c</field>
        <literalValue>Business User</literalValue>
        <name>Lead: Deal Reg Set User Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_Disqualified</fullName>
        <field>Status</field>
        <literalValue>Disqualified</literalValue>
        <name>Lead | Set Disqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_Record_Type_Deal_Reg</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DealRegistration</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead | Set Record Type : Deal Reg</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_Record_Type_End_User</fullName>
        <field>RecordTypeId</field>
        <lookupValue>End_User</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead | Set Record Type : End User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_Record_Types_Partner</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead | Set Record Type : Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_website_from_domain</fullName>
        <field>Website</field>
        <formula>Domain__c</formula>
        <name>Lead: Set website from domain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Source_to_leadSource_m</fullName>
        <description>JIRA SSF-34</description>
        <field>leadSource_m__c</field>
        <formula>TEXT(LeadSource)</formula>
        <name>Lead Source to leadSource_m</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Source_Campaign_to_sourceCampaign_m</fullName>
        <description>JIRA SSF-34</description>
        <field>sourceCampaign_m__c</field>
        <formula>SourceCampaign__r.Name</formula>
        <name>Source Campaign to sourceCampaign_m</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateTextField</fullName>
        <field>GetRecordTypeName__c</field>
        <formula>RecordType.Name</formula>
        <name>UpdateTextField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GetRecordTypeName</fullName>
        <actions>
            <name>UpdateTextField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>New,Untouched</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C Do not Call</fullName>
        <actions>
            <name>Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Set_Disqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.DoNotCall</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Disqualify Lead if Do not Call is set</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C Set Types %3A Deal Registration</fullName>
        <actions>
            <name>Lead_Set_Record_Type_Deal_Reg</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Deal Registration</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C Set Types %3A End User</fullName>
        <actions>
            <name>Lead_Set_Record_Type_End_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.UserType__c</field>
            <operation>equals</operation>
            <value>Business User,Home User,Other,Press / Media Evaluator,Trial User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>notEqual</operation>
            <value>Deal Registration</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C Set Types %3A Partner</fullName>
        <actions>
            <name>Lead_Set_Record_Types_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.UserType__c</field>
            <operation>equals</operation>
            <value>Alliance Partner,Both MSP and VAR,CP,Direct Market Reseller (DMR),Distribution Partner,Distributors Partner Reseller,Managed Service Provider (MSP),Original Equipment Manufacturer (OEM),Strategic,Value Added Reseller (VAR)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>notEqual</operation>
            <value>Deal Registration</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Deal Reg Set User Type</fullName>
        <actions>
            <name>Lead_Deal_Reg_Set_User_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) and 3</booleanFilter>
        <criteriaItems>
            <field>Lead.DealRegistrationNumber__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Deal Registration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.UserType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A New Deal Registration</fullName>
        <actions>
            <name>Lead_New_Deal_Registration</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Deal_Registration_is_pending_your_review</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Email_Sent_Deal_Reg_Notification</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(   $Setup.AutomationController__c.ExecuteLeadAutomation__c,   ispickval(LeadSource,&quot;Deal Registration&quot;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Set website from domain</fullName>
        <actions>
            <name>Lead_Set_website_from_domain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Domain__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Website</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A set leadSource_m</fullName>
        <actions>
            <name>Lead_Source_to_leadSource_m</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>JIRA SSF-34</description>
        <formula>AND( NOT(ISPICKVAL(LeadSource, &apos;&apos;)), OR( ISNEW(), ISCHANGED(LeadSource) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A set sourceCampaign_m</fullName>
        <actions>
            <name>Source_Campaign_to_sourceCampaign_m</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>JIRA SSF-34</description>
        <formula>AND(  NOT(ISBLANK(SourceCampaign__c)),  OR(  ISNEW(),  ISCHANGED(SourceCampaign__c)  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Deal_Registration_is_pending_your_review</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Deal Registration is pending your review</subject>
    </tasks>
    <tasks>
        <fullName>Email_Sent_Deal_Reg_Notification</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Sent: Deal Reg Notification</subject>
    </tasks>
</Workflow>
