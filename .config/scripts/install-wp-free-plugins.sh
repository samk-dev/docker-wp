#!/usr/bin/env bash

echo '⚙️  INFO: Installing WordPress Plugins -- FREE'

echo '⏳ INFO: checking the wp-package.json ⌛️'

if [ -f wp-package.json ]; then
  echo "✅ INFO: wp-package.json file exists"
  source .env
  LE_DIR=$(pwd)
else  
  echo "💥 ERROR: Could not find the .wp-package.json file? How do you want me to install the plugins for you? 😑"
  exit 1;  
fi

if [ -r temp ]; then
  echo "✅ INFO: folder exits"
  source .env
  LE_DIR=$(pwd)
  echo "🎒 INFO: backing up temp directory"
  mv temp temp-backup
  echo "⚙️  INFO: creating temp directory..."
  mkdir temp
  echo "✅ INFO: directory created"
else  
  echo "⚙️ INFO: creating temp directory"
  mkdir temp 
  echo "✅ INFO: directory created"
fi
