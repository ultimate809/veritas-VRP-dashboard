*** Settings ***
Library		SSHLibrary
Library		String
Library		Collections
Library		OperatingSystem
Resource	system_keywords.robot
Library     Selenium2Library		timeout=60  implicit_wait=2
Library     Selenium2LibraryExt.py
Resource 			all_keywords.robot
Resource 			all_variables.robot
Resource 			all_ui_objects.robot
Resource 			all_constants.robot
Resource 			${CONFIG}
Library             DependencyCheckLibrary.py
Suite Setup 		Login To VRP 	${RM_HOST1}  ${VALID_USER}  ${VALID_PASSWORD}  ${DOMAIN}
Suite Teardown  	Close All Browsers
#Test Teardown       Reload Page To Clear Wizard Pop-ups		${TEST_NAME}

*** Variables ***
${RG_total_count_Homepage}     	    			xpath=//a[@ui-sref="apps.list.managed"]/div/div[@class="status-count ng-binding"]
${RG_AtRisk_count_Homepage}    					xpath=//a[@ui-sref="apps.list.managed({stateId:'at_risk'})"]/div/div[@class="status-count ng-binding"]
${RG_Normal_count_Homepage}    					xpath=//a[@ui-sref="apps.list.managed({stateId:'healthy'})"]/div/div[@class="status-count ng-binding"]
${VMware%_Homepage}       						xpath=//div[@id="vmByTypeDonutLegend"]
${Risk_Summary_Errors_Homepage}     			xpath=//div[contains(text(),'Errors')]/preceding-sibling::div[@class="ng-binding"]
${Risk_Summary_Warnings_Homepage}   			xpath=//div[contains(text(),'Warnings')]/preceding-sibling::div[@class="ng-binding"]
${Risk_Details_BTN}         					xpath=//a[@ui-sref="risks" and @class ="ng-binding"]
${Home_Page_Button}               				xpath=//a[@ui-sref="home"]
${Risks_Warnings_Risk_Page}      				//div[@class="ngCellText ng-scope" and @uib-popover="Warning"]
${Risks_Errors_Risk_Page}        				//div[@class="ngCellText ng-scope" and @uib-popover="Error"]
${Assets_RGs_AtRisk}     						//div[@class="ngCellText ng-binding ng-scope" and @uib-popover="At Risk"]
${Assets_RGs_Normal}      						//div[@class="ngCellText ng-binding ng-scope" and @uib-popover="Normal"] 
${Assets_RG_Details_BTN}      					xpath=//a[@ui-sref="apps.list.managed"]
${Linux_OS}										xpath=//span[contains(text(),'Linux')]/parent::div/preceding-sibling::div
${Windows_OS}									xpath=//span[contains(text(),'Windows')]/parent::div/preceding-sibling::div
${Unknown_OS}									xpath=//span[contains(text(),'Unknown')]/parent::div/preceding-sibling::div
${Activities_of_RGs}							//section[contains(text(),"No activities for Resiliency Group")]
${Replication_Graph}							//div[contains(text(),'Top Resiliency Groups by Replication Lag')]
${Recovery_time_Graph}							//div[contains(text(),"Top Resiliency Groups by Recovery Time")]
${Rehearse_resiliency_group_on_UI}				//div[contains(text(),'${RehearsalRG_activity_msg}')]
${Migrate_resiliency_group_on_UI}				//div[contains(text(),'${MigrateRG_activity_msg}')]
${Takeover_resiliency_group_on_UI}				//div[contains(text(),'${TakeoverRG_activity_msg}')]
${Rehearse_RGs_failed_Homepage}      			xpath=//div[contains(text(),'${RehearsalRG_activity_msg}')]/following-sibling::div[contains(text(),'Failed')]/span[1]
${Rehearse_RGs_successful_Homepage}  			xpath=//div[contains(text(),'${RehearsalRG_activity_msg}')]/following-sibling::div[contains(text(),'Failed')]/span[2]
${Takeover_RGs_failed_Homepage}      			xpath=//div[contains(text(),'${TakeoverRG_activity_msg}')]/following-sibling::div[contains(text(),'Failed')]/span[1]
${Takeover_RGs_successful_Homepage}  			xpath=//div[contains(text(),'${TakeoverRG_activity_msg}')]/following-sibling::div[contains(text(),'Failed')]/span[2]
${Migrate_RGs_failed_Homepage}       			xpath=//div[contains(text(),'${MigrateRG_activity_msg}')]/following-sibling::div[contains(text(),'Failed')]/span[1]
${Migrate_RGs_successful_Homepage}   			xpath=//div[contains(text(),'${MigrateRG_activity_msg}')]/following-sibling::div[contains(text(),'Failed')]/span[2]
${Completed_activities}							xpath=//a[@ui-sref="activities.list.historic"]      
${Activity_Search_Bar}           				xpath=//input[@ng-model="filters.searchKey"]
${Successful_activities}						//div[contains(text(),'Finished')]
${Failed_activities}							//div[contains(text(),'Failed')]

