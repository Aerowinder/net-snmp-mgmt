if (Test-Path -Path 'C:\Program Files\Net-SNMP\bin\snmpd.exe') {
    Write-Host 'Net-SNMP directory located...'
}
else {
    Write-Host 'ERROR: Net-SNMP directory missing, exiting...' -ForegroundColor Red
    exit #Exit script if Net-SNMP folder is not detected.
}

$service_winsnmp = Get-Service -Name 'SNMP' -ErrorAction SilentlyContinue
$service_winsnmptrap = Get-Service -Name 'SNMPTrap' -ErrorAction SilentlyContinue
if ($service_winsnmp) {
    Write-Host 'Windows SNMP service located, disabling...'
    Stop-Service $service_winsnmp
    Set-Service $service_winsnmp -StartupType Disabled
}else {
    Write-Host 'ERROR: Windows SNMP service missing, exiting...' -ForegroundColor Red
    exit #Exit script if service is not detected.
}
if ($service_winsnmptrap) {
    Write-Host 'Windows SNMP Trap service located, disabling...'
    Stop-Service $service_winsnmptrap
    Set-Service $service_winsnmptrap -StartupType Disabled
}else {
    Write-Host 'ERROR: Windows SNMP Trap service missing, exiting...' -ForegroundColor Red
    exit #Exit script if service is not detected.
}


$service_netsnmp = Get-Service -Name 'Net-SNMP Agent' -ErrorAction SilentlyContinue
$service_netsnmptrap = Get-Service -Name 'Net-SNMP Trap Handler' -ErrorAction SilentlyContinue
if ($service_netsnmp) {
    Write-Host 'Existing Net-SNMP Agent service found, removing...'
    Stop-Service $service_netsnmp
    Remove-Service $service_netsnmp.Name
}
if ($service_netsnmptrap) {
    Write-Host 'Existing Net-SNMP Trap Handler service found, removing...'
    Stop-Service $service_netsnmptrap
    Remove-Service $service_netsnmptrap.Name
}


$create_netsnmp = @{
    Name = 'Net-SNMP Agent'
    BinaryPathName = '"C:\Program Files\Net-SNMP\bin\snmpd.exe" -service'
    DisplayName = 'Net-SNMP Agent'
    StartupType = 'Automatic'
    Description = 'SNMPv2c / SNMPv3 command responder from Net-SNMP'
}

$create_netsnmptrap = @{
    Name = 'Net-SNMP Trap Handler'
    BinaryPathName = '"C:\Program Files\Net-SNMP\bin\snmptrapd.exe" -service'
    DisplayName = 'Net-SNMP Trap Handler'
    StartupType = 'Disabled'
    Description = 'SNMPv2c / SNMPv3 trap/inform receiver from Net-SNMP'
}

Write-Host 'Creating Net-SNMP Agent service...'
New-Service @create_netsnmp | Out-Null
Write-Host 'Creating Net-SNMP Trap Handler service...'
New-Service @create_netsnmptrap | Out-Null
Write-Host 'Starting Net-SNMP Agent service...'
Start-Service 'Net-SNMP Agent'
Write-Host
