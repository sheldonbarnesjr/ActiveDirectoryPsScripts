# Define the OU to search in
$OU = "OU=Management,DC=mydomain,DC=com"

# Specify the path for the CSV file
$csvPath = "C:\Users\a-sbarnes\Desktop\useraccountsdata.csv"

# Generate a report of all users in the specified OU
Get-ADUser -Filter * -Properties * -SearchBase $OU | 
 Select-Object Name, SamAccountName, Enabled, LastLogonDate | 
 Export-Csv $csvPath -NoTypeInformation

Write-Host "Report generated and saved to $csvPath"
