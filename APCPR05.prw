#INCLUDE "Protheus.CH"
#INCLUDE "Topconn.CH"

/*/
+-----------------------------------------------------------------------------+
| Programa  APCPR05    | Desenvolvedor | Márcio R. Maia    | Data | 05/07/2012|
|-----------------------------------------------------------------------------|
| Descricao | Relatório de Ordem de fabricação								  |                                                    
|-----------------------------------------------------------------------------|
| Uso       | Exclusivo Prodap												  |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  |
+--------------+-----------+--------------------------------------------------+
/*/

User Function APCPR05
*******************************************************************************
****
*******************************************************************************
	
	Local oReport 
	
	Private cOrdIni		:= Space(6)
	Private cOrdFim		:= Space(6)
	Private cItemIni	:= Space(2)
	Private cItemFim	:= Space(2)
	Private cD4Atu		:= Space(15)
	Private cOrdAtu		:= Space(6)
	Private nTotMicro	:= 0
	Private nTotMacro	:= 0
	Private nTotPeso    := 0
	Private nTotMin     := 0
	Private nTotMax     := 0
	Private nTotBat		:= 0
	Private nQtdBat		:= 0
	Private nQdtEmb1    := 0
	Private nQdtEmb2    := 0
	Private nQtdInf     := 0
	Private cEmbalag	:= ""
	Private cEmbalag2	:= ""
	Private cProduto	:= ""
	Private cLote       := "" 
	Private nConsumo	:= 0
	Private lTemMicro	:= .F.
	Private lTemMacro	:= .F. 
	Private nPeso       := 0 
	Private cEmbal2     := ""
	Private lTemSoja    := .F.
	Private cTotPeso    := ""
	Private cTxtSoja    := ""
	Private cTxtBag     := ""
	
	Private oFont01		:= TFont():New("Arial",,15,,.F.,,,,.F.,.F.)	
	
	//Interface de impressao
	oReport:= ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()
