# Journal de bord

(remplacer les items en majuscule)

* TITRE PROJET  : Automatisation de la création de VM (Virtual Machine) sur Virtualbox
* NOM CHEF DE PROJET : Mohammad Aw
* NOMS AUTRE MEMBRES : EQUIPE Seydina Hanne
* DATE DEBUT : 16/09/2026


## Séance n° 1

* date - heure : 16/09/2026 - 13h30-16h30
* Travail effectué  : Compréhension du cours et du projet, ainsi que recherche et consultation de documentation en ligne sur les différentes possibilités de mise en œuvre.
* A faire à la prochaine séance :approfondir la documentation et choix des methodes à utiliser. 
* Difficultés rencontrées : aucun pour le moment .
* Remarques sur la séances (membre absent, pbe technique, ...)


## Séance n° 2

* date - heure
* Travail effectué : La version 1 crée une machine `Debian1` avec :



\* 4096 Mo de RAM

\* un disque virtuel de 64 GiB

\* un contrôleur SATA

\* un réseau NAT



La machine est ensuite supprimée après une pause permettant de vérifier sa présence dans VirtualBox.



\### Version 2



```cmd

genmv2.bat

```



La version 2 vérifie si une machine `Debian1` existe déjà. Si c'est le cas, elle est supprimée avant d'être recréée.



Cette modification permet de relancer le script plusieurs fois sans conserver une ancienne machine portant le même nom.


* A faire à la prochaine séance : Améliorer la creation en ajoutant les options et les métadonnées des machines 

* Difficultés rencontrés: Pas encore   

* Remarques sur la séances (membre absent, pbe technique, ...)


## Séance n° 3

* date - heure : 22/09/2026   13h-16h

* Travail effectué:
\### Version 3



La version 3 fonctionne avec des arguments.



Lister les machines :



```cmd

genmv3.bat L

```



Créer une machine :



```cmd

genmv3.bat N NomMachine

```



Supprimer une machine :



```cmd

genmv3.bat S NomMachine

```



Démarrer une machine :


```cmd

genmv3.bat D NomMachine

```



Arrêter une machine :



```cmd

genmv3.bat A NomMachine

```



Les paramètres de RAM et de taille du disque sont définis dans les variables situées au début du script.



\### Version 4



La version 4 reprend les fonctionnalités de la version 3 et ajoute des métadonnées aux machines créées.



Les métadonnées enregistrées sont :\* la date et l'heure de création ;

\* le nom de l'utilisateur Windows ayant créé la machine.



La commande `L` affiche ces informations pour chaque machine.



La liste des machines est enregistrée temporairement dans un fichier à l'aide de :



```cmd

VBoxManage list vms > vms.txt

```



Le fichier est ensuite parcouru avec une boucle `FOR`.



* A faire à la prochaine séance : ajouter PXE pour que la machine démarre sur le réseau mais ça s'avère trés compliqué à realiser 

 
* Difficultés rencontrées :Une difficulté rencontrée concernait la suppression d'une machine virtuelle encore en fonctionnement. VirtualBox refuse de supprimer une machine lorsqu'elle est verrouillée.



Il a donc fallu vérifier l'état de la machine avec :



```cmd

VBoxManage showvminfo "NomMachine" --machinereadable

```



et utiliser `poweroff` lorsque la machine ne s'arrêtait pas avec la demande ACPI.


* Remarques sur la séances (membre absent, pbe technique, ...)



...