${Activities_page_Button}						xpath=//a[@ng-click="goToCurrentActivities()"]
${More_Views}									xpath=//a[@uib-popover="More Views"]

		
*** Test Cases ***

Verify Resiliency Group counts
	[Documentation]         This test case verifies all the Counts of the RGs 
	...                     like total , At Risk , Normal from Homepage and 
	...                     main table of the RG assests page.
	...						Author : Shaurya Khurana
	
	Goto Home
	Sleep					0.5
	${Total_Home}=			Get RG Total count from Home Page
	${AtRisk_Home}=         Get RG AtRisk count from Home Page
	${Normal_Home}=         Get RG Normal count from Home Page
	
	Goto Assets-RG
	Sleep					0.5
	${total_assetpage}=	    Get RGs Total count in Assets
	${total_assetpage}=	    Convert To String      ${total_assetpage}   
	${AtRisk_assetpage}=    Get RGs AtRisk count in Assets
	${Normal_assetpage}=    Get RGs Normal count in Assets
	
	${ret}=		Run Keyword and Return Status 		Should be Equal         ${Total_Home}       ${total_assetpage}
	Run Keyword If		${ret} == False		Fail		Total RG count does not match
	
	${ret}=		Run Keyword and Return Status 		Should be Equal         ${AtRisk_Home}      ${AtRisk_assetpage}
	Run Keyword If		${ret} == False		Fail		At risk RG count does not match
	
	${ret}=		Run Keyword and Return Status 		Should be Equal         ${Normal_Home}		${Normal_assetpage}
	Run Keyword If		${ret} == False		Fail		Normal RG count does not match

Verify Risks Counts
	[Documentation]         This test case verifies all the counts of the Risks 
	...                     from the Risk Summary of the Homepage and the Values 
	...                     on the Risks Page .
	...						Author : Shaurya Khurana
	
	Goto Home
	${AtRisk_Home}=         Get RG AtRisk count from Home Page
	
	Goto Assets-RG
	${AtRisk_assetpage}=    Get RGs AtRisk count in Assets
	
	${ret}=		Run Keyword and Return Status 		Should be Equal         ${AtRisk_Home}      ${AtRisk_assetpage}
	Run Keyword If		${ret} == False		Fail		At risk RG count does not match
	
	Run Keyword If			${AtRisk_Home}>0 		Test Risks And Warnings	
		
	
Display VMware Counts
	[Documentation]         This test case displays all the counts of the 
	...                     Virtual Machines by Platform and OS 
	...						Author : Shaurya Khurana
	
	Goto Home
	${VM_percent}=          Get VMware percentage from Home Page
	${Linux_count}          Get VM by Linux OS
	${Windows_count}        Get VM by Windows OS
	
	Log    The VMware percentage is: ${VM_percent}
	Log    The VMs usings Linux are: ${Linux_count}
	Log    The VMs usings Windows are: ${Windows_count}
