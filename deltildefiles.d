
/****************************************************************
File: deltildefiles.d
Purpose: To delete vim backup files, i.e. files ending with ~.
Compile with:
$ dmd deltildefiles.d

Author: Vasudev Ram
Copyright 2016 Vasudev Ram
Web site: https://vasudevram.github.io
Products: https://gumroad.com/vasudevram

Description: To delete all files whose names end with 
the tilde character (~) in the directory subtree 
specified as the command-line argument. 

When you edit a file abc.txt with the vim editor, it will 
first make a backup in the file abc.txt~ (note ~ character
at end of file name). Over time, these files can accumulate.
This utility helps you to delete all such vim backup files 
in a specified directory and its subdirectories.

Use with caution and at your own risk!!!
On most operating systems, once a file is deleted this way
(versus sending to the Recycle Bin on Windows), it is not 
recoverable, unless you have installed some undelete utility.
****************************************************************/

import std.stdio;
import std.file;

void usage(string[] args) {
    stderr.writeln("Usage: ", args[0], " dirName");
    stderr.writeln(
        "Recursively delete files whose names end with ~ under dirName.");
}

int main(string[] args) {
    if (args.length != 2) {
        usage(args);
        return 1;
    }
    string dirName = args[1];
    // Check if dirName exists.
    if (!exists(dirName)) {
        stderr.writeln("Error: ", dirName, " not found. Exiting.");
        return 1;
    }
    // Check if dirName is not the NUL device and is actually a directory.
    if (dirName == "NUL" || !DirEntry(dirName).isDir()) {
        stderr.writeln("Error: ", dirName, " is not a directory. Exiting.");
        return 1;
    }
    try {
        foreach(DirEntry de; dirEntries(args[1], "*~", SpanMode.breadth)) {
            // The isFile() check may be enough, also need to check for
            // Windows vs POSIX behavior.
            if (de.isFile() && !de.isDir()) {
                writeln("Deleting ", de.name());
                remove(de.name());
            }
        }
    } catch (FileException) {
        stderr.writeln("Caught a FileException. Exiting.");
        return 1;
    } catch (Exception) {
        stderr.writeln("Caught an Exception. Exiting.");
        return 1;
    }
    return 0;
}

