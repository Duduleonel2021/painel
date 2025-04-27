@echo off
chcp 65001 >nul
color 0A
title Painel de Manutenção - Windows 11

:: Versão local
set "VERSAO_LOCAL=1.0"

:: Verificar Atualizações
echo.
echo Verificando atualizações do Painel de Manutenção...
curl -s -o versao_remota.txt https://raw.githubusercontent.com/Duduleonel2021/main/versao.txt

if exist versao_remota.txt (
    set /p VERSAO_REMOTA=<versao_remota.txt
    if not "%VERSAO_REMOTA%"=="" (
        if not "%VERSAO_LOCAL%"=="%VERSAO_REMOTA%" (
            echo.
            echo Atualização disponível! (v%VERSAO_REMOTA%)
            echo Baixando nova versão...
            curl -s -o PainelManutencaoNovo.bat https://raw.githubusercontent.com/Duduleonel2021/main/PainelManutencao.bat
            if exist PainelManutencaoNovo.bat (
                echo Substituindo arquivo antigo...
                move /y PainelManutencaoNovo.bat PainelManutencao.bat >nul
                echo Atualização concluída! Reiniciando o Painel...
                start "" PainelManutencao.bat
                exit
            ) else (
                echo Erro ao baixar a nova versão!
            )
        ) else (
            echo Você já está usando a versão mais recente.
        )
    ) else (
        echo Erro ao verificar a versão online.
    )
    del versao_remota.txt
) else (
    echo Não foi possível verificar atualizações.
)
timeout /t 2 >nul

:MENU
cls
echo =========================================================
echo              Painel de Manutenção do Windows
echo =========================================================
echo Versão atual: %VERSAO_LOCAL%
echo.
echo  [1] DISM - CheckHealth
echo  [2] DISM - ScanHealth
echo  [3] DISM - RestoreHealth
echo  [4] Verificar Arquivos do Sistema (SFC)
echo  [5] Verificar Disco (C:)
echo  [6] Verificar Disco (D:)
echo  [7] Verificar Disco (E:)
echo  [8] Resetar Winsock
echo  [9] Limpar Cache de DNS
echo [10] Executar Verificador de Malware (MRT)
echo [11] Verificar Memória RAM (mdsched)
echo [12] Recuperar Inicialização (bootrec)
echo [13] Atualizar Programas (Winget)
echo [14] Atualizar Todos Programas (Winget --all)
echo [15] Atualizar Drivers (Windows Update)
echo.
echo  [0] Sair
echo =========================================================
set /p opcao=Escolha uma opção:

if "%opcao%"=="1" (
    DISM /Online /Cleanup-Image /CheckHealth
) else if "%opcao%"=="2" (
    DISM /Online /Cleanup-Image /ScanHealth
) else if "%opcao%"=="3" (
    DISM.exe /Online /Cleanup-Image /Restorehealth
) else if "%opcao%"=="4" (
    sfc /scannow
) else if "%opcao%"=="5" (
    chkdsk C: /f /r
) else if "%opcao%"=="6" (
    chkdsk D: /f /r
) else if "%opcao%"=="7" (
    chkdsk E: /f /r
) else if "%opcao%"=="8" (
    netsh winsock reset
) else if "%opcao%"=="9" (
    ipconfig /flushdns
) else if "%opcao%"=="10" (
    start mrt
) else if "%opcao%"=="11" (
    mdsched
) else if "%opcao%"=="12" (
    call :BOOTREC_MENU
) else if "%opcao%"=="13" (
    winget upgrade
) else if "%opcao%"=="14" (
    winget upgrade --all
) else if "%opcao%"=="15" (
    start ms-settings:windowsupdate
) else if "%opcao%"=="0" (
    exit
) else (
    echo Opção inválida! Tente novamente.
    timeout /t 2 >nul
)
goto MENU

:BOOTREC_MENU
cls
echo =========================================================
echo                Recuperação de Inicialização
echo =========================================================
echo [1] BOOTREC /FIXMBR
echo [2] BOOTREC /FIXBOOT
echo [3] BOOTREC /RebuildBcd
echo [0] Voltar
echo =========================================================
set /p bootrecopcao=Escolha uma opção:

if "%bootrecopcao%"=="1" (
    bootrec /fixmbr
) else if "%bootrecopcao%"=="2" (
    bootrec /fixboot
) else if "%bootrecopcao%"=="3" (
    bootrec /rebuildbcd
) else if "%bootrecopcao%"=="0" (
    goto MENU
) else (
    echo Opção inválida! Tente novamente.
    timeout /t 2 >nul
    goto BOOTREC_MENU
)
goto MENU
