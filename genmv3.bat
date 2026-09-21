@echo off
setlocal

rem ========================================
rem       PROJET VBOX - VERSION 3
rem ========================================

rem Variables de configuration
set "RAM=4096"
set "DISK_SIZE=65536"
set "OSTYPE=Debian_64"

rem Verification des arguments
if "%~1"=="" goto USAGE

rem ========================================
rem L - LISTER LES MACHINES
rem ========================================
if /I "%~1"=="L" goto LIST

rem ========================================
rem N - CREER UNE MACHINE
rem ========================================
if /I "%~1"=="N" goto CREATE

rem ========================================
rem S - SUPPRIMER UNE MACHINE
rem ========================================
if /I "%~1"=="S" goto DELETE

rem ========================================
rem D - DEMARRER UNE MACHINE
rem ========================================
if /I "%~1"=="D" goto START

rem ========================================
rem A - ARRETER UNE MACHINE
rem ========================================
if /I "%~1"=="A" goto STOP

echo ERREUR : commande inconnue "%~1".
goto USAGE


:LIST
echo.
echo ========================================
echo          LISTE DES MACHINES
echo ========================================
echo.
VBoxManage list vms
echo.
goto END


:CREATE
if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv3.bat N Debian2
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

echo.
echo ========================================
echo       MACHINE CREEE AVEC SUCCES
echo ========================================
echo.
goto END


:DELETE
if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv3.bat S Debian2
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


:START
if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv3.bat D Debian2
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


:STOP
if "%~2"=="" (
    echo ERREUR : le nom de la machine est obligatoire.
    echo Exemple : genmv3.bat A Debian2
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


:USAGE
echo.
echo ========================================
echo             UTILISATION
echo ========================================
echo.
echo genmv3.bat L
echo     Liste les machines virtuelles.
echo.
echo genmv3.bat N nom
echo     Cree une machine virtuelle.
echo.
echo genmv3.bat S nom
echo     Supprime une machine virtuelle.
echo.
echo genmv3.bat D nom
echo     Demarre une machine virtuelle.
echo.
echo genmv3.bat A nom
echo     Arrete une machine virtuelle.
echo.

:END
endlocal