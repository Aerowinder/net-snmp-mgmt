$service_winsnmp = Get-Service -Name 'SNMP' -ErrorAction SilentlyContinue
$service_winsnmptrap = Get-Service -Name 'SNMPTrap' -ErrorAction SilentlyContinue
if ($service_winsnmp) {
    Write-Host 'Windows SNMP service located...'
    Set-Service $service_winsnmp -StartupType Automatic
    Start-Service $service_winsnmp
}else {
    Write-Host 'ERROR: Windows SNMP service missing...' -ForegroundColor Red
}
if ($service_winsnmptrap) {
    Write-Host 'Windows SNMP Trap service located...'
    Set-Service $service_winsnmptrap -StartupType Manual
}else {
    Write-Host 'ERROR: Windows SNMP Trap service missing...' -ForegroundColor Red
}

$service_netsnmp = Get-Service -Name 'Net-SNMP Agent' -ErrorAction SilentlyContinue
$service_netsnmptrap = Get-Service -Name 'Net-SNMP Trap Handler' -ErrorAction SilentlyContinue
if ($service_netsnmp) {
    Write-Host 'Net-SNMP Agent service found...'
    Stop-Service $service_netsnmp
    Remove-Service $service_netsnmp.Name
}
if ($service_netsnmptrap) {
    Write-Host 'Net-SNMP Trap Handler service found...'
    Stop-Service $service_netsnmptrap
    Remove-Service $service_netsnmptrap.Name
}

Write-Host 'Net-SNMP services have been removed. Windows SNMP services have been restored to default configuration unless otherwise noted.'
Write-Host
