
#!/bin/sh

# CUST-0010: World-Writable Files Audit

Register --test-no CUST-0010 --weight L --network NO --category security --description "Check for world-writable files"

if [ "${SKIPTEST}" -eq 0 ]; then
    Display --indent 2 --text "- Checking for world-writable files"

    WW_FILES=$(find /etc /usr /opt /home \
        -path "/home/$USER/.vscode-server" -prune \
        -o -type f -perm -002 -print 2>/dev/null)

    if [ -z "$WW_FILES" ]; then
        Display --indent 4 --text "World-writable files" --result "${STATUS_OK}" --color GREEN
        LogText "Result: No world-writable files found in scanned locations"
    else
        Display --indent 4 --text "World-writable files" --result "${STATUS_WARNING}" --color RED
        LogText "Result: World-writable files detected"
        ReportWarning "${TEST_NO}" "World-writable files detected in scanned locations"
    fi
fi
