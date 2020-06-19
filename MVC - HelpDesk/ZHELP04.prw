
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

static cTitulo := "Gestão de tickets"


User Function ZHelp04()
    Local aArea := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

	// Força o sistema a trabalhar com a função atual.
    SetFunName("ZHelp04") 

	oBrowse := FWMBrowse():New()
    //Setando a tabela
	oBrowse:SetAlias("ZZ8")
	oBrowse:SetDescription(cTitulo)

     //Legendas
	oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '1'", "GREEN",	"Aberto" )
	oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '2'", "YELLOW",	"Em Atendimento" )
    oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '3'", "BLUE",	"Aguard Usuario" )
	oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '4'", "BLACK",	"Encerrado" )
    oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '5'", "RED",	"Atrasado" )

	oBrowse:Activate()

    SetFunName(cFunBkp)
	RestArea(aArea)
    
Return 

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |                                                 
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
    Local aRot := {}

    //Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_ZChaLeg'       OPERATION 6                      ACCESS 0 //OPERATION 5
    
Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |                                                  
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
    
	Local oModel := Nil
	Local oStZZ8 := FWFormStruct(1, "ZZ8")
    Local aGatSetor:= {} 
    Local aGatPrior:= {}
    Local aGatAtend:= {}
    //FwStruTrigger transforma o gatilho tradicional do Configurador em gatilho MVC
	aGatSetor := FwStruTrigger('ZZ8_SETOR', 'ZZ8_SETDES','ZZ9->ZZ9_DESC',	.T. ,'ZZ9',	1 ,'xFilial("ZZ9")+M->ZZ8_SETOR') 
	aGatPrior := FwStruTrigger('ZZ8_CODPRI','ZZ8_DESPRI','ZZ6->ZZ6_DESC',	.T. ,'ZZ6',	1 ,'xFilial("ZZ6")+M->ZZ8_CODPRI') 
    aGatAtend := FwStruTrigger('ZZ8_TECNIC','ZZ8_TECDES','ZZ5->ZZ5_DESC',	.T. ,'ZZ5',	1 ,'xFilial("ZZ5")+M->ZZ8_TECNIC') 
    
    oStZZ8:AddTrigger(aGatSetor[1],aGatSetor[2],aGatSetor[3],aGatSetor[4])  
    oStZZ8:AddTrigger(aGatPrior[1],aGatPrior[2],aGatPrior[3],aGatPrior[4])   
    oStZZ8:AddTrigger(aGatAtend[1],aGatAtend[2],aGatAtend[3],aGatAtend[4]) 
	
	//Editando características do dicionário
	oStZZ8:SetProperty('ZZ8_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                              
	oStZZ8:SetProperty('ZZ8_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ8", "ZZ8_COD")'))       
                                 

	oModel := MPFormModel():New("ZHelp04M",,,,) 
	//Atribuindo formulários para o modelo
	oModel:AddFields("FORMZZ8",,oStZZ8)
	oModel:SetPrimaryKey({'ZZ8_FILIAL','ZZ8_COD'})
	oModel:SetDescription(cTitulo)
	oModel:GetModel("FORMZZ8"):SetDescription("Formulário do  "+cTitulo)
Return  oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Criação da visão MVC                                         |
 *--------------------------------------------------------------------*/
Static Function ViewDef()
   
	Local oModel := FWLoadModel("ZHelp04")
	Local oStZZ8 := FWFormStruct(2, "ZZ8")  
	Local oView := Nil

	oView := FWFormView():New()
	oView:SetModel(oModel)
	//Atribuindo formulários para interface
	oView:AddField("VIEW_ZZ8", oStZZ8, "FORMZZ8")
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	oView:EnableTitleView('VIEW_ZZ8', 'Dados - '+cTitulo )  
	oView:SetCloseOnOk({||.T.})
	oView:SetOwnerView("VIEW_ZZ8","TELA")
    
Return oView

User Function ZChaLeg()
	Local aLegenda := {}
	
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Aberto"  })
	AADD(aLegenda,{"BR_AMARELO",	"Em Atendimento"})
	AADD(aLegenda,{"BR_AZUL",		"Aguardando usuario"  })
	AADD(aLegenda,{"BR_PRETO",	    "Encerrado"})
	AADD(aLegenda,{"BR_VERMELHO",	"Atrasado"  })
	
	BrwLegenda(cTitulo, "Status", aLegenda)
Return 