#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'

//Preciso da user function apenas para reserver a funcao no RPO
//não será escrito nenhum codigo detro da user function
User Function WSCLIENT()
Return

//Estrutura do WS 
WSRESTFUL CLIENTES DESCRIPTION "WS de Consulta de clientes"
    //Recebe uma string que no caso dou o nome de CGCCLI = notação p CNPJ ou CPF do cliente
    WSDATA CGCCLI As String
    //definindo quais metodos existem nesse WS, e a descrição do metodo. 
    //no caso aqui temos apenso um metodo GET 
    WSMETHOD GET DESCRIPTION "Retorna dados do cliente informado na URL" WSSYNTAX "/CLIENTE || /CLIENTE/{}"
    WSMETHOD PUT DESCRIPTION "Atualiza dados do cliente informado na URL" WSSYNTAX "/CLIENTE/{id}"

END WSRESTFUL

//Construção do Metedo GET CGCCLI do WS Clientes
WSMETHOD GET WSRECEIVE CGCCLI WSSERVICE CLIENTES
    Local cCodCli:= Self:CGCCLI
    Local aArea    := GetArea()
    Local oObjCli := Nil
    Local cStatus  := ""
    Local cJson    := ""

    ::SetContentType("application/json")

    DbSelectArea("SA1")
    DbSetOrder(3) // Indice posicionado pelo A1_CGC
    If DbSeek( xFilial("SA1") + cCodCli ) 
        cStatus := Iif( SA1->A1_MSBLQL == "1", "Bloqueado", "Ativo" )
        oObjCli := Cliente():New(cStatus,SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME,SA1->A1_END,SA1->A1_EST, SA1->A1_CEP,SA1->A1_MUN, cCodCli)
    EndIf

    cJson := FWJsonSerialize(oObjCli)

    ::SetResponse(cJson)

    RestArea(aArea)
Return(.T.) //Final do metodo GET => CLIENTES

// http://localhost:8089/rest/CLIENTES?CGCCLI=08932607000111

WSMETHOD PUT WSRECEIVE CGCCLI WSSERVICE CLIENTES
    local cBody := ""
    Local cCodCli := Self:CGCCLI

    // recupera o body da requisição
	cBody := ::GetContent()
    varinfo("",cBody)

	// Atualizando entedeço do cliente
    DbSelectArea("SA1")
    DbSetOrder(3) // Indice posicionado pelo A1_CGC
    If DbSeek( xFilial("SA1") + cCodCli ) 
        RecLock("SA1", .F.)		
        SA1->A1_END := "RUA CATAS ALTAS, 96"		 
    EndIf
    MsUnLock() //Confirma e finaliza a operação
    DbCloseArea()
	// exemplo de retorno de um objeto JSON
	::SetResponse('{"id":' + cCodCli + ', "Conteudo":"RUA CATAS ALTAS, 96"}')

RETURN (.T.)