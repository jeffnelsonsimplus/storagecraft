<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MarketingKey_Set_Claimed_On</fullName>
        <field>Claimed_On__c</field>
        <formula>Now()</formula>
        <name>MarketingKey Set Claimed On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MarketingKey Set Claimed On</fullName>
        <actions>
            <name>MarketingKey_Set_Claimed_On</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Marketing_Key__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Marketing_Key__c.First_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Marketing_Key__c.Last_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Marketing_Key__c.Claimed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Marketing_Key__c.Claimed_On__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If this is the first claim on the key, set the Claimed On date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
