@echo off
setlocal EnableDelayedExpansion

rem ========================================
rem       PROJET VBOX - VERSION 4
rem ========================================

rem Variables de configuration
set "RAM=4096"
set "DISK_SIZE=65536"
set "OSTYPE=Debian_64"
set "META_PREFIX=ProjetVbox"

rem Verification des arguments
if "%~1"=="" goto USAGE

if /I "%~1"=="L" goto LIST
if /I "%~1"=="N" goto CREATE
if /I "%~1"=="S" goto DELETE
if /I "%~1"=="D" goto START
if /I "%~1"=="A" goto STOP

echo ERREUR : commande inconnue "%~1".
goto USAGE


rem ========================================
rem L - LISTER LES MACHINES
rem ========================================
:LIST

echo.
echo ========================================
echo          LISTE DES MACHINES
echo ========================================
echo.

rem Creation du fichier contenant la liste
VBoxManage list vms > vms.txt

if errorlevel 1 (
    echo ERREUR : impossible de recuperer la liste des machines.
    goto END
)

rem Lecture du fichier avec FOR
for /F "tokens=1,*" %%A in (vms.txt) do (
    set "VM=%%~A"

    echo ----------------------------------------
    echo Machine : !VM!

    echo Date de creation :
    VBoxManage getextradata "!VM!" "%META_PREFIX%/CreationDate"

    echo Utilisateur :
    VBoxManage getextradata "!VM!" "%META_PREFIX%/Creator"

    echo.
)

del vms.txt

goto END


rem ========================================
rem N - CREER UNE MACHINE
rem ========================================
:CREATE

if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv4.bat N Debian3
    goto END
)

set "VM=%~2"
set "DISK=%USERPROFILE%\VirtualBox VMs\%VM%\%VM%.vdi"

echo.
echo Creation de la machine "%VM%"...

rem Verification si la machine existe deja
VBoxManage showvminfo "%VM%" >nul 2>&1

if %ERRORLEVEL% EQU 0 (
    echo ERREUR : la machine "%VM%" existe deja.
    goto END
)

rem Creation de la VM
VBoxManage createvm --name "%VM%" --ostype "%OSTYPE%" --register

if errorlevel 1 (
    echo ERREUR : impossible de creer la machine.
    goto END
)

echo Configuration de la RAM et du reseau...
VBoxManage modifyvm "%VM%" --memory %RAM% --nic1 nat

if errorlevel 1 (
    echo ERREUR : impossible de configurer la machine.
    goto END
)

echo Creation du disque de 64 GiB...
VBoxManage createmedium disk --filename "%DISK%" --size %DISK_SIZE%

if errorlevel 1 (
    echo ERREUR : impossible de creer le disque.
    goto END
)

echo Creation du controleur SATA...
VBoxManage storagectl "%VM%" --name "SATA Controller" --add sata --controller IntelAhci

if errorlevel 1 (
    echo ERREUR : impossible de creer le controleur SATA.
    goto END
)

echo Connexion du disque...
VBoxManage storageattach "%VM%" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "%DISK%"

if errorlevel 1 (
    echo ERREUR : impossible de connecter le disque.
    goto END
)

rem ========================================
rem Ajout des metadonnees
rem ========================================

set "CREATION_DATE=%DATE% %TIME%"
set "CREATOR=%USERNAME%"

echo Enregistrement des metadonnees...
VBoxManage setextradata "%VM%" "%META_PREFIX%/CreationDate" "%CREATION_DATE%"

if errorlevel 1 (
    echo ERREUR : impossible d'enregistrer la date de creation.
    goto END
)

VBoxManage setextradata "%VM%" "%META_PREFIX%/Creator" "%CREATOR%"

if errorlevel 1 (
    echo ERREUR : impossible d'enregistrer l'utilisateur.
    goto END
)

echo.
echo ========================================
echo       MACHINE CREEE AVEC SUCCES
echo ========================================
echo.
echo Machine      : %VM%
echo RAM          : %RAM% MB
echo Disque       : 64 GiB
echo Reseau       : NAT
echo Date         : %CREATION_DATE%
echo Utilisateur  : %CREATOR%
echo.

goto END


rem ========================================
rem S - SUPPRIMER UNE MACHINE
rem ========================================
:DELETE

if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv4.bat S Debian3
    goto END
)

set "VM=%~2"

echo.
echo Suppression de la machine "%VM%"...

VBoxManage showvminfo "%VM%" >nul 2>&1

if not %ERRORLEVEL% EQU 0 (
    echo ERREUR : la machine "%VM%" n'existe pas.
    goto END
)

VBoxManage unregistervm "%VM%" --delete

if errorlevel 1 (
    echo ERREUR : impossible de supprimer la machine.
    goto END
)

echo.
echo Machine "%VM%" supprimee avec succes.
goto END


rem ========================================
rem D - DEMARRER UNE MACHINE
rem ========================================
:START

if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv4.bat D Debian3
    goto END
)

set "VM=%~2"

echo.
echo Demarrage de la machine "%VM%"...

VBoxManage startvm "%VM%" --type gui

if errorlevel 1 (
    echo ERREUR : impossible de demarrer la machine.
    goto END
)

echo Machine "%VM%" demarree.
goto END


rem ========================================
rem A - ARRETER UNE MACHINE
rem ========================================
:STOP

if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv4.bat A Debian3
    goto END
)

set "VM=%~2"

echo.
echo Arret de la machine "%VM%"...

VBoxManage controlvm "%VM%" acpipowerbutton

if errorlevel 1 (
    echo ERREUR : impossible d'arreter la machine.
    goto END
)

echo Demande d'arret envoyee a "%VM%".
goto END


rem ========================================
rem UTILISATION
rem ========================================
:USAGE

echo.
echo ========================================
echo             UTILISATION
echo ========================================
echo.
echo genmv4.bat L
echo     Liste les machines avec leurs metadonnees.
echo.
echo genmv4.bat N nom
echo     Cree une machine et ses metadonnees.
echo.
echo genmv4.bat S nom
echo     Supprime une machine.
echo.
echo genmv4.bat D nom
echo     Demarre une machine.
echo.
echo genmv4.bat A nom
echo     Arrete une machine.
echo.

:END
endlocal