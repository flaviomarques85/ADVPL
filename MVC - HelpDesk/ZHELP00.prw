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

    //Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
    //Setando a tabela de cadastro de Setores
	oBrowse:SetAlias("ZZ9")
    //Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
    //Ativa a Browse
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
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ZHelp00' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |                                                  
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Criação do objeto do modelo de dados
	Local oModel := Nil
	//Criação da estrutura de dados utilizada na interface
	Local oStZZ9 := FWFormStruct(1, "ZZ9")
	
	//Editando características do dicionário
	oStZZ9:SetProperty('ZZ9_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
	oStZZ9:SetProperty('ZZ9_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ9", "ZZ9_COD")'))         //Ini Padrão
	oStZZ9:SetProperty('ZZ9_DESC',  MODEL_FIELD_OBRIGAT, .T. )                                       
	
	//Instanciando o modelo, NAO COLOCAR O MESMO NOME DA USER FUNCTION, aqui coloquei um M para diferenciar
	oModel := MPFormModel():New("ZHelp00M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	//Atribuindo formulários para o modelo
	oModel:AddFields("FORMZZ9",/*cOwner*/,oStZZ9)
	//Setando a chave primária da rotina
	oModel:SetPrimaryKey({'ZZ9_FILIAL','ZZ9_COD'})
	//Adicionando descrição ao modelo / uso o mesmo titulo, mas pode mudar se quiser 
	oModel:SetDescription(cTitulo)
	//Setando a descrição do formulário
	oModel:GetModel("FORMZZ9"):SetDescription("Formulário do  "+cTitulo)
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

	//Criação do objeto do modelo de dados da Interface do Cadastro de Atendentes
	Local oModel := FWLoadModel("ZHelp00")
	//Criação da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZZ9 := FWFormStruct(2, "ZZ9")  
	//Criando oView como nulo
	Local oView := Nil

	//Criando a view que será o retorno da função e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	//Atribuindo formulários para interface
	oView:AddField("VIEW_ZZ9", oStZZ9, "FORMZZ9")
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZZ9', 'Dados - '+cTitulo )  
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView("VIEW_ZZ9","TELA")
	
Return oView
