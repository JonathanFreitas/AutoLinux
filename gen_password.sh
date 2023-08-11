################################
#!/bin/bash
#Jonathan Freitas
#
###############################

echo -n "Qual tamanho da senha:"
read senha
openssl rand $senha | openssl base64 -A
#echo $senha
