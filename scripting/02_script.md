**A Shell Script:** A shell script is a computer program designed to be run by Linux/Unix shell which includes 
- Bourne Shell
- C Shell
- Knot Shell
- GNU Bourne-again Shell

**A Shell:** A shell is a command-line interpreter and the typical operation of shell script includes
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