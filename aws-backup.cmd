:: This script snapshots all volumes that area attached to all EC2 instances in the region
::
:: This script is based on http://sehmer.blogspot.co.nz/2013/02/update-amazon-ec2-daily-snapshot.html
:: by Sehmer.

:: Set login details
set AWS_ACCESS_KEY=<access-key-here>
set AWS_SECRET_KEY=<secret-key-here>

:: Set Region
set EC2_URL=https://ec2.us-east-1.amazonaws.com

:: Java home directory just under the bin for java.exe 
set JAVA_HOME="C:\Program Files\Java\jre1.8.0_151"

:: Path for AWS home directory
set AWS_HOME=C:\AWS

:: Path to EC2 API and subfolder of bin
set EC2_HOME=%AWS_HOME%\ec2-api-tools-1.6.7.3
set PATH=%PATH%;%EC2_HOME%\bin


:: Create a snapshot for every attached volume to every instance


:: Create a file with all attached volumes
ec2-describe-volumes|find /i "attached">%AWS_HOME%\Working\ActiveVolumes.txt

:: Create a file with all instances
ec2-describe-instances|find /i "TAG"|find /i "Name">%AWS_HOME%\Working\InstanceNames.txt

::Takes the Instance Names and looks for staging and Production Servers.
findstr /C:"prod stg" /C:"stg" "C:\AWS\Working\InstanceNames.txt" >> C:\AWS\Working\Monthly.txt

:: Create snapshots of all attached volumes
for /F "tokens=2,3" %%d IN (%AWS_HOME%\Working\ActiveVolumes.txt) do for /F "tokens=3,5*" %%a IN (%AWS_HOME%\Working\Monthly.txt) do if %%a EQU %%e ec2-create-snapshot %%d -d "Monthly Backup for %%b (VolID:%%d InstID:%%e)"



