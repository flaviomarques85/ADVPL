#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"

User Function ZFIN001() //funcao main
	
	Local cPerg := "ZFIN001"  //Grupo de perguntas da SX1
	Local cDiret			  //Caminho e arquivo selecionado para processamento
	Local cLinha  := ""		  //Incremental que guarda a linha do arquivo
	Local lPrimlin   := .T.
	Local aCampos := {}		  //Array com o nome dos campos da tabela SE2
	Local aDados  := {}		  //Valores dos campos impordados do aquivo CSV
	Local i					  //Incremental usado no laço FOR
	 
	cDiret :=  cGetFile( 'Arquito CSV|*.csv| Arquivo TXT|*.txt| Arquivo XML|*.xml',; //[ cMascara], 
							 'Selecao de Arquivos',;                  				 //[ cTitulo], 
							 0,;                                      				 //[ nMascpadrao], 
							 'C:\TOTVS\',;                            				 //[ cDirinicial], 
							 .F.,;                                    				 //[ lSalvar], 
							 GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    				 //[ nOpcoes], 
							 .T.)         											 //[ Arvore do serv]

	FT_FUSE(cDiret)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
	 
		cLinha := FT_FREADLN()
	 
		If lPrimlin
			aCampos := Separa(cLinha,";",.T.)
			lPrimlin := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf
	 
		FT_FSKIP()
	EndDo
	//Se o arquivo tiver dados, chama as perguntas complementares
	//Num Titulo e Data de Vencimento
	Pergunte(cPerg,.T.,"Inclusão de Titulos Pag de Dividendos")
		
		For i:=1 to Len(aDados)
			IncProc("Importando Registros...")
			dbSelectArea('SE2')
			dbSetOrder(1)
			dbGoTop()
			If (!dbSeek(xFilial('SE2')+"SOC"+MV_PAR01)) //Verifica se ja tem o titulo com mesma chave na base
				
				Reclock('SE2',.T.)
					SE2->E2_PREFIXO := "SOC"
					SE2->E2_NUM		:= MV_PAR01 //pergunta
					SE2->E2_TIPO	:= "RC"
					SE2->E2_NATUREZ := "5.05"
					SE2->E2_FORNECE := aDados[i,5]
					SE2->E2_LOJA	:= "01"
					SE2->E2_NOMFOR	:= POSICIONE("SA2",1,XFILIAL("SA2")+aDados[i,5]+"01",'A2_NOME')
					SE2->E2_EMISSAO := Date()
					SE2->E2_VENCTO	:= MV_PAR02 //pergunta
					SE2->E2_VENCREA := MV_PAR02 //pergunta
					SE2->E2_VALOR	:= Val(aDados[i,6])
					SE2->E2_SALDO	:= Val(aDados[i,6])
					SE2->E2_PORTADO := "341"
					SE2->E2_HIST	:= "DIST LUCRO "+cValToChar(POSICIONE("SA2",1,XFILIAL("SA2")+aDados[i,5]+"01",'A2_NOME'))
					SE2->E2_ORIGEM	:= "ZFIN001"
					SE2->E2_EMIS1	:= Date()
					SE2->E2_VLCRUZ	:= Val(aDados[i,6])
					SE2->E2_BASECOF := Val(aDados[i,6])
					SE2->E2_BASEPIS := Val(aDados[i,6])
					SE2->E2_BASECSL := Val(aDados[i,6])
				MsUnlock()
				
			Else
				MsgAlert("Titulo "+MV_PAR01+" Ja Existe, escolha outro numero.","Erro na Inclusão")
				Return //Finaliza a rotina sem incluir titulos.
		
			EndIf
			DbCloseArea() 
		Next i
	//Apresenta msg da inclusão bem sucedida.
	MsgInfo("Importacao concluida com sucesso!"+chr(13)+;
			  "Foram incluidos : "+cValToChar(len(aDados))+" Titulos";	
			  ,"Sucesso!")
			  
Return //finaliza funcao main

