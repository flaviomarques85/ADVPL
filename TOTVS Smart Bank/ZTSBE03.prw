#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Gestão de Contrato Grid da tabela ZB1 e ZB2

Static cTitulo := "Gestão de Contratos Totvs S.B.E"
User Function ZTSBE03()
    Local aArea   := GetArea() 
	Local oBrowse
	SetFunName("ZTSBE03")
	
	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	oBrowse:SetLocate( ) 
	//Setando a tabela ZB1 Contratos
	oBrowse:SetAlias("ZB1") 
	oBrowse:SetDescription(cTitulo)
	 //Legendas
	oBrowse:AddLegend("ZB1->ZB1_STATUS  =  '1'", "YELLOW",	"Em Analise" )
	oBrowse:AddLegend("ZB1->ZB1_STATUS  =  '2'", "GREEN",	"Aprovado" )
    oBrowse:AddLegend("ZB1->ZB1_STATUS  =  '3'", "RED",	    "Reprovado" )
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return 

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Gerenciar Contr.' ACTION 'VIEWDEF.ZTSBE03' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Aprovação'  ACTION 'U_zApprove'       OPERATION  6                       ACCESS 0 //OPERATION 7
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_zLegend'       OPERATION  7                     ACCESS 0 //OPERATION 6
Return aRot

Static Function ModelDef()
	//Criação do objeto do modelo de dados
	Local oModel   := Nil
	//Criação da estrutura de dados utilizada nas interfaces
	Local oStZB1   := FWFormStruct(1, "ZB1")
	Local oStZB2   := FWFormStruct(1, "ZB2")
    //Declaraçõs dos Gatilhos usados no form dessa rotina
	Local aGatFunc := {}
	Local aGatOfer := {}
    //Array de Relacionamento entra ZB1 e ZB2
	Local aZB2Rel  := {}

    aGatFunc := FwStruTrigger('ZB1_MAT', 'ZB1_NOME','SRA->RA_NOME',	.T. ,'SRA',	1 ,'xFilial("SRA")+M->ZB1_MAT') 
    aGatOfer := FwStruTrigger('ZB1_OFERTA', 'ZB1_DESCOF','ZB3->ZB3_DESC', .T.,'ZB3', 1,'xFilial("ZB3")+M->ZB1_OFERTA')
	
	//Editando características do dicionário
	oStZB1:SetProperty('ZB1_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
	oStZB1:SetProperty('ZB1_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZB1", "ZB1_COD")'))         //Ini Padrão
	//oStZB1:SetProperty('ZB1_PRAZO', MODEL_FIELD_OBRIGAT, FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.') )  
    oStZB1:AddTrigger(aGatFunc[1],aGatFunc[2],aGatFunc[3],aGatFunc[4])      
    oStZB1:AddTrigger(aGatOfer[1],aGatOfer[2],aGatOfer[3],aGatOfer[4])                                    
	
	//Instanciando o modelo, NAO COLOCAR O MESMO NOME DA USER FUNCTION, aqui coloquei um M de Model para diferenciar
	oModel := MPFormModel():New("ZTSBE03M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
    oModel:AddFields('ZB1MASTER',/*Owner*/,oStZB1)
    oModel:AddGrid('ZB2DETAIL','ZB1MASTER',oStZB2)
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZB2Rel, {'ZB2_FILIAL','ZB1_FILIAL'})
	aAdd(aZB2Rel, {'ZB2_COD',	'ZB1_COD'})
    oModel:SetRelation('ZB2DETAIL',aZB2Rel,ZB2->(indexKey(1)))
	//Setando a chave primária da rotina
	oModel:SetPrimaryKey({})
	//Adicionando descrição ao modelo / uso o mesmo titulo, mas pode mudar se quiser 
	oModel:SetDescription(cTitulo)
	
Return oModel

Static Function ViewDef()
	Local oView		    := Nil
	Local oModel		:= FWLoadModel('ZTSBE03')
	Local oStPai		:= FWFormStruct(2, 'ZB1')
	Local oStFilho	    := FWFormStruct(2, 'ZB2')

	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:addUserButton("Aprovação",    "MAGIC_BMP",{|oView|U_zApprove(oView)},"" )
	oView:addUserButton("Baixar Parc.", "MAGIC_BMP",{|oView|U_zPayment(oView)},"" )
	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_ZB1',oStPai, 'ZB1MASTER')
	oView:AddGrid('VIEW_ZB2',oStFilho,'ZB2DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',50)
	oView:CreateHorizontalBox('GRID',50)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZB1','CABEC')
	oView:SetOwnerView('VIEW_ZB2','GRID')
	
	//Habilitando título
	//oView:EnableTitleView('VIEW_ZB1','titulo Pai')
	//oView:EnableTitleView('VIEW_ZB2','titulo filho')
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
	//Remove os campos 
	oStFilho:RemoveField('ZB2_FILIAL')
	oStFilho:RemoveField('ZB2_COD')
Return oView

/*/{Protheus.doc} zApprove
description
@type function
@version 
@author Flavio Marques
@since 22/08/2020
@param oView
/*/
user Function zApprove(oView)
	Local aRet   := {}
	Local aPergs := {}
	Local aOpc	 := {"1=Aprovação","2-Reprovar"}
	
	aAdd(aPergs,{2, "Aprov/Reprov:",  space(10),aOpc, 090, ".T.", .F.})
	aAdd(aPergs,{1, "Contrato:",      ZB1->ZB1_COD,"@E 999999999", ".T.", "",    ".T.", 09, .T.})
	
	If Parambox(aPergs, "Aprovação de Contratos", @aRet)
		dbSelectArea('ZB1')
		dbSetOrder(1)
		dbGoTop()
		If (dbSeek(xFilial('ZB1')+aRet[2])) //Verifica se existe o registro na base
			Reclock('ZB1',.F.)
			If Val(aRet[1])==1
				ZB1->ZB1_STATUS := "2"
			  Else
			  	ZB1->ZB1_STATUS := "3"
			EndIf
			MsUnlock()
			MsgInfo("Contrato de "+ZB1->ZB1_NOME+" numero "+ZB1->ZB1_COD+" foi atualizado com sucesso","Aprovação")
		  Else
		    MsgInfo("Cotrato não encontrato, verifique as informações!","Atenção")
		EndIf
		DbCloseArea()
	  Else
	  	Msginfo("Ação cancelada pelo usuario!","Aprovação")
	EndIf
Return

/*/{Protheus.doc} zPayment
	Funcao responsavel por validar a baixa manual de uma parcela
	do contrato
@type function
@version 
@author Flavio Marques
@since 23/08/2020
@param oView - objeto do tipo viewForm
/*/
user Function zPayment(oView)
	Local cParcela := FWFldGet("ZB2_NUMPAR")
	Local cCodContr:= FWFldGet("ZB2_COD")

	If MsgYesNo("Deseja realmente baixar a parcela de Num:  "+cParcela+"  desse contrato?", "Baixa Parcela")
		dbSelectArea('ZB2')
		dbSetOrder(2)
		IF dbSeek(xFilial("ZB2")+cCodContr+cParcela)
			IF ZB2->ZB2_STATUS == '2'
				Alert("Parcela já baixada, operação não pode ser concluida!")
			 Else
				Reclock('ZB2',.F.)
				ZB2->ZB2_STATUS := '2'
				MsUnlock()
				MsgInfo("Parcela Baixada com sucesso!","Baixa Parcela")
				oView:DeActivate()
				oView:Activate()
			EndIF
		EndIF
		DbCloseArea()	
	EndIF
return
