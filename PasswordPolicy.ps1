 # Import the Active Directory module
 Import-Module ActiveDirectory

 # Define the name of the new password policy
 $newPolicyName = "newtestpolicy"

 # Define the password policy settings for the new policy
 $passwordPolicySettings = @{
     "ComplexityEnabled" = $true
     "MinimumLength" = 8
     "MaxPasswordAge" = "30.00:00:00" # Setting for 30 days
     "LockoutDuration" = "00:30:00" # 30 minutes
     "LockoutThreshold" = 5
     "LockoutObservationWindow" = "00:15:00" # 15 minutes
     # Add additional settings as needed
 }

 # Set the precedence value for the policy
 $precedence = 1

 try {
     # Create the Fine-Grained Password Policy
     $newPolicy = New-ADFineGrainedPasswordPolicy -Name $newPolicyName `
         -ComplexityEnabled $passwordPolicySettings["ComplexityEnabled"] `
         -MinPasswordLength $passwordPolicySettings["MinimumLength"] `
         -MaxPasswordAge $passwordPolicySettings["MaxPasswordAge"] `
         -LockoutDuration $passwordPolicySettings["LockoutDuration"] `
         -LockoutThreshold $passwordPolicySettings["LockoutThreshold"] `
         -LockoutObservationWindow $passwordPolicySettings["LockoutObservationWindow"] `
         -Precedence $precedence

     # Check if the policy was created successfully
     if ($newPolicy) {
         Write-Host "Fine-Grained Password Policy '$newPolicyName' created successfully."
     } else {
         Write-Host "Failed to create the Fine-Grained Password Policy."
     }
 } catch {
     Write-Host "An error occurred: $_"
 }
