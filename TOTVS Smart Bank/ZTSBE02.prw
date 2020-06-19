//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Cadastro de Contratos

Static cTitulo := "Contratos"
user function ZTSBE02()
    Local aArea   := GetArea() 
	Local oBrowse
	SetFunName("ZTSBE02")
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela ZB1 Contratos
	oBrowse:SetAlias("ZB1") 

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	 //Legendas
	oBrowse:AddLegend("ZB1->ZB1_STATUS  =  '1'", "YELLOW",	"Em Analise" )
	oBrowse:AddLegend("ZB1->ZB1_STATUS  =  '2'", "GREEN",	"Aprovado" )
    oBrowse:AddLegend("ZB1->ZB1_STATUS  =  '3'", "RED",	    "Reprovado" )

	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return 

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |                                                 
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ZTSBE02' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ZTSBE02' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ZTSBE02' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ZTSBE02' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'U_zLegend'       OPERATION 6                      ACCESS 0 //OPERATION 6
Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |                                                  
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	//Cria��o da estrutura de dados utilizada na interface
	Local oStZB1 := FWFormStruct(1, "ZB1")
    //Definindo uma Funcao para commit dos dados e calculo das parcelas
    Local bCommit := { |oModel| ZTSBEGRV( oModel ) }
    //Declara��s dos Gatilhos usados no form dessa rotina
    Local aGatFunc := {}
    Local aGatOfer := {}

    aGatFunc := FwStruTrigger('ZB1_MAT', 'ZB1_NOME','SRA->RA_NOME',	.T. ,'SRA',	1 ,'xFilial("SRA")+M->ZB1_MAT') 
    aGatOfer := FwStruTrigger('ZB1_OFERTA', 'ZB1_DESCOF','ZB3->ZB3_DESC', .T.,'ZB3', 1,'xFilial("ZB3")+M->ZB1_OFERTA')
	
	//Editando caracter�sticas do dicion�rio
	oStZB1:SetProperty('ZB1_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
	oStZB1:SetProperty('ZB1_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZB1", "ZB1_COD")'))         //Ini Padr�o
	//oStZB1:SetProperty('ZB1_PRAZO', MODEL_FIELD_OBRIGAT, FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.') )  
    oStZB1:AddTrigger(aGatFunc[1],aGatFunc[2],aGatFunc[3],aGatFunc[4])      
    oStZB1:AddTrigger(aGatOfer[1],aGatOfer[2],aGatOfer[3],aGatOfer[4])                                    
	
	//Instanciando o modelo, NAO COLOCAR O MESMO NOME DA USER FUNCTION, aqui coloquei um M de Model para diferenciar
	oModel := MPFormModel():New("ZTSBE02M",/*bPre*/, /*bPos*/,bCommit,/*bCancel*/) 
	
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZB1",/*cOwner*/,oStZB1)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZB1_FILIAL','ZB1_COD'})
	
	//Adicionando descri��o ao modelo / uso o mesmo titulo, mas pode mudar se quiser 
	oModel:SetDescription(cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZB1"):SetDescription("Formul�rio do  "+cTitulo)
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	
	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Atendentes
	Local oModel := FWLoadModel("ZTSBE02")
	
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZB1 := FWFormStruct(2, "ZB1")  
	
	//Criando oView como nulo
	Local oView := Nil

	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_ZB1", oStZB1, "FORMZB1")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZB1', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_ZB1","TELA")
	
Return oView

Static Function ZTSBEGRV(oModel)

    Local oModelPad  := FWModelActive()
	Local cCodigo    := oModelPad:GetValue('FORMZB1', 'ZB1_COD')
	Local nPrazo     := oModelPad:GetValue('FORMZB1', 'ZB1_PRAZO')
    Local nValor     := oModelPad:GetValue('FORMZB1', 'ZB1_VALOR')
	Local nOpc       := oModelPad:GetOperation()
	Local lRet       := .T.
    Local i := 0 //Variavel do For

    //Necessario o commit do form ZB1 devido as ontras opera��es de Delete e Alter.
    FWFormCommit( oModel ) 

    IF nOpc == MODEL_OPERATION_INSERT
        for i := 1 to nPrazo
            dbSelectArea('ZB2')
			dbSetOrder(1)
			Reclock('ZB2',.T.)
            ZB2->ZB2_FILIAL := xFilial('ZB2')
            ZB2->ZB2_COD    := cCodigo
            ZB2->ZB2_NUMPAR := cValToChar(i) 
            ZB2->ZB2_VALOR  := nValor/nPrazo
            ZB2->ZB2_VENCIM := (DATE() + (i * 30))
            ZB2->ZB2_STATUS := '1'
            MsUnlock()
			DbCloseArea() 
        next i
        
    ENDIF
    
return lRet

//Funcao que cria a Leganda dos contratos
User Function zLegend()
	Local aLegenda := {}
	
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Aprovado"  })
	AADD(aLegenda,{"BR_AMARELO",	"Em Analise"})
	AADD(aLegenda,{"BR_VERMELHO",	"Reprovado"  })
	
	BrwLegenda(cTitulo, "Status", aLegenda)
Return 