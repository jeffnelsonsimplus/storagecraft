<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Email_Video</fullName>
        <ccEmails>nephi.printy@storagecraft.com</ccEmails>
        <description>Approval Email Video</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Automatic/Article_Response_Video</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Email_Video</fullName>
        <ccEmails>nephi.printy@storagecraft.com</ccEmails>
        <description>Rejection Email Video</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Automatic/Article_Response_Video</template>
    </alerts>
    <fieldUpdates>
        <fullName>Check_Customer_Channel</fullName>
        <field>IsVisibleInCsp</field>
        <literalValue>1</literalValue>
        <name>Check Customer Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_PKB_Channel</fullName>
        <field>IsVisibleInPkb</field>
        <literalValue>1</literalValue>
        <name>Check PKB Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Partner_Channel</fullName>
        <field>IsVisibleInPrm</field>
        <literalValue>1</literalValue>
        <name>Check Partner Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Customer_Channel</fullName>
        <field>IsVisibleInCsp</field>
        <literalValue>0</literalValue>
        <name>Uncheck Customer Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_PKB_Channel</fullName>
        <field>IsVisibleInPkb</field>
        <literalValue>0</literalValue>
        <name>Uncheck PKB Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Partner_Channel</fullName>
        <field>IsVisibleInPrm</field>
        <literalValue>0</literalValue>
        <name>Uncheck Partner Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Video_Approval_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Video Approval Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Video_Approval_Recalled</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Video Approval Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Video_Approval_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Video Approval Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Video_Approval_Submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Video Approval Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_New_Video</fullName>
        <action>PublishAsNew</action>
        <label>Publish New Video</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
