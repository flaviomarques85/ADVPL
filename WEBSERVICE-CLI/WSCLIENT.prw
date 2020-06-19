
#include 'Protheus.ch'
#include 'parmtype.ch'
#include 'RESTFUL.ch'

user function WSCLI001()
    private oRest := FwRest():New("http://localhost:8089/") //Servidor da API   
    private aHeader := {}

    oRest:setpath("rest/CLIENTES?CGCCLI=08932607000111") //Paramentros da URL

    If oRest:Get(aHeader)
        ConOut("Get",oRest:GetResult())
    else
        ConOut("Get",oRest:GetLastError())
    EndIf     

    private response := oRest:GetResult()
    private error := oRest:GetLastError()
    alert(response)
    alert(error)

    ConOut("Fim")
Return
