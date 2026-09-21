@echo off

echo ========================================
echo       PROJET VBOX - VERSION 2
echo ========================================
echo.

set "VM=Debian1"
set "DISK=%USERPROFILE%\VirtualBox VMs\%VM%\%VM%.vdi"

echo [1/6] Verification de l'existence de %VM%...
VBoxManage showvminfo "%VM%" >nul 2>&1

if %ERRORLEVEL% EQU 0 (
    echo La machine %VM% existe deja.
    echo Suppression de la machine existante...
    
    VBoxManage unregistervm "%VM%" --delete

    if errorlevel 1 (
        echo ERREUR : impossible de supprimer la machine existante.
        pause
        exit /b 1
    )

    echo Machine existante supprimee.
) else (
    echo Aucune machine %VM% existante.
)

echo.
echo [2/6] Creation de la machine %VM%...
VBoxManage createvm --name "%VM%" --ostype "Debian_64" --register

if errorlevel 1 (
    echo ERREUR : impossible de creer la machine.
    pause
    exit /b 1
)

echo [3/6] Configuration de la RAM et du reseau...
VBoxManage modifyvm "%VM%" --memory 4096 --nic1 nat

if errorlevel 1 (
    echo ERREUR : impossible de configurer la machine.
    pause
    exit /b 1
)

echo [4/6] Creation du disque virtuel de 64 GiB...
VBoxManage createmedium disk --filename "%DISK%" --size 65536

if errorlevel 1 (
    echo ERREUR : impossible de creer le disque.
    pause
    exit /b 1
)

echo [5/6] Creation du controleur SATA...
VBoxManage storagectl "%VM%" --name "SATA Controller" --add sata --controller IntelAhci

if errorlevel 1 (
    echo ERREUR : impossible de creer le controleur SATA.
    pause
    exit /b 1
)

echo [6/6] Connexion du disque...
VBoxManage storageattach "%VM%" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "%DISK%"

if errorlevel 1 (
    echo ERREUR : impossible de connecter le disque.
    pause
    exit /b 1
)

echo.
echo ========================================
echo       MACHINE CREEE AVEC SUCCES
echo ========================================
echo.
echo La machine %VM% est prete.
echo.

pause

echo.
echo Suppression de %VM%...
VBoxManage unregistervm "%VM%" --delete

if errorlevel 1 (
    echo ERREUR : impossible de supprimer la machine.
    pause
    exit /b 1
)

echo.
echo ========================================
echo       MACHINE SUPPRIMEE
echo ========================================
echo.

pause