#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'

User Function WSCLIENT()
Return

WSRESTFUL CLIENTES DESCRIPTION "WS de Consulta de clientes"

WSDATA CGCCLI As String

WSMETHOD GET DESCRIPTION "Retorna dados do cliente informado na URL" WSSYNTAX "/CLIENTE || /CLIENTE/{}"

END WSRESTFUL

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
Return(.T.)

// http://localhost:8089/rest/CLIENTES?CGCCLI=08932607000111