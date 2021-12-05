#!/bin/bash
echo "---> Variável inexistente"
cat testeVarInexistente.pvl 
./provol-one < testeVarInexistente.pvl

echo -e "\n---> INC com erros de sintaxe"
cat testeErroINC.pvl
./provol-one < testeErroINC.pvl

echo -e "\n---> DEC com erros de sintaxe"
cat testeErroDEC.pvl
./provol-one < testeErroDEC.pvl

echo -e "\n---> ZERA com erros de sintaxe"
cat testeErroZERA.pvl
./provol-one < testeErroZERA.pvl

echo -e "\n---> ENQUANTO com erros de sintaxe"
cat testeErroENQUANTO.pvl
./provol-one < testeErroENQUANTO.pvl

echo -e "\n---> Erros diversos"
cat testeErros.pvl
./provol-one < testeErros.pvl

echo -e "\n---> Sem erros"
cat teste.pvl
./provol-one < teste.pvl
