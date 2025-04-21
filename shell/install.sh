#!/bin/bash

# Function to display usage information
show_usage() {
	echo "Usage: $0 [-u] [-y]"
	echo "  -u    Force update all files, even if they exist in the destination"
	echo "  -y    Automatic yes to all prompts (with -u)"
	echo "  Default: only copy files that don't exist in the destination"
}

# Default settings
force_update=0
auto_confirm=0

# Parse command line options
while getopts "uy" opt; do
	case $opt in
	u)
		force_update=1
		;;
	y)
		auto_confirm=1
		;;
	*)
		show_usage
		exit 1
		;;
	esac
done

# Create necessary directories
mkdir -p ~/.local/bin
mkdir -p ~/.local/etc

# Function to handle file copying with optional confirmation
copy_files() {
	local src_dir=$1
	local dest_dir=$2
	local file_type=$3

	echo "Processing $file_type..."

	# First check if the source directory exists
	if [ ! -d "$src_dir" ]; then
		echo "$file_type directory $src_dir not found, skipping"
		return
	fi

	# Get list of files to update
	if [ $force_update -eq 1 ] && [ $auto_confirm -eq 0 ]; then
		# Interactive update mode
		for file in "$src_dir"/*; do
			if [ -f "$file" ]; then
				filename=$(basename "$file")
				dest_file="$dest_dir/$filename"

				# New file - always copy
				if [ ! -f "$dest_file" ]; then
					echo "Copying new file: $filename"
					cp -v "$file" "$dest_file"
					continue
				fi

				# Existing file - ask for confirmation
				echo -n "Update existing file $filename? (y/n): "
				read -r answer
				if [[ $answer == y* || $answer == Y* ]]; then
					cp -v "$file" "$dest_file"
				else
					echo "Skipping $filename"
				fi
			fi
		done
	else
		# Set rsync options based on update mode
		if [ $force_update -eq 1 ]; then
			# With -u -y, update all files automatically
			echo "Force updating all $file_type..."
			rsync_opts="-avPh"
		else
			# Default mode, only copy files that don't exist
			echo "Copying only new $file_type..."
			rsync_opts="-avPh --ignore-existing"
		fi

		# Perform the rsync operation
		rsync ${rsync_opts} "$src_dir"/* "$dest_dir"/
	fi
}

# Display current mode
if [ $force_update -eq 1 ]; then
	if [ $auto_confirm -eq 1 ]; then
		echo "Mode: Force update all files with automatic confirmation"
	else
		echo "Mode: Force update with per-file confirmation"
	fi
else
	echo "Mode: Only copy files that don't exist in the destination"
fi

# Create necessary directories
mkdir -p ~/.local/bin
mkdir -p ~/.local/etc

# Process bin directory
copy_files "./bin" ~/.local/bin "executables"

# Process etc directory
copy_files "./etc" ~/.local/etc "configuration files"

echo "Installation complete"
