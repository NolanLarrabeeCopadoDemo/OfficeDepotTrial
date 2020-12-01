<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Short_SIC_Code</fullName>
        <field>OD_SIC__c</field>
        <formula>CASE(LEFT(SIC_Code__c, 2) , 
&apos;73&apos;, &apos;BS&apos;, 
&apos;78&apos;, &apos;BS&apos;, 
&apos;70&apos;, &apos;BS&apos;, 
&apos;79&apos;, &apos;BS&apos;, 
&apos;16&apos;, &apos;CO&apos;, 
&apos;15&apos;, &apos;CO&apos;, 
&apos;17&apos;, &apos;CO&apos;, 
&apos;82&apos;, &apos;ES&apos;, 
&apos;87&apos;, &apos;EA&apos;, 
&apos;67&apos;, &apos;FN&apos;, 


&apos;93&apos;, &apos;GV&apos;, 
&apos;97&apos;, &apos;GV&apos;, 
&apos;95&apos;, &apos;GV&apos;, 
&apos;96&apos;, &apos;GV&apos;, 
&apos;92&apos;, &apos;GV&apos;, 
&apos;91&apos;, &apos;GV&apos;, 
&apos;94&apos;, &apos;GV&apos;, 

&apos;81&apos;, &apos;LG&apos;, 

&apos;20&apos;, &apos;MN&apos;, 
&apos;21&apos;, &apos;MN&apos;,
&apos;22&apos;, &apos;MN&apos;, 
&apos;23&apos;, &apos;MN&apos;, 
&apos;24&apos;, &apos;MN&apos;,
&apos;25&apos;, &apos;MN&apos;, 
&apos;26&apos;, &apos;MN&apos;, 
&apos;27&apos;, &apos;MN&apos;, 
&apos;28&apos;, &apos;MN&apos;, 
&apos;29&apos;, &apos;MN&apos;,
 
&apos;30&apos;, &apos;MN&apos;, 
&apos;31&apos;, &apos;MN&apos;, 
&apos;32&apos;, &apos;MN&apos;, 
&apos;33&apos;, &apos;MN&apos;, 
&apos;34&apos;, &apos;MN&apos;, 
&apos;35&apos;, &apos;MN&apos;, 
&apos;36&apos;, &apos;MN&apos;, 
&apos;37&apos;, &apos;MN&apos;, 
&apos;38&apos;, &apos;MN&apos;, 
&apos;39&apos;, &apos;MN&apos;, 

&apos;40&apos;, &apos;UT&apos;,
&apos;41&apos;, &apos;UT&apos;,
&apos;42&apos;, &apos;UT&apos;,
&apos;43&apos;, &apos;UT&apos;,
&apos;44&apos;, &apos;UT&apos;,
&apos;45&apos;, &apos;UT&apos;,
&apos;46&apos;, &apos;UT&apos;,
&apos;47&apos;, &apos;UT&apos;,
&apos;48&apos;, &apos;UT&apos;,
&apos;49&apos;, &apos;UT&apos;,

&apos;52&apos;, &apos;RT&apos;, 
&apos;53&apos;, &apos;RT&apos;,
&apos;54&apos;, &apos;RT&apos;,
&apos;55&apos;, &apos;RT&apos;,
&apos;56&apos;, &apos;RT&apos;,
&apos;57&apos;, &apos;RT&apos;,
&apos;58&apos;, &apos;RT&apos;,
&apos;59&apos;, &apos;RT&apos;,

&apos;60&apos;, &apos;FN&apos;, 
&apos;61&apos;, &apos;FN&apos;, 
&apos;62&apos;, &apos;FN&apos;, 
&apos;63&apos;, &apos;IN&apos;, 
&apos;64&apos;, &apos;IN&apos;, 
&apos;65&apos;, &apos;RE&apos;,

&apos;80&apos;, &apos;MH&apos;, 
&apos;83&apos;, &apos;SS&apos;,
&apos;84&apos;, &apos;OR&apos;, 

&apos;86&apos;, &apos;OR&apos;, 
&apos;50&apos;, &apos;WT&apos;,
&apos;51&apos;, &apos;WT&apos;,
&apos;OT&apos;)</formula>
        <name>Short SIC Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Org SIC Code</fullName>
        <actions>
            <name>Short_SIC_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Takes the first two digits from a record&apos;s SIC_Code__c and writes a two letter category code to the OD_SIC__c, which will be used in Sales Potential field calculations.</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
