<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Task_Comments_Start_Update</fullName>
        <description>Cut Comment down to 100 or less characters</description>
        <field>Comments_Start__c</field>
        <formula>IF(LEN(Description) &gt; 100, LEFT(Description, 97) + &apos;…&apos;, LEFT(Description, 100))</formula>
        <name>Task Comments Start Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Task%3A Comments Start Update</fullName>
        <actions>
            <name>Task_Comments_Start_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Description</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Set the value for the Comments Start</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
