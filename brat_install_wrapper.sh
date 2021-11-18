#!/bin/bash

cd /var/www/brat/ && /var/www/brat/install.sh <<EOD
$BRAT_USERNAME
$BRAT_PASSWORD
$BRAT_EMAIL
EOD

echo "Install complete. You can log in as: $BRAT_USERNAME"

exit 0
