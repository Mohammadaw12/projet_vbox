\# Projet VBox — Automatisation de la création de machines virtuelles sur VirtualBox



\## Auteurs



Mohammad Aw , Seydina Hanne 



\## Date



21/09/2026



\## Résumé



Ce projet consiste à automatiser la gestion de machines virtuelles VirtualBox à l'aide de scripts Batch et de l'outil VBoxManage.

Les scripts permettent notamment de créer, lister, démarrer, arrêter et supprimer des machines virtuelles.

Plusieurs versions ont été développées progressivement afin d'ajouter de nouvelles fonctionnalités.

La version 4 ajoute notamment des métadonnées concernant la date de création et l'utilisateur.



\## Utilisation



Les scripts sont exécutés depuis un terminal Windows dans le répertoire du projet.



\### Version 1



```cmd

genmv1.bat

```



La version 1 crée une machine `Debian1` avec :



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



Les métadonnées enregistrées sont :



\* la date et l'heure de création ;

\* le nom de l'utilisateur Windows ayant créé la machine.



La commande `L` affiche ces informations pour chaque machine.



La liste des machines est enregistrée temporairement dans un fichier à l'aide de :



```cmd

VBoxManage list vms > vms.txt

```



Le fichier est ensuite parcouru avec une boucle `FOR`.



\## Fonctionnalités réalisées



\* \[x] Création d'une machine virtuelle Debian 64 bits

\* \[x] Configuration de la mémoire RAM

\* \[x] Création d'un disque virtuel de 64 GiB

\* \[x] Configuration du réseau en NAT

\* \[x] Création et connexion d'un contrôleur SATA

\* \[x] Détection d'une machine existante

\* \[x] Suppression d'une machine virtuelle

\* \[x] Liste des machines virtuelles

\* \[x] Démarrage d'une machine

\* \[x] Arrêt d'une machine

\* \[x] Gestion des arguments en ligne de commande

\* \[x] Gestion des erreurs avec affichage de messages

\* \[x] Ajout de métadonnées avec `VBoxManage setextradata`

\* \[x] Lecture des métadonnées avec `VBoxManage getextradata`

\* \[x] Utilisation de variables Windows pour la date et l'utilisateur

\* \[x] Analyse de `VBoxManage list vms` avec un fichier temporaire et une boucle `FOR`



\## Limites



Les scripts ont été développés pour un environnement Windows avec VirtualBox et l'outil `VBoxManage` accessible depuis le terminal.



Les machines créées par les premières versions ne possèdent pas automatiquement de système d'exploitation installé.



L'arrêt avec la commande `A` utilise une demande d'arrêt ACPI. Si la machine ne répond pas à cette demande, un arrêt forcé avec `VBoxManage controlvm "NomMachine" poweroff` peut être nécessaire.



\## Difficultés rencontrées



Une difficulté rencontrée concernait la suppression d'une machine virtuelle encore en fonctionnement. VirtualBox refuse de supprimer une machine lorsqu'elle est verrouillée.



Il a donc fallu vérifier l'état de la machine avec :



```cmd

VBoxManage showvminfo "NomMachine" --machinereadable

```



et utiliser `poweroff` lorsque la machine ne s'arrêtait pas avec la demande ACPI.



Une autre difficulté concernait la gestion des machines déjà existantes. La version 2 a permis de résoudre ce problème en vérifiant leur existence avant leur création.



\## Astuces techniques



Les tailles utilisées dans le script sont exprimées selon les unités attendues par VBoxManage.



4096 Mo correspondent à 4 Go de RAM.



64 GiB correspondent à 65536 MiB pour la commande de création du disque.



Les variables Batch permettent de modifier facilement les paramètres de configuration :



```bat

set "RAM=4096"

set "DISK\_SIZE=65536"

```



Les métadonnées sont enregistrées avec `setextradata` et récupérées avec `getextradata`.



\## Points techniques importants



Le script utilise principalement les commandes VBoxManage suivantes :



\* `createvm`

\* `modifyvm`

\* `createmedium`

\* `storagectl`

\* `storageattach`

\* `list vms`

\* `startvm`

\* `controlvm`

\* `unregistervm`

\* `setextradata`

\* `getextradata`



Les différentes versions ont été développées progressivement afin de tester chaque fonctionnalité avant de passer à la suivante.



\## Ajouts et améliorations possibles



Une amélioration possible serait d'automatiser davantage l'arrêt des machines afin de gérer les cas où une demande ACPI ne suffit pas.



La version suivante doit également permettre le démarrage d'une machine par PXE afin d'automatiser le démarrage sur une installation Debian par le réseau.



