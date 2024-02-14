$service_winsnmp = Get-Service -Name 'SNMP' -ErrorAction SilentlyContinue
$service_winsnmptrap = Get-Service -Name 'SNMPTrap' -ErrorAction SilentlyContinue
if ($service_winsnmp) {Stop-Service $service_winsnmp}
if ($service_winsnmptrap) {Stop-Service $service_winsnmptrap}

Write-Host 'Removing Windows SNMP services.'
Remove-WindowsCapability -Online -Name “SNMP.Client~~~~0.0.1.0“

Write-Host 'Removing Net-SNMP services.'
$service_netsnmp = Get-Service -Name 'Net-SNMP Agent' -ErrorAction SilentlyContinue
$service_netsnmptrap = Get-Service -Name 'Net-SNMP Trap Handler' -ErrorAction SilentlyContinue
if ($service_netsnmp) {Stop-Service $service_netsnmp; Remove-Service $service_netsnmp.Name}
if ($service_netsnmptrap) {Stop-Service $service_netsnmptrap; Remove-Service $service_netsnmptrap.Name}

Write-Host 'Removing firewall rules.'
Remove-NetFirewallRule -DisplayName '_Net-SNMP Agent (UDP)' -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName '_Net-SNMP Trap Handler (UDP)' -ErrorAction SilentlyContinue

Write-Host 'Windows SNMP and Net-SNMP services have been removed. A restart may be required, see above.'
Write-Host
