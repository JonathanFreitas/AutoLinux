#############################################
EXPORT
###########################################
#!/bin/bash

# Definindo as variáveis
HOST="localhost"
USER="root"
PASSWORD=""
OUTPUT_DIR="/bkp/"

export MYSQL_PWD=$PASSWORD

rm -Rf /bkp/*.sql
# Lista de bancos de dados a serem backupados
DATABASES=("")

# Criar diretório de saída se não existir
mkdir -p $OUTPUT_DIR

# Loop para fazer backup de cada banco de dados
for DB in "${DATABASES[@]}"; do
    echo "Iniciando backup do banco: $DB"

    # Comando mysqldump para gerar o backup
    mysqldump -h $HOST -u $USER $DB > $OUTPUT_DIR/${DB}_backup.sql
done

unset MYSQL_PWD

###############################################
IMPORT
###############################################
#!/bin/bash

# Definindo as variáveis de conexão ao MySQL
HOST="localhost"
USER="root"
PASSWORD=""  # Senha do MySQL
BKPDIR="/bkp"         # Diretório onde estão os backups

# Usando variáveis de ambiente para evitar mostrar a senha no comando
export MYSQL_PWD=$PASSWORD

mkdir $BKPDIR

# Lista de arquivos de backup
BACKUP_FILES=("" "" "")

# Importar cada banco de dados
for FILE in "${BACKUP_FILES[@]}"; do
    # Extrair o nome do banco de dados removendo "_backup.sql"
    DB_NAME=$(basename "$FILE" _backup.sql)

    echo "Importando o banco de dados: $DB_NAME a partir de $FILE"

    # Comando para dropar e criar o banco de dados (se não existir), usando backticks para escapar o nome do banco de dados
    mysql -h $HOST -u $USER -e "DROP DATABASE IF EXISTS \`$DB_NAME\`;"
    mysql -h $HOST -u $USER -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

    if [ $? -eq 0 ]; then
        # Importar o conteúdo do arquivo SQL para o banco de dados sem usar crases aqui
        mysql -h $HOST -u $USER $DB_NAME < $BKPDIR/$FILE

        if [ $? -eq 0 ]; then
            echo "Banco de dados $DB_NAME importado com sucesso!"
        else
            echo "Erro ao importar o banco de dados $DB_NAME."
        fi
    else
        echo "Erro ao criar o banco de dados $DB_NAME."
    fi
done

# Limpar a variável de ambiente da senha
unset MYSQL_PWD
rm -Rf /bkp/*.sql

#####################################################
JENKINS
#########################################################
pipeline {

    agent any
    
    environment {
		// SCRIPT DE IMPORTAÇÃO BANCO MYSQL
		
		//CREDENCIAIS PARA ACESSO REMOTO
        SSH_USER = 'root'
        SSH_PEM = credentials('')
        SSH_HOST1 = '' 
		SSH_HOST2 = '' 
        REPO_PROD = '/root/Jenkins'
		
	}
	
	stages {
	
	
		stage('Realizando o dump') {
			
            steps{
                script {
                        
                    def comandosSSH = """
                        rm -Rf /bkp/*.sql
                        bash /bkp/bkp-mysql.sh
                        ls -Alh /bkp/
  
                    """
                    
                    def sshCommand = """
                        ssh -T -o StrictHostKeyChecking=no -i ${SSH_PEM} ${SSH_USER}@${SSH_HOST1} << 'EOF'
                            ${comandosSSH}
                            
                    """
                    sh sshCommand

                    
                }
            }
		}
		
        stage('Enviando novo servidor') {
			
            steps{
                script {
                        
                    def comandosSSH = """
                        sshpass -p "" scp /bkp/*.sql root@0:/bkp/
                        

                        
                        
                        
                    """
                    
                    def sshCommand = """
                        ssh -T -o StrictHostKeyChecking=no -i ${SSH_PEM} ${SSH_USER}@${SSH_HOST1} << 'EOF'
                            ${comandosSSH}
                            
                    """
                    sh sshCommand

                    
                }
            }
		}

        stage('Importando para novo servidor') {
			
            steps{
                script {
                        
                    def comandosSSH = """
                        bash /bkp/import-bkp.sh
                        
                        

                        
                        
                        
                    """
                    
                    def sshCommand = """
                        ssh -T -o StrictHostKeyChecking=no -i ${SSH_PEM} ${SSH_USER}@${SSH_HOST2} << 'EOF'
                            ${comandosSSH}
                            
                    """
                    sh sshCommand

                    
                }
            }
		}

	}

}
################################################################

