#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'

User Function WSPROD()
Return

WSRESTFUL PRODUTOS DESCRIPTION "WS REST para Produtos"

WSDATA CODPRODUTO As String

WSMETHOD GET DESCRIPTION "Retorna dados do produto informado na URL" WSSYNTAX "/PRODUTOS || /PRODUTOS/{}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE CODPRODUTO WSSERVICE PRODUTOS
Local cCodProd := Self:CODPRODUTO
Local aArea    := GetArea()
Local oObjProd := Nil
Local cStatus  := ""
Local cJson    := ""

::SetContentType("application/json")

DbSelectArea("SB1")
DbSetOrder(1) 
If DbSeek( xFilial("SB1") + cCodProd ) 
    cStatus  := Iif( SB1->B1_MSBLQL == "1", "Sim", "Nao" )
    oObjProd := Produtos():New(SB1->B1_DESC, SB1->B1_UM, cStatus)
EndIf

cJson := FWJsonSerialize(oObjProd)

::SetResponse(cJson)

RestArea(aArea)
Return(.T.)

//http://localhost:8089/rest/PRODUTOS?CODPRODUTO=MC00160060