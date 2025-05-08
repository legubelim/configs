
docker compose up -d

# then go to 192.168.1.185:8083
# set up admin account
# Réglage > Gńéral > 
#   adresse web de Wordpress: http://wordpress.gkcb.fr
#   adresse web du site: http://wordpress.gkcb.fr
# configure the nginx redirection

# not sure it is usefull.. or maybe it replaces the step above
docker exec -it *wordpres_container_id* bash
echo "define( 'WP_HOME', 'http://wordpress.gkcb.fr' );" >> wp_config.php
echo "define( 'WP_HOME', 'http://wordpress.gkcb.fr' );" >> wp_config.php




