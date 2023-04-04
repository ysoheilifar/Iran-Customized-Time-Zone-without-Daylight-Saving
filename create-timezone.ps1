# Define Variables
$key_path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones"
$key_name = "IR Standard Time"
$display_name = "(UTC+03:30) IR Standard Time"
$dlt = "IR Daylight Time"
$std = "IR Standard Time"
$mui_display = "-"
$mui_dlt = "-"
$mui_std = "-"

# Create the new time zone key and subkeys
New-Item -Path "$key_path\$key_name" -Force | Out-Null

# Set the display name for the new time zone
Set-ItemProperty -Path "$key_path\$key_name" -Name "Display" -Value $display_name
Set-ItemProperty -Path "$key_path\$key_name" -Name "MUI_Display" -Value $mui_display

# Set the standard and daylight saving time values
Set-ItemProperty -Path "$key_path\$key_name" -Name "Dlt" -Value $dlt
Set-ItemProperty -Path "$key_path\$key_name" -Name "Std" -Value $std
Set-ItemProperty -Path "$key_path\$key_name" -Name "MUI_Dlt" -Value $mui_dlt
Set-ItemProperty -Path "$key_path\$key_name" -Name "MUI_Std" -Value $mui_std

# Set the timezone binary value
$tziHexValue = "2e-ff-ff-ff-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
$byteArray = $tziHexValue -split "-" | ForEach-Object { [byte]([convert]::ToInt32($_, 16)) }
New-ItemProperty -Path "$key_path\$key_name" -Name TZI -Value $byteArray -PropertyType Binary -Force | Out-Null

# Set the time zone information
tzutil /s $key_name
