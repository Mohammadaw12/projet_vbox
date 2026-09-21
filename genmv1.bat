@echo off

echo ========================================
echo       PROJET VBOX - VERSION 1
echo ========================================
echo.

echo [1/5] Creation de la machine Debian1...
VBoxManage createvm --name "Debian1" --ostype "Debian_64" --register

if errorlevel 1 (
    echo ERREUR : impossible de creer la machine.
    pause
    exit /b 1
)

echo [2/5] Configuration de la RAM et du reseau...
VBoxManage modifyvm "Debian1" --memory 4096 --nic1 nat

if errorlevel 1 (
    echo ERREUR : impossible de configurer la machine.
    pause
    exit /b 1
)

echo [3/5] Creation du disque virtuel de 64 GiB...
VBoxManage createmedium disk --filename "%USERPROFILE%\VirtualBox VMs\Debian1\Debian1.vdi" --size 65536

if errorlevel 1 (
    echo ERREUR : impossible de creer le disque.
    pause
    exit /b 1
)

echo [4/5] Creation du controleur SATA...
VBoxManage storagectl "Debian1" --name "SATA Controller" --add sata --controller IntelAhci

if errorlevel 1 (
    echo ERREUR : impossible de creer le controleur SATA.
    pause
    exit /b 1
)

echo [5/5] Connexion du disque...
VBoxManage storageattach "Debian1" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "%USERPROFILE%\VirtualBox VMs\Debian1\Debian1.vdi"

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
echo Verifie dans VirtualBox que Debian1
echo est bien presente.
echo.
pause

echo.
echo Suppression de Debian1...
VBoxManage unregistervm "Debian1" --delete

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