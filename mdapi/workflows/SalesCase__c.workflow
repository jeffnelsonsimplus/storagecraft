<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Academy_Onboarded</fullName>
        <description>Academy Onboarded</description>
        <protected>false</protected>
        <recipients>
            <recipient>storagecraft1@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <alerts>
        <fullName>MSP_Portal</fullName>
        <description>MSP Portal</description>
        <protected>false</protected>
        <recipients>
            <recipient>storagecraft1@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <alerts>
        <fullName>Partner_Network_Discussion</fullName>
        <description>Partner Network Discussion</description>
        <protected>false</protected>
        <recipients>
            <recipient>storagecraft1@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <alerts>
        <fullName>Partner_Portal_Walkthrough</fullName>
        <description>Partner Portal Walkthrough</description>
        <protected>false</protected>
        <recipients>
            <recipient>storagecraft1@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <alerts>
        <fullName>Pricing_Calculator</fullName>
        <description>Pricing Calculator</description>
        <protected>false</protected>
        <recipients>
            <recipient>storagecraft1@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <alerts>
        <fullName>Send_Welcome_Letter</fullName>
        <description>Send Welcome Letter</description>
        <protected>false</protected>
        <recipients>
            <recipient>storagecraft1@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <alerts>
        <fullName>Technical_Support_Porcess</fullName>
        <description>Technical Support Porcess</description>
        <protected>false</protected>
        <recipients>
            <recipient>storagecraft1@simplus.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Placeholder_Test_Simplus</template>
    </alerts>
    <fieldUpdates>
        <fullName>Partner_Status</fullName>
        <description>Partner Status set to &apos;In Maintenance&apos; when Grow Your Partner Record type marked as complete</description>
        <field>PartnerStatus__c</field>
        <literalValue>In Maintenance</literalValue>
        <name>Partner Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Sales Stage%3A Academy Onboarded %28Stage 2%29</fullName>
        <actions>
            <name>Academy_Onboarded</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.AcademyOnboarded__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send Email when Academy Onboarded is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Complete Create Task %28Stage 1%29</fullName>
        <actions>
            <name>First_Onsite_Visit</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <description>Sends onsite visit email when Sales Case marked as Complete (Status field)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A How to Buy %28Stage 2%29</fullName>
        <actions>
            <name>MSP_Portal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.PurchasePreference__c</field>
            <operation>includes</operation>
            <value>MSP portal</value>
        </criteriaItems>
        <description>When How to Buy is selected, if user chooses MSP portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Partner Network Discussion %28Stage 2%29</fullName>
        <actions>
            <name>Partner_Network_Discussion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.PartnerNetworkDiscussion__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send email when Partner Network Discussion is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Partner Portal Walkthrough %28Stage 2%29</fullName>
        <actions>
            <name>Partner_Portal_Walkthrough</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.PartnerPortalWalkthrough__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends email when Partner Portal Walkthrough is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Pricing Calculator %28Stage 2%29</fullName>
        <actions>
            <name>Pricing_Calculator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.PricingCalculator__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Email sent when Pricing Calculator is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Product Demo %28Stage 2%29</fullName>
        <actions>
            <name>Product_demo_for_Account</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>When ProductDemoDateTime and ProductDemoContact (preferred) are filled out create a task: Subject ‘Product demo for *accountname*</description>
        <formula>AND( NOT(ISBLANK(PreferredDemoContact__c)), NOT(ISBLANK(ProductDemoDateTime__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Sales Case Complete %28Stage 3%29</fullName>
        <actions>
            <name>Partner_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>SalesCase__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Grow Your Partner</value>
        </criteriaItems>
        <description>When Grow Your Partner is completed, sets account partner status to &apos;In Maintenance&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Send Welcome Letter %28Stage 1%29</fullName>
        <actions>
            <name>Send_Welcome_Letter</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.SendWelcomeLetter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If Send Welcome Letter is checked, send email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage%3A Technical Support Process %28Stage 2%29</fullName>
        <actions>
            <name>Technical_Support_Porcess</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SalesCase__c.TechnicalSupportProcess__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Email sent when Technical Support Process is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>First_Onsite_Visit</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>First Onsite Visit</subject>
    </tasks>
    <tasks>
        <fullName>Product_demo_for_Account</fullName>
        <assignedTo>sfdc+storagecraft@simplus.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Product demo for Account</subject>
    </tasks>
</Workflow>
