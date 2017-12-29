Get-Printer
$PrinterName = Read-Host 'Enter printer name as above of list'

$PrinterInstance = [wmi]"\\.\root\cimv2:Win32_Printer.DeviceID='$PrinterName'"
$PrinterInstance.PrintTestPage()