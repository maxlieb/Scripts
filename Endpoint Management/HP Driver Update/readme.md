### HP Driver and BIOS update script

Silent, automatic, can be utilized during SCCM OSD and Autopilot or run periodically.

Based on [Automatically install the latest HP drivers during Autopilot provisioning](https://msendpointmgr.com/2020/09/10/automatically-install-the-latest-hp-drivers-during-autopilot-provisioning/)
Slightly modified for bios updates support

**USAGE**: just run the .cmd file or invoke the Powershell with  -RunMode Stage

```powershell
. .\Invoke-HPDriverUpdateWithBios.ps1 -RunMode Stage
```

```bash
%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -ep bypass -file "%~dp0Invoke-HPDriverUpdateWithBios.ps1" -RunMode Stage
```
