# PowerShell
> 記錄平常會用到的 PowerShell

## Task Schedule
### Feature
- 新增排程，排程的執行身份是 gMSA，且執行時間為每天每分鐘。

## Manage Printer
> - Use [Add-LHSPrinterPermissionSDDL](https://gallery.technet.microsoft.com/scriptcenter/Add-Printer-Permission-c0ece1f3) to generate Add SDDL String.
> - Use [Remove-LHSPrinterPermissionSDDL](https://gallery.technet.microsoft.com/scriptcenter/Removing-Printer-Permission-5ff5bb37) to generate Remove SDDL String.

### Feature
- 針對多個使用者（群組）新增權限到 單一印表機。
- 針對多個使用者（群組）移除權限到 單一印表機。
- 使用選擇的 Driver 和 PrinterPort 以及設定的名稱範本，以數字遞增的方式來新增印表機。
- 選擇列表中特定一台機器送出測試頁

## Change Log
- 2017/12/29
  - 選擇列表中特定一台機器送出測試頁

- 2017/09/12
  - 使用選擇的 Driver 和 PrinterPort 以及設定的名稱範本，以數字遞增的方式來新增印表機。

- 2017/07/07
  - 新增排程，排程的執行身份是 gMSA，且執行時間為每天每分鐘。

- 2017/05/04
  - 重構擷取套用 SDDL 到另外一塊模組。
  - 單一改變成多個（用 Array 的方式）。

- 2017/05/03
  - 針對單一使用者（群組）新增權限到 單一印表機。
  - 針對單一使用者（群組）移除權限到 單一印表機。
