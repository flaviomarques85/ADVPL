#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"

User Function ZFIN002()
    
    LOCAL cPerg  := "ZFIN002"
    LOCAL cAlias := GetNextAlias()
    PRIVATE aCab   := {}
    PRIVATE aDados := {}

    Pergunte(cPerg,.T.,"Relatorio Titulos a receber")

    BEGINSQL Alias cAlias
        SELECT E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VENCORI, E1_VENCREA, E1_VALOR, E1_SALDO, E5_MOTBX
        FROM %table:SE1% SE1, %table:SE5% SE5
        WHERE SE1.D_E_L_E_T_ = ''
        AND SE5.D_E_L_E_T_ = ''
        AND SE5.E5_RECPAG = 'R'
        AND E5_NUMERO+E5_PARCELA = E1_NUM+E1_PARCELA
        AND E1_EMISSAO >= %exp:(MV_PAR01)%
        AND E1_EMISSAO <= %exp:(MV_PAR02)%
    ENDSQL

    AADD(aCab, {"Numero"		,"C", 09, 0})
    AADD(aCab, {"Parcela"	    ,"C", 03, 0})
    AADD(aCab, {"TP"		    ,"C", 05, 0})
    AADD(aCab, {"Cod Cliente"	,"C", 06, 0})
    AADD(aCab, {"Loja"		    ,"C", 03, 0})
    AADD(aCab, {"Nome Cli"		,"C", 20, 0})
    AADD(aCab, {"Dt Emissao" 	,"D", 08, 0})
    AADD(aCab, {"Dt Venc"	    ,"D", 08, 0})
    AADD(aCab, {"Dt Venc Real"	,"D", 08, 0})
    AADD(aCab, {"Valor"	        ,"N", 18, 2})
    AADD(aCab, {"Saldo"	        ,"N", 18, 2})
    AADD(aCab, {"Mot Baixal"	,"C", 05, 0})
    

    While !(cAlias)->(EOF())
        AADD( aDados,{E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VENCORI, E1_VENCREA, E1_VALOR, E1_SALDO, E5_MOTBX} )
        DBSKIP()
    end

    MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS","POSICAO",aCab,aDados}})})
    DbCloseArea() 
Return 