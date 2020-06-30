@echo off
REM enviar convite de amizade na steam, pelo steamid, by Rafael Leao (rslgp)
REM friends since... http://steam.nyan.link/friends/
set /p "steam=arraste o steam.exe (Steam Client Bootstrapper): "
:loop1
set /p "id=insira o id steam64: "
"%steam%" -- steam://friends/add/%id%
cls
echo (sucesso no id %id%)
goto loop1
pause
