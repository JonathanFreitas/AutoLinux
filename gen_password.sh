################################
#!/bin/bash
#Jonathan Freitas
#
###############################

#echo -n "Qual tamanho da senha:"
#read senha
openssl rand 18 | openssl base64 -A
#echo $senha
