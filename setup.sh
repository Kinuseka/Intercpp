#!/usr/bin/env bash

cp -f "intercpp.sh" "/usr/bin/intercpp"
if [ $? -ne 0 ]; then
    echo "There was an issue during setup"
    exit 1
fi
chmod +x "/usr/bin/intercpp"
if [ $? -ne 0 ]; then
    rm -f "/usr/bin/intercpp"
    echo "There was an issue during setup"
    exit 1
fi
echo "Setup complete, to uninstall do"
echo "'intercpp --uninstall'"