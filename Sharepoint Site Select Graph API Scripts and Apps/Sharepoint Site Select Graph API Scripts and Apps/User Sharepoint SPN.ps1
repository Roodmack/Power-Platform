# This Script will verify the Access to a specific sharepoint site for a service principal

###################################################### Get-Token ###############################################################
# Variable
$app_name="Your App ID Dsiplay Name"
$client_id="" # Azr Sharepoint Demo
$client_secret=""
$tenant_id=""

#get token 
$url="https://login.microsoftonline.com/$($tenant_id)/oauth2/v2.0/token"
$header=@{

    content_type="x-www-form-urlencoded"
}
$param=@{
    grant_type="client_credentials";
    client_id=""; # Azr Sharepoint Demo
    client_secret="";
    scope="https://graph.microsoft.com/.default"
}

$token=((Invoke-WebRequest -Method Post -Uri $url -Headers $header -Body $param  ).Content | ConvertFrom-Json).access_token  #| Set-Clipboard -PassThru

$bearer_token="Bearer $token"
# $bearer_token












###################################################### List Sharepoint Site that can access this SPN ########################################################
# This Option is will not list any sp site by id , please get the Sharepoint ID
$site_id="enter your Sharepoint  site id" # Demo to Del Site
$url="https://graph.microsoft.com/v1.0/sites/$site_id"
$header=@{
    content_type="x-www-form-urlencoded";
    Authorization =$bearer_token;
    Accept= "application/json"
}
$header.Autorization
$site_list=(Invoke-WebRequest -Uri $url -Headers $header).Content | ConvertFrom-Json
$site_list.value | Where-Object { $_.name -like "*$($sitename)*"}

$site_list






###################################################### Get Drive ID, or Get doc lib of the SP site ###############################################################
# get drive id from site with site_id
$url="https://graph.microsoft.com/v1.0/sites/$($site_id)/drives"
$drive=((Invoke-WebRequest -Uri $url -Headers $header).Content | ConvertFrom-Json).value
$drive
# $driveid="Replace this ID by your Drive ID" # Document
# $driveid2="Replace this ID by your Drive" # My October Lib















###################################################### Upload File to Document Lib inside folder V1 ###############################################################

# Variable
$driveid     = "b!qYqyajePL0-1_pbFAdBD1y290cV5_89DmqXwnTc1qI2_v9boIaFPRYQXxqhRyTJ0" # My October Lib
$folder= "Process"
$folder_file = "Polo/myprocess4.json"
$filename= "myprocess.json"
$data= Get-Process | select -First 20 | ConvertTo-Json -Depth 4
$site_id= "Enter your sharepoint id here"

#$uploadUrl = "https://graph.microsoft.com/v1.0/sites/$siteId/drives/$driveId/root:/$filePath:/content" 
$upload_url = "https://graph.microsoft.com/v1.0/sites/$($site_id)/drives/$($driveid)/root:/$($folder_file):/content" # post url


$header=@{
    Accept= "application/json";
    content_type="text/plain";
    Authorization =$bearer_token
}

# Upload file
Invoke-WebRequest -Method Put -Uri $upload_url -Headers $header -Body $data -ContentType "text/plain"














###################################################### Upload File to Document Lib inside folder V1 ###############################################################

$driveid2="b!qYqyajePL0-1_pbFAdBD1y290cV5_89DmqXwnTc1qI3xc_8-X5GCQoEWb5Jtk9RJ" # My October Lib
# Variable
$folder="Process"
$folder_file="Process/myprocess.json"
$filename="myprocess.json"
$data= Get-Process | select -First 20 | ConvertTo-Json
$site_id="Enter your sharepoint id here"

# Send file to sharepoint
#PUT https://graph.microsoft.com/v1.0/sites/{site-id}/drives/{drive-id}/root:/{folder-path}/{file-name}:/content
$upload_url = "https://graph.microsoft.com/v1.0/sites/$($site_id)/drives/$($driveid2)/root:/$($folder)/$($filename):/content"


$header=@{
    Accept= "application/json";
    content_type="text/plain";
    Authorization =$bearer_token
}

# Upload file
Invoke-WebRequest -Method Put -Uri $upload_url -Headers $header -Body $data -ContentType "text/plain"

















