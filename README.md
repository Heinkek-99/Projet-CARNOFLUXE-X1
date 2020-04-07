# Projet-CARNOFLUXE-X1
 Projet consistant à créer différents serveur afin de permettre aux différentes utilisateurs une bonne connectivité entre machines et accès à un site web

#Procédure d'installation

#I.	Procédure d’installation du serveur HTTP (apache).

1-	Définir le nom de la machine 
nano /etc/hosts 

2-	Modifier Debian par son nom de machine
nano /etc/hostname 

3-	Redémarrer : reboot
4-	Configurer l’adresse IP de la machine
nano /etc/network/interfaces

                 allow-hotplug ens33
		iface ens33 inet static
   		 address 192.168.10.10
   		 netmask 255.255.255.0
   		 gateway ***.***.***.***

5-	Modifier la configuration du DNS
nano /etc/resolv.conf

                 domain nom_de_domaine
		search nom_de_domaine
		nameserver ***.***.***.***
		nameserver ***.***.***.***

6-	Installer le service apache
7-	apt-get install apache2

8-	Créer les répertoires qui contiendront les fichiers vhost
mkdir /var/www/supervision/
mkdir /var/www/carnofluxe/

9-	Placer un fichier index.html dans chaque répertoire
nano /var/www/supervision/index.html
nano /var/www/carnofluxe/index.html




10-	Ajouter le code index.html dans carnofluxe
<html>
   <head>
      <title>SITE CARNOFLUXE</title>
   </head>

   <body>    
	<h1> Bienvenue sur le site e-commerce de carnofluxe</h1>
          <p>Pour plus d’infos contacter le service technique</p>
   </body>

</html>

11-	Ajouter le code index.html dans supervision
<html>
   <head>
      <title>SITE-SUPERVISION CARNOFLUXE</title>
   </head>

   <body>    
          <p>Essaie html</p>
   </body>

</html>

12-	Créer les vhost
nano /etc/apache2/sites-available/carnofluxe.domain.conf
nano /etc/apache2/sites-available/carnofluxe.local.conf
nano /etc/apache2/sites-available/default.conf

13-	Ajouter le code de configuration de carnofluxe.domain.conf
<VirtualHost *:80>

     ServerName  www.carnofluxe.domain
     ServerAlias  carnofluxe.domain
	   DocumentRoot /var/www/carnofluxe
	   DirectoryIndex index.html
</VirtualHost>

<VirtualHost *:80>
  ServerName supervision.carnofluxe.domain
	DocumentRoot /var/www/supervision
	DirectoryIndex index.html
</VirtualHost>
14-	Ajouter le code de configuration de carnofluxe.local.conf
<VirtualHost *:80>

     ServerName  www.carnofluxe.domain
     ServerAlias  carnofluxe.domain
	   DocumentRoot /var/www/carnofluxe
	   DirectoryIndex index.html
	 
    <Directory /var/www/carnofluxe>
	     Require all granted
       AllowOverride All
    </Directory>

</VirtualHost>

15-	Ajouter le code de configuration de default.conf
<VirtualHost *:80>

     ServerAdmin kronfor@localhost
	   DocumentRoot /var/www
 	   
	   ErrorLog ${APACHE_LOG_DIR}/error.log
	   CustomLog ${APACHE_LOG_DIR}/access.log  combined
</VirtualHost>

16-	Pour pouvoir accéder au site
a2ensite carnofluxe.domain
a2ensite default.conf

Remarques : Après configuration du VirtualHosts, veuillez reload afin que les configurations effectuées soit pris en compte avec la commande
    
# service apache2 reload
	   

17-	Installer cv2html et url
apt-get install curl python-setuptools git
git clone https://github.com/dbohdan/csv2html.git
python setup.py install --user

18-	Créer les dossier de reception
mkdir /home/kronft/Bureau/Html
mkdir /home/kronft/Bureau/Csv

19-	Configuration ssh
#	nano /etc/ssh/sshd_config :
- Décommenter la ligne “Port 22”.
- Décommenter la ligne “PermitRootLogin”.
- Remplacer la suite de la ligne de PermitRootLogin par “no”.
Ensuite pour que l'authentification se fasse automatiquement sans la demande de mot de passe, on doit générer une clé rsa (plus sécurisé que dsa) qui va être utilisée pour la connexion pour cela tapez la commande ssh-keygen sur la machine cliente ensuite des questions apparaîtront, appuyez sur entrée pour toutes les questions :
Enter file in which to save the key (/home/yo/.ssh/id_rsa) :
Enter passphrase (empty for no passphrase) : Ici tapez entrez pour qu’il n’y ait pas de mot de passe à entrer lors de la connexion
Enter same passphrase again : de même ici
Ensuite on doit copier notre clé sur le serveur virtuel distant ici le serveur HTTP.
ssh-copy-id kronft@192.168.10.10
Tapez yes dans le message suivant qui est un message d’avertissement et enfin un message vous demandera le mot de passe de l’utilisateur du serveur distant.
Et ainsi vous pourrez envoyer des fichiers entres les machines distantes et sur le même réseau.
Pour que le ssh marche parfaitement le mieux est de l’utiliser en mode utilisateur simple.

20-	Configurer crontab
crontab -e

#II.	Procédure d’installation du serveur DNS maître et DHCP

#a-	Serveur DHCP
Tout d’abord faut installer les paquets isc-dhcp-server. Tapez :
# apt-get install isc-dhcp-server

Avant toute chose il faut stopper le reseau de la machine virtuelle. Tapez 
# service network-manager stop

