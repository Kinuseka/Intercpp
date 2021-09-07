#!/usr/bin/env bash
this="${1}"
cwd="$(pwd)"
filedir="$cwd/$this"
exec_name="cexecutable_binary"
#Define Colors
cReset='\033[0m'
cRed='\033[0;31m'
cGreen='\033[0;32m'
cYellow='\033[0;33m'
cBlue='\033[0;34m'
cPurple='\033[0;35m'
cCyan='\033[0;36m'
cWhite='\033[0;37m'        

cBWhite='\033[1;37m'
cBRed='\033[1;31m'
cBGreen='\033[1;32m'

regcommand="gcc"

stdincheck() 
{
    if [ "$this" == "--uninstall" ]; then
        echo -e "${cBRed}[Shell] Uninstall flag${cReset}" 
        printf "continue(y/n)?"
        read input
        if [ $input == "y" ]; then
            rm -f "/usr/bin/intercpp"
            if [ command -v intercpp ]; then
                rm -f "$0"
            fi
            echo -e "${cBGreen}Uninstalled${cReset}"
            exit 0
        else
            exit 0
        fi 
    fi
}


gcc_check()
{
    if command -v gcc && command -v g++ ; then
        echo "ok"
    else
        echo "err"        
    fi
}

clangcheck()
{
    if command -v clang && command -v clang++ ; then
        echo "ok"
    else
        echo "err"
    fi
}


init()
{
    if [[ ! $EUID -ne 0 ]]; then
        echo -e "${cBRed}[Shell] Root mode${cReset}"
    fi
    gccstatus="$(gcc_check)"
    clstatus="$(clangcheck)"
    if [[ $this =~ ^[A-Za-z0-9._%+-]+\.[Cc][Pp][Pp]$ ]]; then
        if [ "$gccstatus" != "err" ]; then
            regcommand="g++"
        elif [ "$clstatus" != "err" ]; then
            regcommand="clang++"
        else
            return 1
        fi
    elif [[ $this =~ ^[A-Za-z0-9._%+-]+\.[Cc]$ ]]; then
        if [ "$gccstatus" != "err" ]; then
            regcommand="gcc"
        elif [ "$clstatus" != "err" ]; then
            regcommand="clang"
        else
            return 1
        fi
    else
        echo -e "${cBRed}[Shell] Invalid extension${cReset}"
    fi
    cd $HOME
    if ! [ -d ".cache" ]; then
        mkdir ".cache"
    fi 
    if ! [ -d ".cache/intercpp" ]; then
        mkdir ".cache/intercpp"
    fi
    cd $cwd
}

removebinary()
{
    cd "$HOME/.cache/intercpp"
    rm $exec_name
}

openbinary()
{
    cd "$HOME/.cache/intercpp"
    chmod 777 "$exec_name"
    #echo -e "${cBWhite}[Shell] Running binary--${cReset}"
    ./"$exec_name"
    removebinary
}

checkbinary() 
{
    cd $cwd
    if [ -f "$exec_name" ]; then
      local output="$(mv -f "$exec_name" "$HOME/.cache/intercpp" 2>&1)"
      return 0
    else
      return 1
    fi
}

stdincheck
if [ -f "$filedir" ]; then
    init
    if [ $? == 1 ]; then
        echo -e "${cBRed}[Shell] No C/C++ compilers found${cReset}"
        exit 1
    fi
    #echo -e "${cBWhite}[Shell] compiling${cReset}"
    case $2 in 
    gcc) MYVARIABLE="$(gcc "$filedir" -o "$exec_name" 2>&1)" ;;
    g++) MYVARIABLE="$(g++ "$filedir" -o "$exec_name" 2>&1)" ;;
    clang) MYVARIABLE="$(clang "$filedir" -o "$exec_name" 2>&1)" ;;
    clang++) MYVARIABLE="$(clang++ "$filedir" -o "$exec_name" 2>&1)" ;;
    *) MYVARIABLE="$(${regcommand} "$filedir" -o "$exec_name" 2>&1)" ;;
    esac
    if [ "$MYVARIABLE" ]; then
        echo -e "${cRed}$MYVARIABLE${cReset}"
        checkbinary
        case $? in
            0) printf "continue (y/n)?"
            read input
            if [ "$input" != "y" ]; then
                exit 0
            fi
            openbinary
            exit 0 ;;
            1) echo -e "${cBRed}[Shell] binary not found${cReset}"
            exit 1 ;;
            *) echo -e "${cBWhite}<Dbug> Nothing to do${cReset}"
            exit 2 ;;
        esac
    else
        checkbinary
        case $? in 
        0) openbinary
        exit 0 ;;
        1) echo -e "${cBRed}[Shell] binary not found${cReset}"
        exit 1 ;;
        esac
    fi
else
   echo -e "${cBRed}[Shell] file not found${cReset}"
   exit 1
fi