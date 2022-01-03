
Parse single file
> file1
= ,file1

Parse two files
> file1 file2
= ,file1,file2

Parse three files
> file1 file2 file3
= ,file1,file2,file3

Should parse files after parameters
> --key value file1
= --key=value,file1

Should parse files before parameters
> file1 --key value
= --key=value,file1

Should parse files between parameters
> --key value file1 --key2 value
= --key=value,--key2=value,file1
