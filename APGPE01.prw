#include 'protheus.ch'
#include 'parmtype.ch'


user function APGPE01()
	Private cPerg := "APGPE01"
	Private lRet  := .F.
	
	AjustaSX1()
	lRet := Pergunte(cPerg,.T.,"Aprovação automatica das Marcações do Portal")
	If lRet
		Processar()
	EndIf
Return

Static Function Processar()
	LOCAL lOk   := .F.
	LOCAL nCont := 0
	
	DbSelectArea("RH3")
	DbSetOrder(1)	
	DbGoTop()

	While !EOF()
		IF (RH3->RH3_FILIAL >= mv_par01 .AND. RH3->RH3_FILIAL <= mv_par02)
			IF (RH3->RH3_DTSOLI >= mv_par03 .AND. RH3->RH3_DTSOLI <= mv_par04 .AND. RH3->RH3_STATUS == '1')
				RecLock("RH3",.F.) //Bloqueia Registro
					Rh3->RH3_STATUS := '4'
					lOk := .T.
					nCont++
				MsUnLock()  //Desbloqueia o registro
			ENDIF
		ENDIF
		DbSkip()
	EndDo
	
	      
	DbCloseArea()   //Fecha Area RH3
	
	IF !lOk
		MsgInfo("Não Foram encontrado registros com os parametros passados!","Resultado")
	ELSE
		MsgInfo("Marcações aprovadas: "+cValtoChar(nCont),"Resultado")
	ENDIF
Return

             
	
Static Function AjustaSX1()

	PutSx1(cPerg,"01","Da Filial				?","","","mv_ch1","C",02,00,01,"G","","SM0" 	,"","","mv_par01",""	,"","","",""	,"","",""		,"","","","","","","","",{ OemToAnsi("Define a Filial Inicial")}  , {}, {} )
	PutSx1(cPerg,"02","Até a Filial				?","","","mv_ch2","C",02,00,01,"G","","SM0" 	,"","","mv_par02",""	,"","","",""	,"","",""		,"","","","","","","","",{ OemToAnsi("Define a Filial Final")}, {}, {} )
	PutSx1(cPerg,"03","Da Emissão				?","","","mv_ch3","D",08,00,01,"G","","" 		,"","","mv_par03",""	,"","","",""	,"","",""		,"","","","","","","","",{ OemToAnsi("Define a Data de Emissão Inicial")}, {}, {} )
	PutSx1(cPerg,"04","Até a Emissão			?","","","mv_ch4","D",08,00,01,"G","","" 		,"","","mv_par04",""	,"","","",""	,"","",""		,"","","","","","","","",{ OemToAnsi("Define a Data de Emissão Final")}  , {}, {} )
Return	
