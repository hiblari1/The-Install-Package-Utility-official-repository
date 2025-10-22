#!/bin/bash
# ipkg - TUI installer for Cupic (keyboard only)

while true; do
    clear
    echo "=== ipkg -Install Packages Utility- Custom Apt Package Installer ==="
    echo "Use ↑ ↓ to navigate, Enter to install, S to search, Q to quit."
    echo "NOTE : This is still in Beta, note that there are bugs, press ESC to exit search"
    echo "press any key and the script will give you all apt packages available"

    read -n1 -r key

    if [[ "$key" == "q" || "$key" == "Q" ]]; then
        break
    elif [[ "$key" == "s" || "$key" == "S" ]]; then
        echo "Enter search query: "
        read -r query
        packages=$(apt-cache search "$query" | awk '{print $1}')
        if [[ -z "$packages" ]]; then
            echo "No packages found for '$query'"
            read -n1 -r -p "🌎 Press any key to continue..."
            continue
        fi
    else
        # Default: show all available packages
        packages=$(apt list 2>/dev/null | awk -F/ '{print $1}' | sort)
    fi

    # Use fzf keyboard-only interface, disable mouse
    selected=$(echo "$packages" | fzf --height 40% --reverse --prompt="Select package: " --no-mouse)

    if [[ -n "$selected" ]]; then
        echo "Installing $selected..."
        sudo apt install -y "$selected"
        read -n1 -r -p "🌎 Press any key to continue..."
    fi
done
