# f2m
A small ruby script that converts flac files to mp3

This script converts flac music files to mp3. If you provide a directory as the applications argument it will convert all files inside the directory to mp3. It will do this by creating the same folder structure inside the folder where the script was run. If this happens to be the place where the source foulder is then the mp3 will be put right next to the flac files.

This script requires lame and flac to be installed and in the execution PATH.

It currently does not convert any kind of metadata nor is the preset for lame changeable. It uses the preset medium which should result in varibale bitrate files with roughly 192kbit.

The script fills the gap for me that I have my whole CD collection ripped to flac but most of may music devices, especially in the car, refuse to play this file format :(
