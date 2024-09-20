###############################################################
export
############################################################
#!/bin/bash

# Definindo as variáveis
USER="postgres"
BACKUP_DIR="/bkp-postgres"  # Diretório onde os backups serão salvos


# Lista de bancos de dados
DATABASES=("")

rm -Rf /bkp-postgres/*.backup

# Exportar cada banco de dados
for DB in "${DATABASES[@]}"; do
    echo "Exportando o banco de dados: $DB"
     sudo -u $USER pg_dump -F c -b -v -f  "$BACKUP_DIR/${DB}.backup" $DB
done

###################################################################
IMPORT
###################################################################
#!/bin/bash

# Definindo as variáveis
USER="postgres"
BACKUP_DIR="/bkp-postgres"  # Diretório onde os backups estão localizados
NEW_OWNER="prd_slogin"


# Lista de bancos de dados
DATABASES=("")

# Loop através de cada banco de dados
for DB in "${DATABASES[@]}"; do
    # Adiciona aspas duplas ao redor do nome do banco de dados
    DB_QUOTED="\"$DB\""

    # Dropar o banco de dados se existir
    echo "Droppando o banco de dados: $DB"
    sudo -u $USER psql -c "DROP DATABASE IF EXISTS $DB_QUOTED;"

    if [ $? -eq 0 ]; then
        echo "Banco de dados $DB droppado com sucesso!"
    else
        echo "Erro ao droppar o banco de dados $DB."
        continue
    fi

    # Criar o novo banco de dados
    echo "Criando o banco de dados: $DB"
    sudo -u $USER psql -c "CREATE DATABASE $DB_QUOTED;"

    if [ $? -eq 0 ]; then
        echo "Banco de dados $DB criado com sucesso!"
    else
        echo "Erro ao criar o banco de dados $DB."
        continue
    fi

    # Importar o banco de dados a partir do arquivo de backup com --no-owner
    BACKUP_FILE="$BACKUP_DIR/${DB}.backup"
    echo "Importando o banco de dados a partir de $BACKUP_FILE"

    if [ -f "$BACKUP_FILE" ]; then
        sudo -u $USER pg_restore --no-owner -d $DB "$BACKUP_FILE"
        sudo -u $USER psql -c "ALTER DATABASE \"$DB\" OWNER TO $NEW_OWNER;"
        if [ $? -eq 0 ]; then
            echo "Banco de dados $DB importado com sucesso!"
        else
            echo "Erro ao importar o banco de dados $DB."
        fi
    else
        echo "Arquivo de backup $BACKUP_FILE não encontrado."
    fi

done

#############################################################
JENKINS
#############################################################

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
                        rm -Rf /bkp-postgres/*.backup
                        bash /bkp-postgres/export-postgres.sh
                        ls -Alh /bkp-postgres/
  
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
                        sshpass -p "" scp /bkp-postgres/*.backup root@10.111://bkp-postgres/
                        

                        
                        
                        
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
                        bash /bkp-postgres/import-bkp.sh
                        rm -Rf /bkp-postgres/*.backup
                        
                        
                        

                        
                        
                        
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
