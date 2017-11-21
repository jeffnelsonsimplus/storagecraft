<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Set_Account_Record_Type_Dist</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Distributor</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Account | Set Record Type : Dist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Account_Record_Type_Part</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Account | Set Record Type : Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_End_User_Partner_Level</fullName>
        <field>Partner_Level__c</field>
        <literalValue>None</literalValue>
        <name>Account | Set End User Partner Level</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_End_User_Partner_Level_Cal</fullName>
        <field>Partner_Level_Calculated__c</field>
        <formula>&apos;None&apos;</formula>
        <name>Account | Set End User Partner Level Cal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Prospect_Level</fullName>
        <field>Partner_Level__c</field>
        <literalValue>Authorized</literalValue>
        <name>Account | Set Prospect Level</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Prospect_Level_Calculated</fullName>
        <field>Partner_Level_Calculated__c</field>
        <formula>&apos;Authorized&apos;</formula>
        <name>Account | Set Prospect Level Calculated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Record_Type_End_User</fullName>
        <field>RecordTypeId</field>
        <lookupValue>End_User</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Account | Set Record Type : End User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Type_End_User</fullName>
        <field>Type</field>
        <literalValue>End User</literalValue>
        <name>Account | Set Type : End User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Type_Prospect</fullName>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Account | Set Type : Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Type_to_Account</fullName>
        <description>Set the Type to Account when the agreement is accepted</description>
        <field>Type</field>
        <literalValue>Account</literalValue>
        <name>Account | Set Type to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_Update</fullName>
        <description>Updates Type to Prospect</description>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account %7C Agreement Accepted</fullName>
        <actions>
            <name>Account_Set_Type_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.VAR_Agreement_Accepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Change the Type of an Account to &quot;Account&quot; when the VAR Agreement Accepted flag get set.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account %7C On Create Prospect</fullName>
        <actions>
            <name>Account_Set_Account_Record_Type_Part</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Prospect,Account</value>
        </criteriaItems>
        <description>Force Account Type when account created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account %7C Set Types %3A Distributor</fullName>
        <actions>
            <name>Account_Set_Account_Record_Type_Dist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.User_Type__c</field>
            <operation>equals</operation>
            <value>Distribution Partner,Distributors Partner Reseller,International Master Distributor</value>
        </criteriaItems>
        <description>Set Distributor data when User Type is changed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account %7C Set Types %3A End User</fullName>
        <actions>
            <name>Account_Set_End_User_Partner_Level</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Set_End_User_Partner_Level_Cal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.User_Type__c</field>
            <operation>equals</operation>
            <value>Business User,Home User,Trial User</value>
        </criteriaItems>
        <description>Set End User data when User Type is changed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account %7C Set Types %3A Prospect</fullName>
        <actions>
            <name>Account_Set_Account_Record_Type_Part</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Set_Prospect_Level</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Set_Prospect_Level_Calculated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Set_Type_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.User_Type__c</field>
            <operation>equals</operation>
            <value>Alliance Partner,Both MSP and VAR,CP,Direct Market Reseller (DMR),Managed Service Provider (MSP),Original Equipment Manufacturer (OEM),Other,Press / Media Evaluator,Strategic,Value Added Reseller (VAR)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Account,Prospect</value>
        </criteriaItems>
        <description>Set Prospect data when User Type is changed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Type%3A To Prospect</fullName>
        <actions>
            <name>Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
