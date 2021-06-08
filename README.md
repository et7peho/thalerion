# thalerion

#Run mapreduce
$ bin/hadoop dfs -ls /usr/joe/wordcount/input/
/usr/joe/wordcount/input/file01
/usr/joe/wordcount/input/file02

$ bin/hadoop dfs -cat /usr/joe/wordcount/input/file01
Hello World, Bye World!

$ bin/hadoop dfs -cat /usr/joe/wordcount/input/file02
Hello Hadoop, Goodbye to hadoop.

Run the application:

$ bin/hadoop jar /usr/joe/wordcount.jar org.myorg.WordCount /usr/joe/wordcount/input /usr/joe/wordcount/output

Output:

$ bin/hadoop dfs -cat /usr/joe/wordcount/output/part-00000
Bye 1
Goodbye 1
Hadoop, 1
Hello 2
World! 1
World, 1
hadoop. 1
to 1


#COnfigure hadoop mapreduce
https://docs.cloudera.com/HDPDocuments/HDP2/HDP-2.6.5/bk_command-line-installation/content/configure_yarn_and_mapreduce.html


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








