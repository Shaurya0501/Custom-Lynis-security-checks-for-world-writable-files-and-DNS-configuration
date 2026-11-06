
#!/bin/sh

# CUST-0020: DNS Configuration and Resolution Audit

Register --test-no CUST-0020 --weight L --network YES --category security --description "Check DNS configuration and resolution"

if [ "${SKIPTEST}" -eq 0 ]; then
    Display --indent 2 --text "- Checking DNS configuration"

    if [ ! -f /etc/resolv.conf ]; then
        Display --indent 4 --text "DNS configuration" --result "${STATUS_WARNING}" --color RED
        ReportWarning "${TEST_NO}" "/etc/resolv.conf not found"
    else
        NAMESERVER=$(grep '^[[:space:]]*nameserver[[:space:]]' /etc/resolv.conf)

        if [ -z "$NAMESERVER" ]; then
            Display --indent 4 --text "DNS nameserver" --result "${STATUS_WARNING}" --color RED
            ReportWarning "${TEST_NO}" "No nameserver configured in /etc/resolv.conf"
        else
            Display --indent 4 --text "DNS nameserver" --result "${STATUS_OK}" --color GREEN
            LogText "Result: DNS nameserver configuration found"
        fi

        if getent hosts google.com >/dev/null 2>&1; then
            Display --indent 4 --text "DNS resolution" --result "${STATUS_OK}" --color GREEN
            LogText "Result: Hostname resolution successful"
        else
            Display --indent 4 --text "DNS resolution" --result "${STATUS_WARNING}" --color RED
            ReportWarning "${TEST_NO}" "Hostname resolution failed for google.com"
        fi
    fi
fi
