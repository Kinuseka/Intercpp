#!/data/data/com.termux/files/usr/bin/env bash

cp intercpp.sh termcpp.sh
termux-fix-shebang termcpp.sh
mv -f "termcpp.sh" "$PREFIX/bin/intercpp"
if [ $? -ne 0 ]; then
    echo "There was an issue during setup"
    exit 1
fi
chmod +x "$PREFIX/bin/intercpp"
if [ $? -ne 0 ]; then
    rm -f "$PREFIX/bin/intercpp"
    echo "There was an issue during setup"
    exit 1
fi
echo "Setup complete, to uninstall do"
echo "'intercpp --uninstall'"