Verify Replication Graph Presence
	[Documentation]         This test case verifies whether the Replication Graph is 
	...                     present according to the Total RG Count presence on the 
	...						Dashboard.
	...						Author : Shaurya Khurana
	
	
	Goto Home
	${graph_present}			Get Matching Xpath Count		${Replication_Graph}
	${RG_count}					get text                        ${RG_total_count_Homepage}
	${RG_count}					Convert to Integer              ${RG_count}
	
	${ret}=		Run Keyword and Return Status 		Should be True         ${RG_count} > 0 and ${graph_present} == 0
	Run Keyword If		${ret} == True		Fail		Graph is not present
	${ret}=		Run Keyword and Return Status 		Should be True         ${RG_count} == 0 and ${graph_present} > 0
	Run Keyword If		${ret} == True		Fail		Graph should not present
	
	
Verify Recovery time Graph Presence
	[Documentation]         This test case verifies whether the Recovery Time Graph
	...                     is present according to the the Total Risk Count presence 
	...                     on the Dashboard.
	...						Author : Shaurya Khurana
	
	Goto Home
	${graph_present}			Get Matching Xpath Count		${Recovery_time_Graph}
	${No_Activities}            Get Matching Xpath Count        ${Activities_of_RGs}
	
	${ret}=		Run Keyword and Return Status 		Should be True         ${No_Activities} == 0 and ${graph_present} == 0
	Run Keyword If		${ret} == True		Fail		Graph is not present
	${ret}=		Run Keyword and Return Status 		Should be True         ${No_Activities} > 0 and ${graph_present} > 0
	Run Keyword If		${ret} == True		Fail		Graph should not present


	
Verify Activity Summary Counts
	[Documentation]         This test case verifies all the Success , Failure and 
	...						Total Counts of the Rehearse , Takeover and Migrate RGs 
	...						on the Activity summary of Dashboard and the Activities Page.
	...						Author : Shaurya Khurana
	

	${No_Activities}            Get Matching Xpath Count        ${Activities_of_RGs}
	Run Keyword If				${No_Activities} == 0			Verify RG Activities 
	
	
*** Keywords ***

Go to Risks Page
	Goto Home
	Click Element    		${Risk_Details_BTN}
	Sleep					0.5

Goto Assets-RG
	Goto Home
	Click Element           ${Assets_RG_Details_BTN}
	Sleep					0.5

Go to Completed Activities	
	Click Element					${More_Views}
	Click Element					${Activities_page_Button}
	Click Element					${Completed_activities}
	Sleep					0.5

Get RG Total count from Home Page
	${Value}=    get text      ${RG_total_count_Homepage}
	[Return]     ${Value}
	
Get RG AtRisk count from Home Page
	${Value}=    get text     ${RG_AtRisk_count_Homepage}
	[Return]     ${Value}
	
Get RG Normal count from Home Page
	${Value}=    get text 	${RG_Normal_count_Homepage}
	[Return]     ${Value}
	
Get Error count in Risk Summary from Home Page
	${Value}=    get text 	${Risk_Summary_Errors_Homepage}
	[Return]     ${Value}
	
Get Warning count in Risk Summary from Home Page
	${Value}=    get text 	${Risk_Summary_Warnings_Homepage}
	[Return]     ${Value}
	
Get VMware percentage from Home Page
	${Value}=    get text 	${VMware%_Homepage}
	[Return]     ${Value}
	
Get VM by Linux OS
	${value}=    get text    ${Linux_OS}
	[Return]     ${value}
	
Get VM by Windows OS
	${value}=    get text    ${Windows_OS}
	[Return]     ${Value}
	
Get VM by Unknown OS
	${value}=    get text    ${Unknown_OS}
	[Return]     ${Value}
	
Get RGs AtRisk count in Assets
	${count}      Get Matching Xpath Count     ${Assets_RGs_AtRisk}
	[Return]     ${count}
	
Get RGs Normal count in Assets
	${count}      Get Matching Xpath Count     ${Assets_RGs_Normal}
	[Return]     ${count}
	
Get RGs Total count in Assets
	${normal}=			Get RGs Normal count in Assets
	${AtRisk}=          Get RGs AtRisk count in Assets
	${total}=           Evaluate	${normal}+${AtRisk}
	[Return]      ${total}
	