*******************************************************************************
****
*******************************************************************************
	
	Local cTitle   := "Ordem de Produção" 
	
	If Alltrim(FunName()) == "MATA650"
		cOrdIni := SC2->C2_NUM
		cOrdFim := SC2->C2_NUM
		cItemIni:= "  "
		cItemFim:= "ZZ"
	Else
		AjustaSX1()
		Pergunte("APCPR05",.T.)
		cOrdIni := MV_PAR01
		cOrdFim := MV_PAR02
		cItemIni:= MV_PAR03
		cItemFim:= MV_PAR04
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao do componente de impressao                                      ³
	//³                                                                        ³
	//³TReport():New                                                           ³
	//³ExpC1 : Nome do relatorio                                               ³
	//³ExpC2 : Titulo                                                          ³
	//³ExpC3 : Pergunte                                                        ³
	//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
	//³ExpC5 : Descricao                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oReport:= TReport():New("APCPR05",cTitle,"APCPR05", {|oReport| ReportPrint(oReport)},"Ordem de Produção") 
	oReport:SetLandScape()
	oReport:HideParamPage()
	oReport:HideFooter()
	oReport:SetLineHeigth(70)
	OReport:nFontBody := 9
	//oReport:SetTotalInLine(.F.) 

	oSection1:= TRSection():New(oReport,"Ordem de Produção",{""},/*aOrdem*/)
	oSection1:SetReadOnly() 
	
	oSection2:= TRSection():New(oReport,"Ordem de Produção",{""},/*aOrdem*/)
	oSection2:SetReadOnly()
	
	oSection3:= TRSection():New(oReport,"Ordem de Produção",{""},/*aOrdem*/)
	oSection3:SetReadOnly()
	oSection3:SetCellBorder("ALL",,,.T.)
	oSection3:SetCellBorder("RIGHT")
	oSection3:SetCellBorder("LEFT")
	oSection3:SetCellBorder("BOTTOM") 
	//oSection2:SetLineBreak(.T.)
	
	oSection4:= TRSection():New(oReport,"Ordem de Produção",{""},/*aOrdem*/)
	oSection4:SetReadOnly()
	
	oSection5:= TRSection():New(oReport,"Ordem de Produção",{""},/*aOrdem*/)
	oSection5:SetReadOnly()                                                 
	
	TRCell():New(oSection1,"ORDEM"   	,"","OP"						,/*Picture*/,20,/*lPixel*/,{|| cOrdem }		,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1,"PRODUTO"	,"","Produto"  					,/*Picture*/,100,/*lPixel*/,{|| cCodProd+ " " +cProduto }	,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1,"EMBALAGEM" 	,"","Embalagem"      			,/*Picture*/,80,/*lPixel*/,{|| cEmbal }   	,"LEFT"		,/*lLineBreak*/	,"LEFT"	,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection1,"PESO"  		,"","Peso"		  				,/*Picture*/,20,/*lPixel*/,{|| nPeso }  	,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/) 
	TRCell():New(oSection1,"BATELADAS"  ,"","Bateladas"  				,/*Picture*/,20,/*lPixel*/,{|| nBatel }  	,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/) 
	TRCell():New(oSection1,"SC BATELADAS"  ,"","Sc Bateladas"  			,/*Picture*/,20,/*lPixel*/,{|| nQtdInf }  	,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	////Saltar uma linha
   	TRCell():New(oSection2,"QTDESPERADA"   	,"",""						,/*Picture*/,30,/*lPixel*/,{|| cQtdEsp }	,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
   	TRCell():New(oSection2,"LIMPMIST"   	,"",""						,/*Picture*/,30,/*lPixel*/,{|| cLimpM }		,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
   	TRCell():New(oSection2,"PALETE"			,"","" 						,/*Picture*/,40,/*lPixel*/,{|| cPalete }	,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection2,"VALSC" 			,"",""    		  			,/*Picture*/,30,/*lPixel*/,{|| cTotPeso }   ,"LEFT"		,/*lLineBreak*/	,"LEFT"	,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection2,"TXTSOJA" 			,"",""    	  			,/*Picture*/,30,/*lPixel*/,{|| cTxtSoja }   ,"LEFT"		,/*lLineBreak*/	,"LEFT"	,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection2,"TXTBAG" 			,"",""   	  			,/*Picture*/,30,/*lPixel*/,{|| cTxtBag }   ,"LEFT"		,/*lLineBreak*/	,"LEFT"	,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	TRCell():New(oSection3,"CODMP" 		,"","Cod.MP"  					,/*Picture*/			,10,/*lPixel*/,{|| cCodMP }		,"CENTER"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"DESCMP"		,"","Descr.MP"	  				,/*Picture*/			,15,/*lPixel*/,{|| cDescMP }  	,"LEFT"		,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"LOTE"		,"","Lote" 						,/*Picture*/			,15,/*lPixel*/,{|| cLote   }  			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"VALOR"    	,"","Valor"  					,"@E 99,999,999.9999"			,08,/*lPixel*/,{|| nValor }   	,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"TOLMIN"  	,"","Toler.Min." 				,"@E 99,999,999.9999"			,08,/*lPixel*/,{|| nTolMin }    ,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"TOLMAX"  	,"","Toler.Max."				,"@E 99,999,999.9999"			,08,/*lPixel*/,{|| nTolMax }	,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"CONSUL"  	,"","Consumo"					,"@E 99,999,999.9999"			,09,/*lPixel*/,{|| nConsumo }	,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	                                                                               
	TRCell():New(oSection3,"01"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"02"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"03"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"04"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"05"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"06"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"07"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"08"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"09"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection3,"10"  		,"",""							,/*Picture*/	,11,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSection2,"11"  		,"",""							,/*Picture*/	,12,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSection2,"12"  		,"",""							,/*Picture*/	,12,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSection2,"13"  		,"",""							,/*Picture*/	,12,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSection2,"14"  		,"",""							,/*Picture*/	,12,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSection2,"15"  		,"",""							,/*Picture*/	,12,/*lPixel*/,{|| }			,"RIGHT"	,/*lLineBreak*/	,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)	
	
	TRCell():New(oSection4,"MSG01"  	,"",""							,/*Picture*/	,160,/*lPixel*/, 				,"LEFT"	,.T.,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	                     
	TRCell():New(oSection5,"MSG02"  	,"",""							,/*Picture*/	,160,/*lPixel*/, 				,"LEFT"	,.T.,"CENTER",/*lCellBreak*/,/*nColSpace*/,.T.,/*nClrBack*/,/*nClrFore*/,/*lBold*/)	
	
	oBreak1 := TRBreak():New(oSection3,"","TOTAL DE MICRO ELEMENTOS (KG)")
	oBreak2 := TRBreak():New(oSection3,"","TOTAL DE MACRO ELEMENTOS (KG)")
	oBreak3 := TRBreak():New(oSection3,"","TOTAL FORMULACAO(KG)")
	
	oFunction1 := TRFunction():New(oSection3:Cell("VALOR") 	,NIL,"ONPRINT",oBreak1,/*cTitle*/,"@R 99999.999",{|| nTotMicro}				,.F.,.F.,.F.,/*oTrSection*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)	
	oFunction1 := TRFunction():New(oSection3:Cell("TOLMIN") ,NIL,"ONPRINT",oBreak1,/*cTitle*/,"@R 99999.999",{|| nTotMin}				,.F.,.F.,.F.,/*oTrSection*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
	oFunction1 := TRFunction():New(oSection3:Cell("TOLMAX") ,NIL,"ONPRINT",oBreak1,/*cTitle*/,"@R 99999.999",{|| nTotMax}				,.F.,.F.,.F.,/*oTrSection*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
	oFunction2 := TRFunction():New(oSection3:Cell("VALOR") 	,NIL,"ONPRINT",oBreak2,/*cTitle*/,"@R 99999.999",{|| nTotMacro}				,.F.,.F.,.F.,/*oTrSection*/,/*bCondition*/,/*lDisable*/,{|| nTotMacro > 0})
	oFunction3 := TRFunction():New(oSection3:Cell("VALOR") 	,NIL,"ONPRINT",oBreak3,/*cTitle*/,"@R 99999.999",{|| nTotMicro + nTotMacro}	,.F.,.F.,.F.,/*oTrSection*/,/*bCondition*/,/*lDisable*/,{|| nTotMacro > 0})
	                                                                                
Return(oReport)

Static Function ReportPrint(oReport)
*******************************************************************************
****
*******************************************************************************

	Local nTotReg	:= 0
	Local aDados	:= {}
	Local nRep		:= 0

	Local nOrdem
	Local aMicro := {}
	Local nPos   := 0
	
	Private oSection1	:= oReport:Section(1)
	Private oSection2	:= oReport:Section(2)
	Private oSection3	:= oReport:Section(3)
	Private oSection4	:= oReport:Section(4)
	Private oSection5	:= oReport:Section(5)

	nTotMicro := 0
	nTotMacro := 0
	nTotMin     := 0
	nTotMax     := 0
	nQtdBat   := 0
	nQtdInf   := 0
	nTotGer   := 0
	cEmbalag  := ""
	cEmbalag2  := ""
	cProduto  := ""
	nQdtEmb1    := 0
	nQdtEmb2    := 0 
	lTemSoja    := .F.
	nTotPeso  := 0
	cTxtSoja    := ""
	cTxtBag     := ""
	cTotPeso    := ""
	cLimpM      := ""
	
	dbSelectArea("SC2")
	dbSetOrder(1)  // Filial+Cod+Item
	dbSeek(xFilial("SC2")+cOrdIni+cItemIni,.T.) 
	 
	While !Eof() .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->C2_NUM <= cOrdFim //.And. SC2->C2_ITEM <= cItemFim
	
		cOrdAtu := SC2->C2_NUM
		nTotMicro := 0
		nTotMacro := 0
		nTotPeso  := 0
		nTotMin     := 0
		nTotMax     := 0
		nTotBat   := 0 
		nQtdBat   := 0
		nQtdInf   := 0
		nTotGer   := 0
		cEmbalag  := ""
		cEmbalag2  := ""
		cProdEst  := ""
		cProduto  := ""
		nQdtEmb1    := 0
		nQdtEmb2    := 0
		nValEmpenho := 0
		lTemSoja    := .F.
		cD4Atu := "" 	
		aMicro := {}
		cTxtSoja    := ""
		cTxtBag     := ""
		cTotPeso    := ""
		cLimpM      := ""
	
		While !EOF() .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->C2_NUM == cOrdAtu .AND. (SC2->C2_ITEM <= cItemFim .AND. SC2->C2_ITEM >= cItemIni)
			
			If SC2->C2_SEQUEN == "001"
				cQtdEsp    := "Qtde Vendida: "+AllTrim(STR(SC2->C2_ZQTDESP))
				If SC2->C2_ZPALET == '1'
					cDescPale := "SIM"
				Else
					cDescPale := "NAO"
				EndIf
				cPalete     := "Paletizada:   "+ cDescPale 
			EndIf
		
			If SC2->C2_UM <> "KG" // So me interessa KG, a não ser que seja embalagem.
		         
				If SC2->C2_UM $ "SC_UN" 
		
					cProdEst := SC2->C2_PRODUTO 
		      		nQtdBat  := SC2->C2_QUANT
		      		nQtdInf  := SC2->C2_QTDINF
		  
		   		   	dbSelectArea("SD4")
				   	dbSetOrder(2) 
		           	dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+Space(2))

		         	cD4Atu := SD4->D4_OP
				
				   	cProduto := AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"))
		 
		           	FVeriEmb(cD4Atu) // Verifica se tem Micro / Macro.      		
		
				EndIf
		
				dbSelectArea("SC2")
		   		dbSkip()		   		
		   		//Loop
		   	EndIf
		
			nTotGer  := SC2->C2_QUANT
			//cProduto := AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"))
		                                                           
		 	dbSelectArea("SD4")
		  	dbSetOrder(2) 
		  	dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+Space(2))
		   
		  	cD4Atu := SD4->D4_OP
		   	lTemMicro := .F.
		   	lTemMacro := .F.
		   	lTemSoja  := .F.
			FVerifTp(cD4Atu) // Verifica se tem Micro / Macro.
		 	//FVeriEmb(cD4Atu) // Verifica se tem Micro / Macro.		 		
		    
			If lTemMicro

				aDados	:= {} 
			    nRep	:= 0
			    nTotMicro := 0
			    nTotMacro := 0
			    nTotPeso  := 0
			    nTotMin     := 0
				nTotMax     := 0
				//oSection1:Init()
				//oSection2:Init()
			
				//FOrdCMic(oSection1) 
				
				cOrdem		:= SC2->C2_NUM + "-" + SC2->C2_ITEM
				cCodProd	:= AllTrim(cProdEst)
				cEmbal		:= AllTrim(STR(nQdtEmb1)) + " Sacos de " + cEmbalag
			
		  //		If nQdtEmb2 > 0
		   //			cEmbal2		:= " "+ AllTrim(STR(nQdtEmb2)) + " Sacos de " + cEmbalag2
			//	EndIf
				nBatel		:= FCalcBat(nQtdBat,nQtdInf)
				nPeso       := Posicione("SB1",1,xFilial("SB1")+cProdEst,"B1_PESBRU")
	            If nPeso >= 1000
	            	cTxtBag := "Limp.SL.Bag (  )"
	            EndIf
				//oSection1:PrintLine()				
				//oSection1:Finish()
				
				//fTitBat(0)	
		  
		 		//FOrdMicro(oSection2)
		 		dbSelectArea("SD4")
				dbSetOrder(2) 
				dbSeek(xFilial("SD4") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + Space(2))
				While !Eof() .And. SD4->D4_OP == cD4Atu
					If Alltrim(SD4->D4_COD) == "MP00130005"
		    			cTxtSoja := "Limp.SL.Soja (  )"
		    		EndIf 
					nValEmpenho:= 0 
					nValEmpenho := 	SD4->D4_QTDEORI / FCalcBat(nQtdBat,nQtdInf)
					//If nValEmpenho > 30//Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TPELEM") <> '1'
					If Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TPELEM") == '2' .And. nValEmpenho > 30 //.Or. (Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TPELEM") == '2' .And. nValEmpenho > 30)
						dbSelectArea("SD4")
						dbSkip()
						Loop
					ElseIf Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TIPO")== "PA"
						dbSelectArea("SD4")
						dbSkip()
						Loop
					ElseIf (Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TPELEM") == '2' .And. nValEmpenho <= 30 ) .Or. Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TPELEM") == '1'	
						Aadd(aMicro,{SD4->D4_COD})
					EndIf	
					
					nValEmpenho := 0
					nValEmpenho := 	SD4->D4_QTDEORI / FCalcBat(nQtdBat,nQtdInf)
	
					nQtdMinima	:=	nValEmpenho * Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_QTDMIN")
					nQtdMaxima	:=	nValEmpenho * Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_QTDMAX")
				
				    cCodMP	:= AllTrim(SD4->D4_COD)+"/"+Alltrim(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_NICONE"))
				    cDescMP	:= AllTrim(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_NOMPROD"))
				    nValor	:= nValEmpenho
				    nTolMin	:= nQtdMinima
				    nTolMax	:= nQtdMaxima
				    nConsumo:= SD4->D4_QTDEORI
				    cLote   := SD4->D4_LOTECTL
				    
				    AAdd(aDados,{cCodMP,cDescMP,nValor,nTolMin,nTolMax,nConsumo,cLote})
			        
					//oSection2:PrintLine()
					nTotMicro := nTotMicro + nValEmpenho // Totalizador...
					nTotMin   := nTotMin + nTolMin
					nTotMax   := nTotMax + nTolMax
					dbSelectArea("SD4")
					dbSkip()
				
				EndDo
				
				//oSection2:Finish()
				
				//fImpMsg()
				
				//oReport:EndPage(.T.)
				
				While nRep < nBatel
					oSection1:Init()
					oSection1:PrintLine()
					oSection1:Finish()
					oSection2:Init()
					oSection2:PrintLine()
					oSection2:Finish()
					oSection3:Init()
					fTitBat(nRep)
					For nX := 1 To Len(aDados)
						cCodMP	:= aDados[nX][1]
					    cDescMP	:= aDados[nX][2]
					    nValor	:= aDados[nX][3]
					    nTolMin	:= aDados[nX][4]
					    nTolMax	:= aDados[nX][5]
					    nConsumo:= aDados[nX][6]
					    cLote   := aDados[nX][7]
					
						oSection3:PrintLine()					
					Next
					oSection3:Finish()
					fImpMsg()
					oReport:EndPage(.T.)
					nRep += 10
				End 				
		 		
		  	EndIf
		   
		  	If lTemMacro		  	

		  		aDados	:= {}
		  		nRep	:= 0
		  		//oSection1:Init()
				//oSection2:Init()
				
				//FOrdCMac(oSection1)
				
				cOrdem		:= SC2->C2_NUM + "-" + SC2->C2_ITEM
				cCodProd	:= AllTrim(cProdEst)
			   //	cEmbal		:= cEmbalag
				cEmbal		:= AllTrim(STR(nQdtEmb1)) + " Sacos de " + cEmbalag
				//If nQdtEmb2 > 0
				 //	cEmbal		+= " "+ AllTrim(STR(nQdtEmb2)) + " Sacos de " + cEmbalag2
				//EndIf
				nBatel		:= FCalcBat(nQtdBat,nQtdInf)
				
				//oSection1:PrintLine()
				//oSection1:Finish()
				
				//fTitBat(0) 	
				
				//FOrdMacro(oSection2)
				dbSelectArea("SD4")
				dbSetOrder(2) 
				dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+Space(2))				
				While !Eof() .And. SD4->D4_OP == cD4Atu
					cLimpM := "Limp.Misturador ( ) "
					If Alltrim(SD4->D4_COD) == "MP00130005"
		    			cTxtSoja := "Limp.SL.Soja (  )"
		    		EndIf
				    nValEmpenho := 0
					nValEmpenho := 	SD4->D4_QTDEORI/FCalcBat(nQtdBat,nQtdInf)  
				   //	If nValEmpenho <= 30//Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TPELEM") <> '2'
					If Posicione("SB1",1,xFilial("SB1") + SD4->D4_COD,"B1_TPELEM") == '2' .And. nValEmpenho <= 30 .And. !(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_TIPO") =="PA") //.Or. (nPos := aScan(aMicro,{|aX| aX[1] == SD4->D4_COD }) > 0 )
						dbSelectArea("SD4")
						dbSkip()
						Loop
					EndIf
					If nPos := aScan(aMicro,{|aX| aX[1] == SD4->D4_COD }) > 0
						dbSelectArea("SD4")
						dbSkip()
						Loop
					EndIf	 					
					nValEmpenho := 0
				   	nValEmpenho := 	SD4->D4_QTDEORI/FCalcBat(nQtdBat,nQtdInf)         

					nQtdMinima	:=	nValEmpenho*Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_QTDMIN")
					nQtdMaxima	:=	nValEmpenho*Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_QTDMAX")
					
					cCodMP	:= AllTrim(SD4->D4_COD)+"/"+Alltrim(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_NICONE"))
				    cDescMP	:= AllTrim(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_NOMPROD"))
				    nValor	:= nValEmpenho
				    nTolMin	:= nQtdMinima
				    nTolMax	:= nQtdMaxima
				    nConsumo:= SD4->D4_QTDEORI
				    cLote   := SD4->D4_LOTECTL
				    
				    AAdd(aDados,{cCodMP,cDescMP,nValor,nTolMin,nTolMax,nConsumo,cLote})
			        
					//oSection2:PrintLine()					
					nTotMacro := nTotMacro + nValEmpenho // Totalizador...
					nTotPeso  := (nTotMacro+nTotMicro)/nQtdInf
					dbSelectArea("SD4")
					dbSkip()				
				EndDo
				
				//oSection2:Finish()
				
				//fImpMsg()
				
				//oReport:EndPage(.T.)
//				MsgInfo(Alltrim(Str(nTotPeso)))   
				cTotPeso := "Val.Peso SC "+Alltrim(Str(Round(nTotPeso,4)))+"KG"
				While nRep < nBatel
					oSection1:Init()
					oSection1:PrintLine()
					oSection1:Finish()  
					oSection2:Init()
					oSection2:PrintLine()
					oSection2:Finish()
					oSection3:Init()
					fTitBat(nRep)
					For nX := 1 To Len(aDados)
						cCodMP	:= aDados[nX][1]
					    cDescMP	:= aDados[nX][2]
					    nValor	:= aDados[nX][3]
					    nTolMin	:= aDados[nX][4]
					    nTolMax	:= aDados[nX][5]
					    nConsumo:= aDados[nX][6]
						cLote   := aDados[nX][7]    
					
						oSection3:PrintLine()					
					Next
					oSection3:Finish()
					fImpMsg()
					oReport:EndPage(.T.)
					nRep += 10
				End 	
				
			EndIf
		    
			dbSelectArea("SC2")
			dbSkip() // Avanca o ponteiro do registro no arquivo		
		EndDo	
	EndDo	
	
Return
	
Static Function fImpMsg()

	Local cMSG01	:= ""
	Local cMSG02	:= ""
	
	cMSG01	:= "Responsável emissão: ___________________ Responsável do monitoramento da dosagem: ___________________ Data produção: ___/___/_____ "
 //	cMSG01	+= "Verificação dosagem:____________________________________    "
	
	cMSG02	:= "Lote anterior: _______________ Teve Ionóforo(  )Sim (  )Não  Responsável avaliação Ionóforos: __________________"
	
	oSection4:Init()	
	oSection4:lHeaderSection := .F.			
	oSection4:Cell("MSG01"):SetValue(cMSG01)
	oSection4:PrintLine()
	oSection4:Finish()
	
	If AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0044" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0323" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0307" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0308" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0309" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0310"
		oSection5:Init()	
		oSection5:lHeaderSection := .F.			
		oSection5:Cell("MSG02"):SetValue(cMSG02)
		oSection5:PrintLine()
		oSection5:Finish()
	EndIf    
	
	If Alltrim(cCodProd) $ ("PA04400007_PA04400008_PA04400010_PA00430022_PA00430021_PA00380094")//AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0044" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0323" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0307" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0308" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0309" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_GRUPO")) == "0310"
		oSection5:Init()	
		oSection5:lHeaderSection := .F.			
		oSection5:Cell("MSG02"):SetValue(cMSG02)
		oSection5:PrintLine()
		oSection5:Finish()
	EndIf

Return	

Static Function fTitBat(nCel)
    
    Local nTituCel := 0
    
	For nY := 1 To 10 
		nTituCel := nY + nCel
		oSection3:Cell(StrZero(nY,2)):SetTitle(StrZero(nTituCel,2))
	Next	

Return	
	
Static Function FVerifTp(cOrdProd)
/******************************************************************************************
* Verifica se tem itens Micro e/ou Macro
*
***/
	
	lTemMicro  := .F.
	lTemMacro  := .F.
	
	dbSelectArea("SD4")
//	MsgStop('3')	
	                                         
	While !Eof() .And. SD4->D4_OP == cOrdProd
//		MsgStop('2')	
		If Empty(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_TPELEM"))
			dbSelectArea("SD4")
			dbSkip()
			Loop
		EndIf
		
		If Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_TPELEM") == '1' // Micro
			lTemMicro  := .T.
		EndIf
		
		If Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_TPELEM") == '2' // Macro
			lTemMacro  := .T.
		EndIf 
		
		dbSelectArea("SD4")
		dbSkip()
	
	EndDo
	
	Return
	
	
Static Function FVeriEmb(cOrdProd)
/******************************************************************************************
* Verifica se tem itens Micro e/ou Macro
*
***/                    
Local aArea := GetArea()
	
	dbSelectArea("SD4")

//	MsgStop('5')	
	While !Eof() .And. SD4->D4_OP == cOrdProd
//	MsgStop('6')	
	
		If AllTrim(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_GRUPO")) <> "0015" // Embalagem
		   dbSelectArea("SD4")
		   dbSkip() 
		   Loop
		EndIf
//	MsgStop('7')	
		
		If Empty(cEmbalag)
			cEmbalag := AllTrim(SB1->B1_DESC)
			nQdtEmb1    := SD4->D4_QTDEORI
		EndIf
	
//		If !Empty(cEmbalag)
  //			cEmbalag2 := AllTrim(SB1->B1_DESC)
//			nQdtEmb2    := SD4->D4_QUANT
  //		EndIf
		
		dbSelectArea("SD4")
		dbSkip()
	
	EndDo               
	
	RestArea(aArea)	
Return
	
Static Function FPerInd(cCodPro)
/******************************************************************************************
* Busca o Indice
*
***/
	
	Local nPerInd := 0
	Local cPrxPro := Soma1(cCodPro, Len(cCodPro))
	
	/*
	Busco o ultimo indice, pois é o que importa
	*/
	dbSelectArea("SZ6")
	dbSetOrder(1)
	Set SoftSeek On
	dbSeek(xFilial("SZ6") + cPrxPro)
	Set SoftSeek Off
	dbSkip(-1)
	
	If (SZ6->Z6_CodPro <> cCodPro)
		nPerInd := 1
	Else
		nPerInd := SZ6->Z6_IndPro
	EndIf
	
Return (nPerInd)	
	
Static Function FCalcBat(nQuant,nBatInf)
	
	Local nBatidas := 0
	
	If nBatInf > 0
		If nQuant < nBatInf 
			nBatidas := 1
		Else
			nBatidas := nQuant / nBatInf 
		Endif
	Else
		If nQuant < 40
			nBatidas := 1
		Else
			nBatidas := nQuant / 40
		Endif 
	EndIf


Return(nBatidas)


Static Function AjustaSX1()
*******************************************************************************
****
*******************************************************************************

	PutSx1("APCPR05","01","Ordem de		?","Ordem de	?","Ordem de	?","mv_ch1","C",06,00,01,"G","","SC2"	,"","","mv_par01","","","","","","","","","","","","","","","","",{}, {}, {} )
	PutSx1("APCPR05","02","Ordem até 	?","Ordem até 	?","Ordem até 	?","mv_ch2","C",06,00,01,"G","","SC2"	,"","","mv_par02","","","","","","","","","","","","","","","","",{}, {}, {} )
	PutSx1("APCPR05","03","Item de		?","Item de		?","Item de		?","mv_ch3","C",02,00,01,"G","","" 		,"","","mv_par03","","","","","","","","","","","","","","","","",{}, {}, {} )
	PutSx1("APCPR05","04","Item até		?","Item até	?","Item até	?","mv_ch4","C",02,00,01,"G","","" 		,"","","mv_par04","","","","","","","","","","","","","","","","",{}, {}, {} )

Return