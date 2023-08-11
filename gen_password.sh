################################
#!/bin/bash
#Jonathan Freitas
#
###############################

echo -n "Qual tamanho da senha:"
read senha
sleep 2
openssl rand $senha | openssl base64 -A
#echo $senha