Get Error count from Risks page
	${count}      Get Matching Xpath Count     ${Risks_Errors_Risk_Page}
	[Return]     ${count}
	
Get Warning count from Risks page
	${count}      Get Matching Xpath Count     ${Risks_Warnings_Risk_Page}
	[Return]     ${count}
	
	
Get Successful Rehearse RGs count Home Page
	${successful}=		get text 				${Rehearse_RGs_successful_Homepage}
	[Return]			${successful}
	
Get Failed Rehearse RGs count Home Page
	${failed}			get text 				${Rehearse_RGs_failed_Homepage}
	[Return]			${failed}
	
Get total Rehearse RGs count Home Page	
	${successful}=		Get Successful Rehearse RGs count Home Page
	${failed}=			Get Failed Rehearse RGs count Home Page
	${total}=			Evaluate	${successful}+${failed}
	[Return]			${total}

Get Successful Takeover RGs count Home Page
	${successful}=		get text 				${Takeover_RGs_successful_Homepage}
	${successful}=		get text 				${Takeover_RGs_successful_Homepage}
	[Return]			${successful}
	
Get Failed Takeover RGs count Home Page
	${failed}			get text 				${Takeover_RGs_failed_Homepage}
	[Return]			${failed}
	
Get total Takeover RGs count Home Page	
	${successful}=		Get Successful Takeover RGs count Home Page
	${failed}=			Get Failed Takeover RGs count Home Page
	${total}=			Evaluate	${successful}+${failed}
	[Return]			${total}

Get Successful Migrate RGs count Home Page
	${successful}=		get text 				${Migrate_RGs_successful_Homepage}
	[Return]			${successful}
	
Get Failed Migrate RGs count Home Page
	${failed}			get text 				${Migrate_RGs_failed_Homepage}
	[Return]			${failed}
	
Get total Migrate RGs count Home Page	
	${successful}=		Get Successful Migrate RGs count Home Page
	${failed}=			Get Failed Migrate RGs count Home Page
	${total}=			Evaluate	${successful}+${failed}
	[Return]			${total}
	
Test Risks And Warnings	
	Goto Home
	${errors_Home}=         Get Error count in Risk Summary from Home Page
	${warnings_Home}=       Get Warning count in Risk Summary from Home Page
	
	Go to Risks page
	${errors_riskpage}=     Get Error count from Risks page
	${warnings_riskpage}=   Get Warning count from Risks page

	${ret}=		Run Keyword and Return Status 		Should be Equal         ${errors_Home}      ${errors_riskpage}
	Run Keyword If		${ret} == False		Fail		Risk errors count does not match
	
	${ret}=		Run Keyword and Return Status 		Should be Equal         ${warnings_Home}    ${warnings_riskpage}
	Run Keyword If		${ret} == False		Fail		Risk warning count does not match	
		
Input into activity search
	[Arguments]  ${Search_text}
	Input Text On Visible Element    	${Activity_Search_Bar}			   ${Search_text}

Get Failed Activities of Type Activity page
	${count}=	   Get Matching Xpath Count		${Failed_activities}
	[Return]	   ${count}

Get Successful Activities of Type Activity page
	${count}=	   Get Matching Xpath Count		${Successful_activities}
	[Return]	   ${count}

