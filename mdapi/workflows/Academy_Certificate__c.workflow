<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Academy_Set_Expiration</fullName>
        <description>Set the expiration date of the certificate to 2 years from the Certification Date</description>
        <field>Expiration_Date__c</field>
        <formula>IF( 
AND(Month(Certified_Date__c)=2, Day(Certified_Date__c)=29), 
DATE(YEAR(Certified_Date__c)+2, 2, 28), 
DATE(YEAR(Certified_Date__c)+2, Month(Certified_Date__c), Day(Certified_Date__c)) 
)</formula>
        <name>Academy Set Expiration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Academy Certificate %3A Set Expiration Date</fullName>
        <actions>
            <name>Academy_Set_Expiration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Academy_Certificate__c.Passed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Academy_Certificate__c.Certified_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Academy Certification only last for 2 years</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
