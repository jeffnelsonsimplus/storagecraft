<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_set_Status_waiting_on_customer</fullName>
        <field>Status</field>
        <literalValue>Waiting on Customer</literalValue>
        <name>Case set Status waiting on customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Last_Email</fullName>
        <field>Last_Received_Email__c</field>
        <formula>CreatedDate</formula>
        <name>Set Case Last Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_to_Reply</fullName>
        <field>Status</field>
        <literalValue>Customer Replied</literalValue>
        <name>Update Case to Reply</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Set Case Last Email</fullName>
        <actions>
            <name>Set_Case_Last_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>CONTAINS(ToAddress  ,  Parent.Contact.Email )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Case on Customer Reply</fullName>
        <actions>
            <name>Set_Case_Last_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_to_Reply</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.FromAddress</field>
            <operation>notContain</operation>
            <value>storagecraft.</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,Waiting on Customer,Patch Sent,Pending Closure,Reassigned,Reopened,Waiting on Escalations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Data_Migration_Source__c</field>
            <operation>notContain</operation>
            <value>AU</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Case on When Customer Contacted</fullName>
        <actions>
            <name>Case_set_Status_waiting_on_customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
Parent.IsClosed = false,
$User.Id =  Parent.OwnerId,
OR(ISPICKVAL(Parent.Status, &apos;In Progress&apos;),
ISPICKVAL(Parent.Status, &apos;New&apos;),
ISPICKVAL(Parent.Status, &apos;Customer Replied&apos;),
ISPICKVAL(Parent.Status, &apos;Patch Sent&apos;),
ISPICKVAL(Parent.Status, &apos;Pending Closure&apos;),
ISPICKVAL(Parent.Status, &apos;Reassigned&apos;),
ISPICKVAL(Parent.Status, &apos;Reopened&apos;),
ISPICKVAL(Parent.Status, &apos;Waiting on Escalations&apos;)
))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
