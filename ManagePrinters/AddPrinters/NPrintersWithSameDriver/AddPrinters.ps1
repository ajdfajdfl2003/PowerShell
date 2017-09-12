function GetPrinterPortsList
{
    $printerports = Get-PrinterPort;
    $menu = @{};

    for($i=1; $i -le $printerports.count; $i++)
    {
        Write-Host "$i. [$($printerports[$i-1].Description)] $($printerports[$i-1].name)";
        $menu.Add($i,($printerports[$i-1].name));
    }
    return $menu;
}

function GetSelectionPrinterPort
{
    do{
        $numOK = $false
        try{
            Write-Host;
            Write-Host "====== Select Printer Port ======";

            $menu = GetPrinterPortsList;
            [int]$ans = Read-Host 'Enter selection';

            if($ans -le 0 -or $ans -gt $menu.Count){ throw exception; }
        
            $SelectionOfPrinterPort = $menu.Item($ans);
        }catch{
            $numOK = $true;
            cls
        }
    }while($numOK);

    Write-Host "====== Select Printer Port ======";
    Write-Host;

    return $SelectionOfPrinterPort;
}

function GetPrinterDriversList
{   
    $drivers = Get-PrinterDriver;
    $menu = @{};

    for ($i=1;$i -le $drivers.count; $i++) 
    { 
        Write-Host "$i. [$($drivers[$i-1].Manufacturer)] $($drivers[$i-1].name)";
        $menu.Add($i,($drivers[$i-1].name));
    }
    
    return $menu;
}

function GetSelectionPrinterDriver
{
    do{
        $numOK = $false
        try{
            Write-Host;
            Write-Host "====== Select Printer Driver ======";

            $menu = GetPrinterDriversList;
            [int]$ans = Read-Host 'Enter selection';

            if($ans -le 0 -or $ans -gt $menu.Count){ throw exception; }
        
            $SelectionOfPrinterDriver = $menu.Item($ans);
        }catch{
            $numOK = $true;
            cls
        }
    }while($numOK);

    Write-Host "====== Select Printer Driver ======";
    Write-Host;

    return $SelectionOfPrinterDriver;
}

$driver = GetSelectionPrinterDriver;
$port = GetSelectionPrinterPort;

do{
    $IsOK = $false;
    try{
        Write-Host "======================================";
        Write-Host "設定新增印表機名稱的範本以及數量";
        Write-Host "例如：設定「我是印表機」、3台";
        Write-Host
        Write-Host "結果：「我是印表機-1」、「我是印表機-2」...以此類推";
        Write-Host "======================================";
        Write-Host

        $nameOfPrinter = Read-Host "Enter template name of printer";
        [int]$totalOfPrinter = Read-Host "Enter total of printer";
        for($i=1; $i -le $totalOfPrinter; $i++)
        {
            $CheckIfExists = Get-Printer | Where-Object {$_.Name -eq "$nameOfPrinter-$i"}
            if($CheckIfExists){
                Write-Host "$nameOfPrinter-$i 已存在，跳過新增！";
            }else{
                Add-Printer -Name "$nameOfPrinter-$i" -DriverName $driver -PortName $port -Shared;
                Write-Host "已新增 $nameOfPrinter-$i！";
            }
        }
    }catch{
        $IsOK=$true;
        cls
    }
}while($IsOK);

Get-Printer;
Read-Host "Please press any key";