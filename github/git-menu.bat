@echo off
REM criado por Rafael Leao (rslgp) - https://github.com/rslgp
SET git="%cd%"\git.exe
SET/P "ws= arraste a pasta do workspace: "

SET/P "user= escreva o usuario dono do repositorio: "

SET/P "nameRep= escreva o nome do repositorio: "

SET rep=https://github.com/%user%/%nameRep%
cd %ws%

%git% init

%git% clone %rep%

cd %ws%/%nameRep%
cls

SET/P "n= insira seu user do git: "
SET/P "e= insira seu email do git: "
%git% config --global user.name "%n%"
%git% config --global user.email %e%
cls

:MENU
ECHO.
echo 1 - (save-upload) salvar modificacoes e enviar
echo 2 - (status) verificar workspace
echo 3 - (new-switch) criar e modificar nova branch (desenvolvimento teste paralelo)
echo 4 - (switch branch) trocar entre master e branch
echo 5 - (merge) juntar branch/master
echo 6 - excluir branch
echo 7 - pull request
echo 8 - limpar a tela
echo 9 - realizar comando custom
echo 10 - rollback to older commit
echo 11 - erro 403 no permission (reset credentials)
echo 12 - criar branch saindo de uma branch
echo 13 - receber atualizacao na branch atual
echo 14 - atualizar de um fork
ECHO.

SET /P M=digite a opcao e aperte ENTER: 

set param=%M%
echo %param%|findstr /r "^[1-9][0-9]*$">nul 2>&1
if errorlevel 1 goto TELA

IF %M%==1 GOTO SAVE
IF %M%==2 GOTO CHECK
IF %M%==3 GOTO BRANCH
IF %M%==4 GOTO SWITCH
IF %M%==5 GOTO MERGE
IF %M%==6 GOTO DBRANCH
IF %M%==7 GOTO PULLR
IF %M%==8 GOTO TELA
IF %M%==9 GOTO CUSTOM
IF %M%==10 GOTO ROLLBACK
IF %M%==11 GOTO RESETCRED
IF %M%==12 GOTO BRANCH2BRANCH
IF %M%==13 GOTO GETLATESTBRANCH
IF %M%==14 GOTO FORKUPDATE

GOTO MENU

:SAVE
%git% add -A
SET/P "msg= insira a mensagem de modificacao: "
%git% commit -a -m "%msg%"
echo remote:
%git% branch -r
echo.
echo local:
%git% branch
echo.
SET/P "opBranch= escolha um branch acima para enviar: "
%git% push %rep% %opBranch%
GOTO MENU

:CHECK
%git% status
GOTO MENU

:BRANCH
SET/P "nomeBranch=insira o nome da branch: "
%git% checkout -b %nomeBranch%
GOTO MENU

:SWITCH
echo remote:
%git% branch -r
echo.
echo local:
%git% branch
echo.
SET/P "nomeSwitch=escolha um dos nomes acima e escreva o selecionar: "
%git% checkout %nomeSwitch%
GOTO MENU

:MERGE
echo remote:
%git% branch -r
echo.
echo local:
%git% branch
echo.
SET/P "nomeMOut=escolha um dos nomes acima para ser o output do merge e o escreva: "
SET/P "nomeMIn=escolha um dos nomes acima para ser o input do merge e o escreva: "
%git% checkout %nomeMOut%
%git% merge %nomeMIn%
GOTO MENU

:DBRANCH
echo remote:
%git% branch -r
echo.
echo local:
%git% branch
echo.
SET/P "nomeDBranch=escolha um dos nomes acima e escreva o selecionar: "
echo remote:
%git% branch -r
echo.
echo local:
%git% branch -D %nomeDBranch%
%git% push %rep% --delete %nomeDBranch%
GOTO MENU

:PULLR
echo -----para fazer o pull request precisa de navegador-----
echo va para o site %rep% e clique no botao fork
echo abra um novo git-menu e coloque 
echo. 
echo dono do repositorio (seu login): %n%  
echo e repositorio (projeto q deseja fazer pull): %nameRep% 
echo.
echo faca suas edicoes no segundo git-menu e salve (1)
echo entre no site: https://github.com/%n%/%nameRep%/compare
echo e confirme o seu pull
GOTO MENU

:TELA
cls
GOTO MENU


:CUSTOM
SET /P "comandoCustom=insira o comando e parametros q deseja fazer em git: ";
%git% %comandoCustom%
GOTO MENU


:ROLLBACK
SET /P "codigoSHA=insira o identificador de 7 digitos do commit q deseja ir pra ele: ";
%git% reset --hard %codigoSHA%

SET/P "opBranch= escolha um branch acima para enviar: "
%git% push -f %rep% %opBranch%
GOTO MENU


:RESETCRED
echo remova as credenciais existentes (erro 403, no permission)
rundll32.exe keymgr.dll, KRShowKeyMgr
GOTO MENU

:BRANCH2BRANCH
echo remote:
%git% branch -r
echo.
echo local:
%git% branch
SET/P "nomeBranch=insira o nome da branch nova: "
SET/P "nomeBranchBase=insira o nome da branch base: "
%git% checkout %nomeBranchBase%
%git% checkout -b %nomeBranch% %nomeBranchBase%
GOTO MENU

:GETLATESTBRANCH
echo remote:
%git% branch -r
echo.
echo (vc ira receber uma atualizacao) 
echo.
echo qual branch remota foi atualizada?
SET/P "nomeBranch=insira o nome da branch: "
%git% checkout %nomeBranch%
%git% pull %rep% %nomeBranch%
GOTO MENU


:FORKUPDATE
echo qual o repositorio do fork atualizado?
SET/P "repFork=repositorio fork atualizado: "
%git% remote add upstream %repFork%
%git% fetch upstream
REM %git% merge upstream/master

%git% add -A
SET/P "msg= insira a mensagem de modificacao: "
%git% commit -a -m "%msg%"
echo remote:
%git% branch -r
echo.
echo local:
%git% branch
echo.
SET/P "opBranch= escolha um branch acima para enviar: "
%git% push %rep% %opBranch%

GOTO MENU
