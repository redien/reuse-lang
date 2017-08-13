
Should parse symbols of one byte
> 1
= 1

> a
= a

Should parse several ASCII characters
> abc
= abc

> 123
= 123

> abc123
= abc123

> 1a2b3c
= 1a2b3c

Should parse a UTF-8 character
> ✓
= ✓

Should parse several UTF-8 characters
> ᎠᎹᏗᎧᏂᎬᎾᎬᎾ
= ᎠᎹᏗᎧᏂᎬᎾᎬᎾ
