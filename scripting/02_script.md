**A Shell Script:** A shell script is a computer program designed to be run by Linux/Unix shell which includes 
- Bourne Shell
- C Shell
- Knot Shell
- GNU Bourne-again Shell

**A Shell:** A shell is a command-line interpreter. It provides an interface to interact with the UNIX system, and the typical operation of shell script includes
- Program execution
- Printing text
- Manipulation

_The following script uses the **read** command which takes the input from the keyboard and assigns it as the value of the variable **PERSON** and finally prints it on **STDOUT**._

```
#!/bin/sh
echo "What is your name?"
read PERSON
echo "Hello, $PERSON"
```

_Here is a sample run of the script_
```
$./test.sh
What is your name?
Emmanuel Ogah
Hello, Emmanuel Ogah
$
```
**Shell Prompt:** The prompt _$_ is called the **command prompt** issue by the shell.

```
$date
Thu Jun 25 08:30:19 MST 2009
```
#### Type of shell

There are two major type of shell
1. Bourne Shell: The _$_ character is the default prompt. It is subcategories into
- Borune shell(sh)
- Knorn shell(ksh)
- Bourne-again shell(bash)
- POSIX shell(sh)
2. C shell: The _%_ character is the default prompt.  which is subcategorires into
- C-Shell(csh)
- TENEX/TOPS C shell (tcsh)

**shebang:** is a construct that tells the system that a shell script is being started. Example is **#!/bin/sh**

**Shell Comment:** You can put comment on your script.
```
#!/bin/bash

# Author : Emmanuel Ogah
# Copyright (c) Tutorialspoint.com followed by Emmanuel Ogah
# Script follows here:
pwd
ls
```
_Save the above content and make the script executable_
```
$chmod +x script.sh
```
_The shell script is now ready to be executed_
```
$./script.sh
```

_Upon executaion, you will receive the following

```
/home/amrood
index.htm  unix-basic_utilities.htm  unix-directories.htm  
test.sh    unix-communication.htm    unix-environment.htm
```
**Extended Shell Scripts:** Shell scripts have several required constructs that tell the shell environment what to do and when to do it.