import csv
import sys
import pandas as pd
from os import path
def get_upgrade_no():
	
	try:
		if(path.exists("upgrade_no.txt")):
			f=open("upgrade_no.txt")
			num=f.read()
			f.close()
		else:
			f=open("upgrade_no.txt",'w')
			f.write("-1")
			f.close()
			num=-1;
		return num;
	except:
		return 0;
		
		
def set_and_return_upgrade_no():
	
	try:
		num=int(get_upgrade_no())
		f=open("upgrade_no.txt",'w')
		num+=1
		f.write(str(num))
		f.close()
		return num
	except:
		print "Upgrade number not upgraded in 'upgrade_no.txt' "
		
def update_CSV(csv_filename, list_of_variables,list_of_values):
	
		
	try:
		file = pd.read_csv(csv_filename)
		file.to_csv(csv_filename)
		l1=list_of_variables
		l2=list_of_values
		upgrade_no=set_and_return_upgrade_no()
		col_name="upgrade "+str(upgrade_no)
		file[col_name]=""
		
		mydic=file.set_index('heading').to_dict()
		print(mydic)
		for i in range(len(l1)):
			mydic[col_name][l1[i]]=l2[i]
		data=pd.DataFrame.from_dict(mydic)
		data.index.name="heading"
		for i in range(1,upgrade_no+1):
			col="upgrade "+str(i)
			data[col].fillna(-99,inplace=True)
		data.to_csv(csv_filename)
	except:
		e = sys.exc_info()[0]
		print(e)
		return  "Upadte operation failed\n1.Close the excel file.\n2.Check your Internet connection"
	else:
		return "Successful"

def check_values_for_upgrades(csv_filename):
	
	heading_list=[]
	match_list=[]
	fail=0
	try:
		upgrade_no=int(get_upgrade_no())
		if(upgrade_no>0):
			upgrade_no1=upgrade_no-1
			upgrade_no2=upgrade_no
			file = pd.read_csv(csv_filename)
			col_name1="upgrade "+str(upgrade_no1)
			col_name2="upgrade "+str(upgrade_no2)
			
			mydic=file.set_index('heading').T.to_dict()
			
			heading_list=(list(mydic))
			no_of_mismatches=0
			for i in range(len(list(mydic))):
				
				if(mydic[list(mydic)[i]][col_name1]!=mydic[list(mydic)[i]][col_name2]):
					no_of_mismatches+=1
					fail=1
					match_list.append(False)
				else:
					match_list.append(True)
			print "No of mismatches are : " , no_of_mismatches
			
			display_report(heading_list,match_list)
				
		else:
			print " Values are not verified"
			
	except:
		e = sys.exc_info()[0]
		print(e)
		return "Check operation failed"
	else:
		if(fail==0):
			return "Successful"
		else:
			return "Failed"

def display_report(heading_list,match_list):
	f=open("Dashboard_report.html",'w')
	mes='''
		<!DOCTYPE html>
			<html lang="en" >
			<head>
			  <title>Dashboard Report</title>
			  <meta charset="utf-8">
			  <meta name="viewport" content="width=device-width, initial-scale=1">
			  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
			  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
			  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
			</head>
			<body background="https://stmed.net/sites/default/files/color-wallpapers-30653-4694233.jpg">
			 
			<div class="container">
			  <h2>Dashboard Report</h2>


				<div class="panel panel-success">
				  <div class="panel-heading">Counts Matched</div>'''
				  
	for i in range(len(heading_list)):
		if(match_list[i]==True):
			mes+="<div class='panel-body'>"+str(heading_list[i])+"</div>"
	mes+=  '''</div>
			<div class="panel panel-danger">
			<div class="panel-heading">Counts that didnt match</div>'''
	for i in range(len(heading_list)):
		if(match_list[i]==False):
			mes+="<div class='panel-body'>"+str(heading_list[i])+"</div>"
	
	mes+=	''' </div>
	
				  </div>
				</div>

				</body>
				</html>'''
	f.write(mes)
	f.close()

	

'''		
	
#file_name="sk32.csv"

########	Update 1 	###########
#l1=['a','b','c']
#l2=[1,2,3]

upgrade_no=1
update_CSV(file_name,l1,l2)


#######		Update 2	##########
l1=["RG_Total","RG_AtRisk","RG_Normal","VBS"]
l2=[1,2,6,4]
upgrade_no=2
#update_CSV(file_name,upgrade_no,l1,l2)

#######		Verify Values	#######
upgrade_no1=1
upgrade_no2=2
check_values_for_upgrades(file_name,upgrade_no1,upgrade_no2)

######		Update 3
l1=["RG_Total","RG_AtRisk","Risk","VBS"]
l2=[1,2,3,6]
upgrade_no=3
update_CSV(file_name,upgrade_no,l1,l2)
'''
