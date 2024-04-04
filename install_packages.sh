#!/bin/bash

# Check if Homebrew is already installed, if not, install it
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed. Updating..."
  brew update
fi

# Initialize packages variable
packages=""

# Concatenate contents of all .package files and append to $packages.
for package_file in *.package; do
  echo "Adding packages from $package_file..."
  packages+=$'\n'"$(cat $package_file)"$'\n'
done

# Prompt user for confirmation
read -p "The following packages will be installed: $packages. Do you want to continue? (y/n): " answer

# Check user's response
if [[ $answer == [Yy] ]]; then
  # Install the packages using Homebrew
  brew install $packages

  # Update all packages
  brew upgrade
else
  echo "Installation aborted."
fi
