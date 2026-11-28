#!/bin/bash

# Maintenance

USER_ID=$(id -u)

if [ "$USER_ID" -ne 0 ]; then
	echo "Access denied: Root privileges are required."
	echo "Please run this script as root or as a user with sudo privileges using sudo."
	exit 1
fi

check_disk_space() {
	echo "==== DISK SPACE ===="
	echo
	echo "Checking root filesystem disk usage..."
	df -h /
}

clean_cache() {
	echo "==== PACKAGE CLEANUP ===="
	echo
	echo "Cache size before cleanup: "
	du -sh /var/cache/apt/archives
	echo
	read -p  "Proceed with cleanup? (y/n): " ANSWER
	echo
	if [ "$ANSWER" = "y" ]; then
		if apt clean; then
			echo "Cleanup successful"
			echo "Cache size after cleanup: "
        		du -sh /var/cache/apt/archives
		else
			echo "Operation failed"
		fi
	elif [ "$ANSWER" = "n" ]; then
		echo "Cleanup Cancelled"
	else
		echo "Invalid input"
	fi
}

check_updates() {
	echo "==== SOFTWARE UPDATES ===="
	echo "Refreshing package information..."
	echo
	if apt update; then
		echo "Package information updated successfully."
		echo "Available software upgrades:"

			echo "1. View detailed package information"
			echo "2. View package names only"
			read -p "Enter your choice: " CHOICE
			echo
			if [ "$CHOICE" = 1 ]; then
				apt list --upgradable
			elif [ "$CHOICE" = 2 ]; then
				apt list --upgradable 2>/dev/null | awk -F'/' 'NR>1 {print $1}'
			else
				echo "Invalid choice"
			fi
		echo "Listing done"
	else
		echo "Failed to refresh package information."
	fi
}

upgrade_all_packages() {
	echo "==== UPGRADE ALL PACKAGES ===="
	echo
	check_disk_space
	echo
	echo "Refreshing package information"
	if apt update; then
		echo "Package information updated successfully."
		echo
		echo "Preparing to upgrade packages..."
		echo
		if apt upgrade; then
			echo "Upgrade completed successfully."
		else
			echo "Upgrade failed or was cancelled."
		fi
	else
		echo "Failed to refresh package information."
		echo "Upgrade cancelled"
	fi
}

upgrade_selected_package() {
	echo "==== UPGRADE SELECTED PACKAGE ===="
	echo
	check_disk_page
	echo
	echo "Refreshing package information..."
	if apt update; then
		echo "Package information updated successfully."
		echo
		PACKAGES=$(apt list --upgradable | awk -F '/' 'NR>1 {print $1}')
		if [ -z "$PACKAGES" ]; then
			echo "No packages available for upgrade."
		else
			echo "Available packages:"
			echo "$PACKAGES"
			echo
			read -p "Enter the package name: " PACKAGE_NAME
			echo
			if echo "$PACKAGES" | grep -Fxq -- "$PACKAGE_NAME"; then
				echo "Preparing to upgrade $PACKAGE_NAME..."
				if apt install --only-upgrade "$PACKAGE_NAME"; then
					echo "Package upgrade completed successfully."
				else
					echo "Package upgrade failed or was cancelled"
				fi
			else
				echo "Invalid package name."
				echo "Please select a package from the list"
			fi
		fi
	else
		echo "Failed to refresh package information"
		echo "Upgrade cancelled"
	fi
}

while true
do
	clear
	echo "==== MAIN MENU ===="
	echo "1. Check disk space"
	echo "2. Clean package cache"
	echo "3. Check available software updates"
	echo "4. Upgrade all packages"
	echo "5. Upgrade a selected package"
	echo "6. Exit"

	read -p "Enter your choice: " MENU_CHOICE

	case "$MENU_CHOICE" in
		1)
			check_disk_space
			;;
		2)
			clean_cache
			;;
		3)
                        check_updates
                        ;;
                4)
                        upgrade_all_packages
                        ;;
		5)
                        upgrade_selected_package
                        ;;
                6)
			echo "Exit"
                        exit 0
                        ;;
		*)
			echo "Invalid choice"
			;;
	esac
	echo
	read -p "Press Enter to return to the menu..."
done

