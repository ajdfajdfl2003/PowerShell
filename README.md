# PowerShell
> 記錄平常會用到的 Script

## Task Schedule
### Feature
- 新增排程，排程的執行身份是 gMSA，且執行時間為每天每分鐘

## Manage Printer
> - Use [Add-LHSPrinterPermissionSDDL](https://gallery.technet.microsoft.com/scriptcenter/Add-Printer-Permission-c0ece1f3) to generate Add SDDL String.
> - Use [Remove-LHSPrinterPermissionSDDL](https://gallery.technet.microsoft.com/scriptcenter/Removing-Printer-Permission-5ff5bb37) to generate Remove SDDL String.

### Feature
- 針對多個使用者（群組）新增權限到 單一印表機。
- 針對多個使用者（群組）移除權限到 單一印表機。

## Change Log
- 2017/07/07
  - 新增排程，排程的執行身份是 gMSA，且執行時間為每天每分鐘
- 2017/05/04
  - 重構擷取套用 SDDL 到另外一塊模組。
  - 單一改變成多個（用 Array 的方式）。

- 2017/05/03
  - 針對單一使用者（群組）新增權限到 單一印表機。
  - 針對單一使用者（群組）移除權限到 單一印表機。