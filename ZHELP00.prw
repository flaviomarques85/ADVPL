//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//MVC do cadastro de tipos de chamados
Static cTitulo := "Cadastro de Setores"

user Function ZHelp00()
    Local aArea := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

    SetFunName("ZHelp00")

    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
    //Setando a tabela de cadastro de Setores
	oBrowse:SetAlias("ZZ9")
    //Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
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
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |                                                  
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	//Cria��o da estrutura de dados utilizada na interface
	Local oStZZ9 := FWFormStruct(1, "ZZ9")
	
	//Editando caracter�sticas do dicion�rio
	oStZZ9:SetProperty('ZZ9_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
	oStZZ9:SetProperty('ZZ9_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ9", "ZZ9_COD")'))         //Ini Padr�o
	oStZZ9:SetProperty('ZZ9_DESC',  MODEL_FIELD_OBRIGAT, .T. )                                       
	
	//Instanciando o modelo, NAO COLOCAR O MESMO NOME DA USER FUNCTION, aqui coloquei um M para diferenciar
	oModel := MPFormModel():New("ZHelp00M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZZ9",/*cOwner*/,oStZZ9)
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZZ9_FILIAL','ZZ9_COD'})
	//Adicionando descri��o ao modelo / uso o mesmo titulo, mas pode mudar se quiser 
	oModel:SetDescription(cTitulo)
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZZ9"):SetDescription("Formul�rio do  "+cTitulo)
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Atendentes
	Local oModel := FWLoadModel("ZHelp00")
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZZ9 := FWFormStruct(2, "ZZ9")  
	//Criando oView como nulo
	Local oView := Nil

	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_ZZ9", oStZZ9, "FORMZZ9")
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZZ9', 'Dados - '+cTitulo )  
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_ZZ9","TELA")
	
Return oView
