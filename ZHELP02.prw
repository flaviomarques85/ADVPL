//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//MVC do cadastro de tipos de chamados
Static cTitulo := "Cadastro de SLAs"

user Function ZHelp02()
    Local aArea := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

    SetFunName("ZHelp02")

    //Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
    //Setando a tabela de cadastro de Atendentes
	oBrowse:SetAlias("ZZ6")
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
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ZHelp02' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ZHelp02' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ZHelp02' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ZHelp02' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |                                                  
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Criação do objeto do modelo de dados
	Local oModel := Nil
	//Criação da estrutura de dados utilizada na interface
	Local oStZZ6 := FWFormStruct(1, "ZZ6")
	
	//Editando características do dicionário
	oStZZ6:SetProperty('ZZ6_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
	oStZZ6:SetProperty('ZZ6_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ6", "ZZ6_COD")'))         //Ini Padrão
	                                     
	
	//Instanciando o modelo, NAO COLOCAR O MESMO NOME DA USER FUNCTION, aqui coloquei um M para diferenciar
	oModel := MPFormModel():New("ZHelp02M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	//Atribuindo formulários para o modelo
	oModel:AddFields("FORMZZ6",/*cOwner*/,oStZZ6)
	//Setando a chave primária da rotina
	oModel:SetPrimaryKey({'ZZ6_FILIAL','ZZ6_COD'})
	//Adicionando descrição ao modelo / uso o mesmo titulo, mas pode mudar se quiser 
	oModel:SetDescription(cTitulo)
	//Setando a descrição do formulário
	oModel:GetModel("FORMZZ6"):SetDescription("Formulário do  "+cTitulo)
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

	//Criação do objeto do modelo de dados da Interface do Cadastro de Atendentes
	Local oModel := FWLoadModel("ZHelp02")
	//Criação da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZZ6 := FWFormStruct(2, "ZZ6")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
	//Criando oView como nulo
	Local oView := Nil

	//Criando a view que será o retorno da função e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	//Atribuindo formulários para interface
	oView:AddField("VIEW_ZZ6", oStZZ6, "FORMZZ6")
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZZ6', 'Dados - '+cTitulo )  
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView("VIEW_ZZ6","TELA")
	
Return oView
