#! /bin/bash
#
# Runs all build scripts in Konsole tabs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# List of commands to run, with parameters, in quotes, space-separated; do not use quotes inside (see bash arrays)
COMMANDS=("$DIR/ubuntu-launchpad/build-for-launchpad.sh" "$DIR/obs/build-for-obs.sh")

# KDS=$KONSOLE_DBUS_SERVICE # This is the ref of the current konsole and only works in a konsole
# KDS=$(org.kde.konsole)    # This is found in some examples but is incomplete

qdbus >/tmp/q0              # Get the current list of konsoles
/usr/bin/konsole            # Launch a new konsole
# PID=$!                    # And get its PID - But for some reason this is off by a few
sleep 1
qdbus >/tmp/q1              # Get the new list of konsoles
# KDS=org.kde.konsole-$PID      
# KDS=org.kde.konsole       # Sometimes
KDS=$(diff /tmp/q{0,1} | grep konsole)  # Let's hope there's only one
#echo $KDS
KDS=${KDS:3}
echo $KDS

echo $KDS >/tmp/KDS
echo >>/tmp/KDS

qdbus $KDS >>/tmp/KDS || exit
echo >>/tmp/KDS

# See note https://docs.kde.org/trunk5/en/applications/konsole/scripting.html about using /Konsole
qdbus $KDS /Windows/1 >>/tmp/KDS
echo >>/tmp/KDS

FirstTime=1

for i in "${COMMANDS[@]}"
do 
    echo "Starting: $i"
    echo >>/tmp/KDS
    if [ $FirstTime -eq 1 ]
    then
        session=$(qdbus $KDS /Windows/1 currentSession)
        FirstTime=0
    else
        session=$(qdbus $KDS /Windows/1 newSession)
    fi
    echo $session >>/tmp/KDS

    # Test: Display possible actions
    qdbus $KDS /Sessions/${session} >>/tmp/KDS

    # Doesn't work well, maybe use setTabTitleFormat 0/1 instead
    # Title "0" appears to be the initial title, title "1" is the title used after commands are executed. 
    #qdbus $KDS /Sessions/${session} setTitle 0 $i
    #qdbus $KDS /Sessions/${session} setTitle 1 $i

    # The line break is necessary to commit the command. \n doesn't work
    qdbus $KDS /Sessions/${session} sendText "${i}
"

    # Optional: will ping when there's no more output in the window
    qdbus $KDS /Sessions/${session} setMonitorSilence true
done