Verify Rehearse RG Activities 

	${status}=		set variable	1
	Goto Home    
	${Rehearse_Rg_successful_count_Home}	Get Successful Rehearse RGs count Home Page	
	${Rehearse_Rg_failed_count_Home}		Get Failed Rehearse RGs count Home Page
	${Rehearse_Rg_total_count_Home}			Get Total Rehearse RGs count Home Page
	
	Go to Completed Activities
	Input into activity search				${RehearsalRG_activity_msg}
	
	${Rehearse_Rg_successful_count_Activities_page_Button}			Get Successful Activities of Type Activity page		
	
	${Rehearse_Rg_failed_count_Activities_page_Button}				Get Failed Activities of Type Activity page			
	
	${Rehearse_Rg_total_count_Activities_page_Button}				Evaluate 		${Rehearse_Rg_successful_count_Activities_page_Button}+${Rehearse_Rg_failed_count_Activities_page_Button}
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Rehearse_Rg_successful_count_Home}==${Rehearse_Rg_successful_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Rehearse resiliency group_activity_name} successful activities do not match
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Rehearse_Rg_failed_count_Home}==${Rehearse_Rg_failed_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Rehearse resiliency group_activity_name} failed activities do not match
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Rehearse_Rg_total_count_Home}==${Rehearse_Rg_total_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Rehearse resiliency group_activity_name} total activities do not match		
Verify Takeover RG Activities 

	${status}=		set variable	1
	Goto Home    
	${Takeover_Rg_successful_count_Home}	Get Successful Takeover RGs count Home Page	
	${Takeover_Rg_failed_count_Home}		Get Failed Takeover RGs count Home Page
	${Takeover_Rg_total_count_Home}			Get Total Takeover RGs count Home Page
	
	Go to Completed Activities
	Input into activity search				${TakeoverRG_activity_msg}
	
	${Takeover_Rg_successful_count_Activities_page_Button}			Get Successful Activities of Type Activity page		
	
	${Takeover_Rg_failed_count_Activities_page_Button}				Get Failed Activities of Type Activity page			
	
	${Takeover_Rg_total_count_Activities_page_Button}				Evaluate 		${Takeover_Rg_successful_count_Activities_page_Button}+${Takeover_Rg_failed_count_Activities_page_Button}
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Takeover_Rg_successful_count_Home}==${Takeover_Rg_successful_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Takeover resiliency group_activity_name} successful activities do not match
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Takeover_Rg_failed_count_Home}==${Takeover_Rg_failed_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Takeover resiliency group_activity_name} failed activities do not match
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Takeover_Rg_total_count_Home}==${Takeover_Rg_total_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Takeover resiliency group_activity_name} total activities do not match	
Verify Migrate RG Activities 

	${status}=		set variable	1
	Goto Home    
	${Migrate_Rg_successful_count_Home}	Get Successful Migrate RGs count Home Page	
	${Migrate_Rg_failed_count_Home}		Get Failed Migrate RGs count Home Page
	${Migrate_Rg_total_count_Home}			Get Total Migrate RGs count Home Page
	
	Go to Completed Activities
	Input into activity search				${MigrateRG_activity_msg}
	
	${Migrate_Rg_successful_count_Activities_page_Button}			Get Successful Activities of Type Activity page		
	
	${Migrate_Rg_failed_count_Activities_page_Button}				Get Failed Activities of Type Activity page			
	
	${Migrate_Rg_total_count_Activities_page_Button}				Evaluate 		${Migrate_Rg_successful_count_Activities_page_Button}+${Migrate_Rg_failed_count_Activities_page_Button}
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Migrate_Rg_successful_count_Home}==${Migrate_Rg_successful_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Migrate resiliency group_activity_name} successful activities do not match
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Migrate_Rg_failed_count_Home}==${Migrate_Rg_failed_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Migrate resiliency group_activity_name} failed activities do not match
	
	${ret}=		Run Keyword and Return Status 		Should be True        ${Migrate_Rg_total_count_Home}==${Migrate_Rg_total_count_Activities_page_Button}
	Run Keyword If		${ret}==False		Fail	${Migrate resiliency group_activity_name} total activities do not match		
	
Verify RG Activities
	
	${Rehearse_count}		Get Matching Xpath Count	${Rehearse_resiliency_group_on_UI}
	${Migrate_count}		Get Matching Xpath Count	${Migrate_resiliency_group_on_UI}
	${Takeover_count}		Get Matching Xpath Count	${Takeover_resiliency_group_on_UI}
	
	Run Keyword If			${Rehearse_count} > 0		Verify Rehearse RG Activities
	Run Keyword If			${Takeover_count} > 0		Verify Takeover RG Activities
	Run Keyword If			${Migrate_count} > 0		Verify Migrate RG Activities