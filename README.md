# f2m
A small ruby script that converts flac files to mp3

This script converts flac music files to mp3. If you provide a directory as the applications argument it will convert all files inside the directory to mp3. By default all files will be placed in a folder called 'converted' but you can change this by providing an output folder using the -o option.

This script requires lame and flac to be installed and to be available in the execution PATH.

It currently only converts the basic metadata (artist, track number, track title and album title). It uses the preset medium which should result in varibale bitrate files with roughly 192kbit.

The script fills the gap for me that I have my whole CD collection ripped to flac but most of my music devices, especially in the car, refuse to play this file format (I am also looking at you Apple)

You need to install two ruby gems for this:
```
$ gem install ruby-mp3info flacinfo-rb
```

Run the script by typing:
```
$ ruby f2m.rb <src file or folder>
```