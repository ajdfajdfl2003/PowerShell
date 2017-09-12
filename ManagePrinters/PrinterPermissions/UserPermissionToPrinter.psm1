Function Add-PermissionToPrinter
{
[cmdletbinding(  
    ConfirmImpact = 'Low',
    SupportsShouldProcess = $false
)]
param(
    [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$False,
        HelpMessage='A Security Group or User like "Domain\GroupName" or "Domain\UserName"')]
    [String]$GroupOrUser,
    [Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$False)]
    [String]$WhereIsThePrinter,
    [Parameter(Position=2,Mandatory=$True,ValueFromPipeline=$False)]
    [String]$Printer
)

BEGIN {

    Set-StrictMode -Version Latest

    ${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name


} # end BEGIN

PROCESS {

    try 
    {
        $PermissionSDDL=Get-Printer -Full -ComputerName $WhereIsThePrinter -Name $Printer | select PermissionSDDL -ExpandProperty PermissionSDDL

        Write-Host "Adding $GroupOrUser To $Printer" -ForegroundColor Magenta
        
        $newAddSDDL = Add-LHSPrinterPermissionSDDL -Account $GroupOrUser -existingSDDL $PermissionSDDL

        if($newAddSDDL)
        {
            Get-Printer -Full -ComputerName $WhereIsThePrinter -Name $Printer | Set-Printer -PermissionSDDL $newAddSDDL -Verbose
        }else
        {
            Write-Host "Adding Failed, AddSDDL String is null." -ForegroundColor Red
        }
    }
    catch [Exception] 
    {
        Write-Error -Message "Failed To Generate SDDL (review inner exception):`n $_.Message" `
            -Exception $_.Exception
    }
} # end PROCESS

END { Write-Verbose "Function ${CmdletName} finished." }
} #end Function Add-PermissionToPrinter

Function Remove-PermissionFromPrinter
{
[cmdletbinding(  
    ConfirmImpact = 'Low',
    SupportsShouldProcess = $false
)]
param(
    [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$False,
        HelpMessage='A Security Group or User like "Domain\GroupName" or "Domain\UserName"')]
    [String]$GroupOrUser,
    [Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$False)]
    [String]$WhereIsThePrinter,
    [Parameter(Position=2,Mandatory=$True,ValueFromPipeline=$False)]
    [String]$Printer
)

BEGIN {

    Set-StrictMode -Version Latest

    ${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name


} # end BEGIN

PROCESS {

    try 
    {
        $PermissionSDDL=Get-Printer -Full -ComputerName $WhereIsThePrinter -Name $Printer | select PermissionSDDL -ExpandProperty PermissionSDDL

        Write-Host "Removing $GroupOrUser To $Printer" -ForegroundColor Magenta
        
        $newRemoveSDDL = Remove-LHSPrinterPermissionSDDL -Account $GroupOrUser -existingSDDL $PermissionSDDL

        if($newRemoveSDDL)
        {
            Get-Printer -Full -ComputerName $WhereIsThePrinter -Name $Printer | Set-Printer -PermissionSDDL $newRemoveSDDL -Verbose
        }else
        {
            Write-Host "Removing Failed, RemoveSDDL String is null." -ForegroundColor Red
        }
    }
    catch [Exception] 
    {
        Write-Error -Message "Failed To Generate SDDL (review inner exception):`n $_.Message" `
            -Exception $_.Exception
    }
} # end PROCESS

END { Write-Verbose "Function ${CmdletName} finished." }
} #end Function Remove-PermissionFromPrinter

Export-ModuleMember Add-PermissionToPrinter , Remove-PermissionFromPrinter