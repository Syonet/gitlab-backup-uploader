## Gitlab Backup Uploader
#### Script de upload dos backups do Gitlab para o Google Drive

--------

### Instruções de Instalação:

Copie o repositório para o diretório `home` do gitlab.

```
cd /home/git
git clone https://github.com/Syonet/gitlab-backup-uploader.git
```

Fazça o download do [Google Drive CLI](https://github.com/prasmussen/gdrive#installation). Para usar a versão 1.2.0:

```
wget https://drive.google.com/uc?id=0B3X9GlR6EmbnbEhlZ20xNGVWTVE -O drive
chmod a+x drive
sudo mv /home/git/drive /usr/bin/
```

Executa o Google Drive CLI e configura ele com a conta do Google Drive que receberá os arquivos. Ao executar, siga as instruções que aparecem no terminal.

```
drive
```

Depois de configurar o Drive CLI, crie um diretório no Google Drive, e obtenha o ID dele. Exemplo: se a URL do diretório no Google Drive é este:

```
https://drive.google.com/a/example.com/#folders/0B-3fHkgUCu5DZjJybWVOTkFIU3c
```

o ID do diretório é a parte que fica após `/#folders/`. Ou seja:

```
0B-3fHkgUCu5DZjJybWVOTkFIU3c
```

Com o ID em mãos, cadastre-o no arquivo de configuração.

Faça uma cópia do arquivo de configuração de exemplo:

```
cd /home/git/gitlab-backup-upload/conf
cp upload.cfg.exemplo upload.cfg
```

Edite o arquivo de configuração, e altera os seguintes itens:

* O parâmetro `GITLAB_BACKUPS` com o caminho completo do diretório onde ficam os backups do Gitlab.
* O parâmetro `GDRIVE_DIRETORIO` com o ID do diretório do Google Drive que vai receber os arquivos de backup.

Depois, basta colocar o script de upload no Crontab, em um horário que não interfira na utilização da internet:

```
# Faz o upload do backup mais recente do Gitlab para o Google Drive as 10 da noite.
0 22 * * * /home/git/gitlab/gitlab-backup-uploader/upload.sh
```

_____


### Licença

```
Copyright 2014 Syonet CRM

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
