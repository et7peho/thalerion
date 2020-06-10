# thalerion

Scripts that u could use to initialize any box for dev ctf:s
Outline:
open powershell with administrative rights
# Enable script execution policy and fetch https://chocolatey.org/install.ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Git to be able to fetch more files
choco install git -params '"/GitAndUnixToolsOnPath"'


# Fetch your own scripts with git to [path] i.e "C:\scripts"
git clone https://github.com/thalerion/thalerion.git 

# Set path to scripts
$env:path += ";[path]"








