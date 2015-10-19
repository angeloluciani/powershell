# powershell
powershell scripts


global_value_item_property.ps1

get from popipopi.txt the strings relate get-item

```
  get-item 2001 | get-property "values['RemitNotificationStep']" | equals "" | verify-true
  get-item 2001 | get-property "values['CpidCodeType']" | equals "*LEI" | verify-true
  get-item 2001 | get-property "values['LoadType']" | equals "*BL" | verify-true
  get-item 2001 | get-property "values['OtherCPEEA']" | equals No | verify-true
  get-item 2001 | get-property "values['Deleted']" | equals No | verify-true
  get-item 2001 | get-property "values['VenueOfExecution']" | equals XXXX | verify-true
  get-item 2001 | get-property "values['CommercialorTreasury']" | equals Yes | verify-true
  ```   
return in the result.txt the global values you can insert in rcptt

```   
global [val property_CpDomicile "values['CpDomicile']"]
global [val property_ModifyUser "values['ModifyUser']"]
global [val property_EmirNotificationStep "values['EmirNotificationStep']"]
global [val property_TradeStartDate "values['TradeStartDate']"]
global [val property_Regulation Set "values['Regulation Set']"]
global [val property_ExecutionDate "values['ExecutionDate']"]
global [val property_BeneficiaryId "values['BeneficiaryId']"]
global [val property_EmirReportMode "values['EmirReportMode']"]
```


