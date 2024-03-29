<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Sync_Campaign_to_Exablox_AU</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://endpoint.scribesoft.com/v1/orgs/16321/messages/2911?accesstoken=df0c2ed3-f678-4a7d-9fa4-5c8bfd0e23b0</endpointUrl>
        <fields>ActualCost</fields>
        <fields>AmountAllOpportunities</fields>
        <fields>AmountWonOpportunities</fields>
        <fields>BudgetedCost</fields>
        <fields>CampaignMemberRecordTypeId</fields>
        <fields>Concur_Code__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>CurrencyIsoCode</fields>
        <fields>Description</fields>
        <fields>EndDate</fields>
        <fields>ExpectedResponse</fields>
        <fields>ExpectedRevenue</fields>
        <fields>Ext_Id_Value_Case_Insensitive__c</fields>
        <fields>HierarchyActualCost</fields>
        <fields>HierarchyAmountAllOpportunities</fields>
        <fields>HierarchyAmountWonOpportunities</fields>
        <fields>HierarchyBudgetedCost</fields>
        <fields>HierarchyExpectedRevenue</fields>
        <fields>HierarchyNumberOfContacts</fields>
        <fields>HierarchyNumberOfConvertedLeads</fields>
        <fields>HierarchyNumberOfLeads</fields>
        <fields>HierarchyNumberOfOpportunities</fields>
        <fields>HierarchyNumberOfResponses</fields>
        <fields>HierarchyNumberOfWonOpportunities</fields>
        <fields>HierarchyNumberSent</fields>
        <fields>Id</fields>
        <fields>IsActive</fields>
        <fields>IsDeleted</fields>
        <fields>LastActivityDate</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>LastReferencedDate</fields>
        <fields>LastViewedDate</fields>
        <fields>Name</fields>
        <fields>NumberOfContacts</fields>
        <fields>NumberOfConvertedLeads</fields>
        <fields>NumberOfLeads</fields>
        <fields>NumberOfOpportunities</fields>
        <fields>NumberOfResponses</fields>
        <fields>NumberOfWonOpportunities</fields>
        <fields>NumberSent</fields>
        <fields>OwnerId</fields>
        <fields>ParentId</fields>
        <fields>StartDate</fields>
        <fields>Status</fields>
        <fields>SystemModstamp</fields>
        <fields>Type</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>storagecraft1@simplus.com</integrationUser>
        <name>Sync Campaign to Exablox/AU</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Campaign%3A Sync between Global to Exablox%2FAU</fullName>
        <actions>
            <name>Sync_Campaign_to_Exablox_AU</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Added test entry criteria. Need to confirm.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