Remarque : # signifie que l’administrateur est en mode root (super utilisateur)
Ensuite configurer l’adresse IP de la machine serveur en mode manuel dans le fichier /etc/network/interfaces
#	nano /etc/network/interfaces
                 allow-hotplug ens33
		iface ens33 inet static
   		 address 192.168.10.5
   		 netmask 255.255.255.0
   		 gateway 192.168.10.254

Configurer le fichier /etc/dhcp/dhcpd.conf
subnet 192.168.10.0 netmask 255.255.255.0 {
range 192.168.10.100 192.168.10.200;
option broadcast-address 192.168.10.255;
option routers 192.168.10.1;
option domain-name “carnofluxe.domain”;
option domain-name-servers 192.168.10.22, 192.168.10.23;
default-lease-time 600;
max-lease-time 7200;
}

Configurer l’interface IPV4. Tapez :
#	nano /etc/default/isc-dhcp-server
                 INTREFACESv4 = ”ens33”

Tapez :
#	service manager-network start
Pour activer le réseau de la machine afin que les configurations modifiées puissent être pris en compte.
Si vous rencontrez des problèmes lors l’initialisation de vos configuration, tapez :
#	ifdown ens33
#	ifup ens33	
#	ifup ens33
Pour finir tapez :
#	/etc/init.d/isc-dhcp-server restart 
Pour redémarrer le service DHCP

#b-	Serveur DNS Maître
	Installer les paquets bind9
#	apt-get install bind9 bind9tils dnsutils
	Changer le nom de la machine 
# 	nano etc/hostname
Remplacer « debian » par « DhcpDns.carnofluxe.domain »
#	nano /etc/hosts
Remplacer « debian » par le nom de la machine et son nom de domaine comme fait précédemment
C’est-à-dire modifier ceci dans le fichier hosts :  127.0.1.1  	DhcpDns.carnofluxe.domain
Configuration des du service dans le répertoire /etc/bind
Editons le fichier named.conf.local en tapant :
#	nano /etc/bind/named.conf.local
Et entrons ces différentes configurations
zone “carnofluxe.domain” {
	type master;
	also-notify { 192.168.10.6; };
	allow-transfer { 192.168.10.6; };
	allow-update { none; };
	allow-query { any; };
	notify yes;
	file “/etc/bind/db.carnofluxe.domain”;
};
zone “10.168.192.in-addr.arpa” {
	type master;
	also-notify { 192.168.10.6; };
	allow-transfer { 192.168.10.6; };
	allow-update { none; };
	allow-query { any; };
	notify yes;
	file “/etc/bind/db.10.168.192.in-addr.arpa”;
};

#	nano /etc/bind/named.conf.options
options {
         directory "/var/cache/bind";
         allow-transfer { 192.168.10.6; };
};
#	nano /etc/bind/db.carnofluxe.domain

$TTL 604800
@ IN SOA carnofluxe.domain. root.carnofluxe.domain. (
	1 ; Serial
	604800 ; Refresh
	86400 ; Retry
	2419200 ; Expire
	6048000 ) ; Min TTL
;
@	IN NS DhcpDns.carnofluxe.domain.
@ 	IN NS dnSlave.carnofluxe.domain.
dhcpDns IN A 192.168.10.5
dnSlave IN A 192.168.10.6
www IN A 192.168.10.10
supervision IN A 192.168.10.10

#	nano /etc/bind/db.10.168.192.in-addr.arpa

$TTL 604800
@ IN SOA 10.168.192.in-addr.arpa. root.10.168.192.in.addr.arpa. (
	2 ; Serial
	604800 ; Refresh
	86400 ; Retry
	2419200 ; Expire
	6048000 ) ; Min TTL
;
@	IN NS DhcpDns.carnofluxe.domain.
@ 	IN NS dnSlave.carnofluxe.domain.
10	IN PTR www.carnofluxe.domain
10 	IN PTR supervision.carnofluxe.domain

Pour configure un nom de domaine, on peut toujours essayer manuellement via ce logiciel en ligne:
https://pgl.yoyo.org/as/bind-zone-file-creator.php
Pour verifier la synthaxe des fichiers bind9, tapez:
#	named-checkconf -z
Pour finir, nous pouvons maintenant rédemarrer le bind9 pour appliquer les modifications efféctuer précédement. Tapez:
#	service bind9 restart

#c-	Serveur DNS Slave

	Changer le nom de la machine 
# 	nano etc/hostname
Remplacer « debian » par « dnSlave.carnofluxe.domain »
#	nano /etc/hosts
Remplacer « debian » par le nom de la machine et son nom de domaine comme fait précédemment
C’est-à-dire modifier ceci dans le fichier hosts :  127.0.1.1  	dnSlave.carnofluxe.domain
Configuration des du service dans le répertoire /etc/bind
	Editons le fichier named.conf.local en tapant :
#	nano /etc/bind/named.conf.local
Et entrons ces différentes configurations
zone “carnofluxe.domain” {
	type slave;
	masters {192.168.10.5;};
	file “/var/lib/bind/db.carnofluxe.domain”;
};
zone “10.168.192.in-addr.arpa” {
	type slave;
	masters {192.168.10.5;};
	file “/var/lib/bind/db.10.168.192.in-addr.arpa”;
};

Pour verifier la synthaxe des fichiers bind9, tapez:
#	named-checkconf -z
Pour finir, nous pouvons maintenant rédemarrer le bind9 pour appliquer les modifications efféctuer précédement. Tapez:
#	service bind9 restart
Vérifier que les fichiers ont été bien copié dans /var/lib/bind
#	ls /var/lib/bind

