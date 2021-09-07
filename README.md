# Intercpp
A bash script for unix like platform to run c/c++ binaries right away

has similar process to ```go run code.go``` that creates a temporary directory, executes it and 
cleans it after the process is finished

# Who will benefit?
*) People that run on mobile or terminal only environment will benefit heavily without relying on IDE to automatically run it
for them


*) People that are starting out on C/C++ and wants to have the familiar interpreted way of running the code


*) For quick test and lazy way to run your C/C++ program, particularly when debugging and or showcasing program

# Installation
1.) Clone this repository by ```git clone https://github.com/Kinuseka/Intercpp.git```

2.) For unix system run: ```bash setup.sh``` for termux(Android) run: ```bash termux-setup.sh```

3.) Run by: ```intercpp <c/c++ code>``` e.g ```intercpp project.cpp```

#Uninstall
Simply do: ```intercpp --uninstall```
