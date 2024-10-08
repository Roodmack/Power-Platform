# This Script will use a Service Principal to Assign to another service Principal to a specific shapoint site


###################################################### Varible ###############################################################

$client_id="" # Azr sharepoint Role Assing Admin
$client_secret=""
$scope="https://graph.microsoft.com/.default"
$tenant_id=""


###################################################### Get Access Token ###############################################################

# Get token Variable
$url="https://login.microsoftonline.com/8a65bfba-9c1f-4702-9474-d85b2f5eb583/oauth2/v2.0/token"

$header=@{content_type="x-www-form-urlencoded"}

$param=@{
    grant_type="client_credentials";
    client_id="";
    client_secret="";
    scope="https://graph.microsoft.com/.default"
}
# Get token
$token=((Invoke-WebRequest -Method Post -Uri $url -Headers $header -Body $param  ).Content | ConvertFrom-Json).access_token
$bearer_token="Bearer $token"
# $bearer_token



###################################################### Liste Site ###############################################################

#List Site Variable
$url="https://graph.microsoft.com/v1.0/sites"

$header=@{
    content_type="x-www-form-urlencoded"
    Authorization =$bearer_token
    Accept= "application/json"
}
# Get Sites
$site_list=(Invoke-WebRequest -Uri $url -Headers $header).Content | ConvertFrom-Json
$site_list.value





###################################################### Assign permission to a select site ###############################################################

#get my Site info 
$mysite= $site_list.value | Where-Object {$_.displayName -like "Demo TO DEL"}

#Create wite Permission to Service Principal "AZR_sharepoint_demo" on "WIKI2AKORD" sharepoint Site
$url="https://graph.microsoft.com/v1.0/sites/$($mysite.id)/permissions"
$header=@{

    
    Authorization =$bearer_token
}
$param = @{
	roles = @(
		"write"
	)
	grantedToIdentities = @(
		@{
			application = @{
				id = "Enter the App ID to assign the Site Select role" #"AZR_sharepoint_demo
				displayName = "App name"
			}
		}
	)
}
# Add permisstion to my select sp site with a spn 
Invoke-WebRequest -Method Post  -Uri $url -Headers $header -Body ($param | ConvertTo-Json -Depth 4) -ContentType "application/json" 


###################################################### get Permission  to a select site ###############################################################

# Select a sharepoint site
$mysite= $site_list.value | Where-Object {$_.displayName -like "WIKI2AKORD"}

#GET /sites/{sitesId}/permissions/{permissionId}
# $url="https://graph.microsoft.com/v1.0/sites/lerevit.sharepoint.com,4171f8fe-572b-4772-ac63-50b91b157ec2,04850d73-a02b-4465-aaa2-f7a4988bd367/permissions" # Demoakor lerevit
$url="https://graph.microsoft.com/v1.0/sites/$($mysite.id)/permissions" 

$header=@{
    content_type="x-www-form-urlencoded";
    Authorization =$bearer_token;
    Accept= "application/json"
}

$result=(Invoke-WebRequest -Method Get  -Uri $url -Headers $header).Content | ConvertFrom-Json
$result
$result |select  -ExpandProperty '@odata.context'



###################################################### get Permission id and details  to a select site ###############################################################

#get permission id
$url="https://graph.microsoft.com/v1.0/sites/$($mysite.id)/permissions"
$header=@{

    content_type="x-www-form-urlencoded"
    Authorization =$bearer_token
}

$permission_list=((Invoke-WebRequest   -Uri $url -Headers $header).Content |ConvertFrom-Json ).value
$permission_list.id

# Get Permission Details
$url="https://graph.microsoft.com/v1.0/sites/$($mysite.id)/permissions/$($permission_list.id)"
$permission_details=((Invoke-WebRequest   -Uri $url -Headers $header).Content |ConvertFrom-Json )
$permission_details




###################################################### Revoke  Permission permission to a select site ###############################################################

# remove permission
$url="https://graph.microsoft.com/v1.0/sites/$($mysite.id)/permissions/$($permission_list.id)"
$header=@{

    content_type="x-www-form-urlencoded"
    Authorization =$bearer_token
}
#remove Permission 
(Invoke-WebRequest -Method Delete   -Uri $url -Headers $header)








###################################################### Liste Site ###############################################################