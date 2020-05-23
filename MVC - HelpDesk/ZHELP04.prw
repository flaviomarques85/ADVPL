//MVC da tela de chamados
//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

static cTitulo := "Registros de Chamados"


User Function ZHelp04()
    Local aArea := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

    SetFunName("ZHelp04") //<- For�a o sistema a trabalhar com a fun��o atual.

    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
    //Setando a tabela de Chamados
	oBrowse:SetAlias("ZZ8")
    //Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)

     //Legendas
	oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '1'", "GREEN",	"Aberto" )
	oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '2'", "RED",	"Em Atendimento" )
    oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '3'", "BLUE",	"Aguard Usuario" )
	oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '4'", "BLACK",	"Encerrado" )
    oBrowse:AddLegend("ZZ8->ZZ8_STATUS =  '5'", "RED",	"Atrasado" )

    //Ativa a Browse
	oBrowse:Activate()

    SetFunName(cFunBkp)
	RestArea(aArea)
    
Return 

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |                                                 
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
    Local aRot := {}

    //Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ZHelp04' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    
Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |                                                  
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
    //Cria��o do objeto do modelo de dados
	Local oModel := Nil
	//Cria��o da estrutura de dados utilizada na interface
	Local oStZZ8 := FWFormStruct(1, "ZZ8")
    //Gatilhos manuais (N�o � obrigatorio no modeldef, vai da sua necessidade)
    Local aGatSetor:= {} 
    Local aGatPrior:= {}
    Local aGatAtend:= {}
    //FwStruTrigger transforma o gatilho tradicinal do Configurador em gatilho MVC
	aGatSetor := FwStruTrigger('ZZ8_SETOR', 'ZZ8_SETDES','ZZ9->ZZ9_DESC',	.T. ,'ZZ9',	1 ,'xFilial("ZZ9")+M->ZZ8_SETOR') 
	aGatPrior := FwStruTrigger('ZZ8_CODPRI','ZZ8_DESPRI','ZZ6->ZZ6_DESC',	.T. ,'ZZ6',	1 ,'xFilial("ZZ6")+M->ZZ8_CODPRI') 
    aGatAtend := FwStruTrigger('ZZ8_TECNIC','ZZ8_TECDES','ZZ5->ZZ5_DESC',	.T. ,'ZZ5',	1 ,'xFilial("ZZ5")+M->ZZ8_TECNIC') 
    //[01]campo de origem [02]campo de destino [03]valida��o da execu��o do gatilho [04]execu��o do gatilho
    oStZZ8:AddTrigger(aGatSetor[1],aGatSetor[2],aGatSetor[3],aGatSetor[4])  
    oStZZ8:AddTrigger(aGatPrior[1],aGatPrior[2],aGatPrior[3],aGatPrior[4])   
    oStZZ8:AddTrigger(aGatAtend[1],aGatAtend[2],aGatAtend[3],aGatAtend[4]) 
	
	//Editando caracter�sticas do dicion�rio
	oStZZ8:SetProperty('ZZ8_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
	oStZZ8:SetProperty('ZZ8_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ8", "ZZ8_COD")'))         //Ini Padr�o
                                 
	//Instanciando o modelo, NAO COLOCAR O MESMO NOME DA USER FUNCTION, aqui coloquei um M para diferenciar
	oModel := MPFormModel():New("ZHelp04M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZZ8",/*cOwner*/,oStZZ8)
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZZ8_FILIAL','ZZ8_COD'})
	//Adicionando descri��o ao modelo / uso o mesmo titulo, mas pode mudar se quiser 
	oModel:SetDescription(cTitulo)
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZZ8"):SetDescription("Formul�rio do  "+cTitulo)
Return  oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()
   
	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Atendentes
	Local oModel := FWLoadModel("ZHelp04")
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZZ8 := FWFormStruct(2, "ZZ8")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
	 //Criando oView como nulo
	Local oView := Nil

	//Criando a view que ser� o retorno da fun��o  setando o modelo da rotina
	oView := FWFormView():New()
    //setando o modelo da rotina
	oView:SetModel(oModel)
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_ZZ8", oStZZ8, "FORMZZ8")
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZZ8', 'Dados - '+cTitulo )  
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_ZZ8","TELA")
    
Return oView