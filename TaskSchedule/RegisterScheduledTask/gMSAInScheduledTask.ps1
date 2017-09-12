# Here is a article that explain why we set schedule in PowerShell
# Link: https://blogs.technet.microsoft.com/askpfeplat/2012/12/16/windows-server-2012-group-managed-service-accounts/
# Set a task name
$TaskName = "test"

# Clear the task with the same name
Unregister-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue -Confirm:$false

# Set scheduled task action
# You can set the action you want in this task scheduled
$action = New-ScheduledTaskAction –Execute “ C:\tmp\test.exe"

# Set trigger of task
# This trigger will start after 30 seconds
$trigger = New-ScheduledTaskTrigger -Daily -At (Get-Date).AddSeconds(30)

# Set the settings of task
# If os miss ur schedule, rearrange it ASAP.
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable

# Assign task principal
# Use gMSA account
# -LogonType's parameter, Password, will let schedule task to get password in Domain Controller
$principal = New-ScheduledTaskPrincipal -UserID DC\gMSAAccount$ -LogonType Password -RunLevel Highest

# Bind scheduled task
$Task = New-ScheduledTask –Action $action –Trigger $trigger –Principal $principal -Settings $settings

# Register scheduled task
Register-ScheduledTask $TaskName -InputObject $Task

<###
    There is few link that could read.
    - https://www.petri.com/creating-repeating-powershell-scheduled-jobs
    - https://blogs.technet.microsoft.com/platformspfe/2015/10/26/configuring-advanced-scheduled-task-parameters-using-powershell/

    If you want to set a repeating scheduled jobs, you could use script as below.
###>
$ModifyTask = Get-ScheduledTask -TaskName $TaskName
$ModifyTask.Triggers.Repetition.Duration = "P1D"
$ModifyTask.Triggers.Repetition.Interval = "PT1M"
$ModifyTask.Settings
$ModifyTask | Set-ScheduledTask
