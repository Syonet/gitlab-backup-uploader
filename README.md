Para instalar:


### Gera chave SSH do usuário `git` e instala como Deploy Key no Gitlab.com

```
ssh-keygen
```

Baixar o Google Drive CLI

https://github.com/prasmussen/gdrive#installation

Para usar a versão 1.2.0:

```
wget https://drive.google.com/uc?id=0B3X9GlR6EmbnbEhlZ20xNGVWTVE -O drive
chmod a+x drive
sudo mv /home/git/drive /usr/bin/
```

Executa o Google Drive CLI e configura ele com a conta do Google Drive que receberá os arquivos.

```
drive
```

Cria um diretório no Google Drive, e obtém o ID dele. Coloca o ID no arquivo de configuração

Faz uma cópia do arquivo de configuração de exemplo.

```
cd /home/git/gitlab-backup-upload/conf
cp upload.cfg.exemplo upload.cfg
```

Edita o arquivo de configuração, e altera os seguintes itens:

* O parâmetro `GITLAB_BACKUPS` com o caminho completo do diretório onde ficam os backups do Gitlab.
* O parâmetro `GDRIVE_DIRETORIO` com o ID do diretório do Google Drive que vai receber os arquivos de backup.

Depois, basta colocar o script de upload no Crontab, em um horário que não interfira na utilização da internet:

```
# Create a full backup of the GitLab repositories and SQL database every day at 0am,8am,1pm and 7pm.
0 0,8,13,19 * * * cd /home/git/gitlab && PATH=/usr/local/bin:/usr/bin:/bin bundle exec rake gitlab:backup:create RAILS_ENV=production

# Faz o upload do backup mais recente do Gitlab para o Google Drive as 10 da noite.
0 22 * * * /home/git/gitlab/gitlab-backup-upload/upload.sh
```

