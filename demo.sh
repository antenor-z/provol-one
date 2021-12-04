#!/bin/bash
echo "---> Variável inexistente"
cat testeVarInexistente.pvl 
./provol-one < testeVarInexistente.pvl

echo -e "\n---> INC com erros de sintaxe"
cat testeErroINC.pvl
./provol-one < testeErroINC.pvl

echo -e "\n---> ZERA com erros de sintaxe"
cat testeErroZERA.pvl
./provol-one < testeErroZERA.pvl

echo -e "\n---> ENQUANTO com erros de sintaxe"
cat testeErroENQUANTO.pvl
./provol-one < testeErroENQUANTO.pvl
