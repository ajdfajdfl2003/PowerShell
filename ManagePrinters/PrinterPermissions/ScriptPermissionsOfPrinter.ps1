function Get-Script-Directory
{
    $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
    return Split-Path $scriptInvocation.MyCommand.Path
}

Write-Host "==================================="
Write-Host ""
Write-Host "1. 執行 Script 的機器如果有操作到網域帳號或是群組，就必須要加入網域。" -ForegroundColor Cyan
Write-Host "2. 執行的時候要以系統管理員的身分執行。" -ForegroundColor Cyan
Write-Host ""
Write-Host "==================================="

$confirmation = Read-Host "上述注意事項閱讀完畢? [y/n]"
while($confirmation -ne "y")
{
    $confirmation = Read-Host "上述注意事項閱讀完畢? [y/n]"
}

[int]$InstalledCount=0

#模組
$CustomModule=@("PrinterPermissionSDDL","UserPermissionToPrinter")

foreach($module in $CustomModule)
{
    # 檢查模組是否存在
    Write-Host "==================================="
    Write-Host ""
    Write-Host "    Check Module $module if Installed" -ForegroundColor DarkCyan
        $CheckCount=Get-Module | Where-Object Name -EQ $module | measure | select count
        if($CheckCount.Count -eq 1)
        {
            Write-Host "    Removing $module" -ForegroundColor DarkCyan
            #存在的話移除
            Remove-Module $module
        }
    Write-Host ""
    Write-Host "==================================="

    $PackagePath=Get-Script-Directory

    $PutModule=$env:USERPROFILE+"\Documents\WindowsPowerShell\Modules\"+$module
    #刪除舊的模組檔案
    if(Test-Path -Path $PutModule)
    {
        Remove-Item -Path $PutModule -Recurse
    }

    #新增新的模組檔案
    if( -Not (Test-Path -Path $PutModule ) )
    {
        New-Item -ItemType directory -Path $PutModule
    }

    $PrinterPermissionModule=$PackagePath+"\"+$module+".psm1"

    if(Test-Path -Path $PrinterPermissionModule)
    {
        Copy-Item $PrinterPermissionModule $PutModule
    }
    
    $tmp = Get-Module -ListAvailable | Where-Object Name -EQ $module | measure | select count

    if($tmp.Count -eq 1)
    {
        Write-Host "==================================="
        Write-Host ""
        Write-Host "    Installed Module $module" -ForegroundColor DarkCyan
            Import-Module $module
        Write-Host ""
        Write-Host "==================================="
    }

    $InstalledCount += $tmp.Count
}

if($InstalledCount -eq 2)
{
    #印表機在哪一台機器上
    $WhereIsThePrinter=$env:COMPUTERNAME
    $eachPrinter=Get-Printer -ComputerName $WhereIsThePrinter
    
    #設定印表機名稱
    $IWantToFindThePrinter="Fax"

    $Target= $eachPrinter | Where-Object Name -eq $IWantToFindThePrinter
    $TargetName=$Target.Name
    
    Write-Host "==================================="
    Write-Host "我要設定的印表機是"
    Write-Host $TargetName -ForegroundColor Cyan
    Write-Host "==================================="

    #設定使用者或群組
    $Users=@("DC01\FCRFS","Dc01\angus")
    $Groups=@("DC01\PWAdmin","DC01\Fax Users")
    if($TargetName)
    {
        foreach($user in $Users)
        {
            Add-PermissionToPrinter $user $WhereIsThePrinter $TargetName
        }
        foreach($user in $Users)
        {
            Remove-PermissionFromPrinter $user $WhereIsThePrinter $TargetName
        }
        foreach($group in $Groups)
        {
            Add-PermissionToPrinter $group $WhereIsThePrinter $TargetName
        }
        foreach($group in $Groups)
        {
            Remove-PermissionFromPrinter $group $WhereIsThePrinter $TargetName
        }
    }else
    {
        Write-Host ""
        Write-Host "找不到你要設定的印表機。" -ForegroundColor Red
    }
}else
{
        Write-Host ""
        Write-Host "找不到自定義的 Module。" -ForegroundColor Red
}
