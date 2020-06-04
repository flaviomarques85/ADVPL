#include 'protheus.ch'

User Function ZGAME01()
Local oDlg, oGet1, oButton ,oSay1, oPlayer
Local cNome := space(40) //<-Importante para permitir digitação no campo. 
 
 oDlg := MSDialog():New(0,0,300,500,'GAME01',,,,,CLR_BLACK,CLR_WHITE,,,.T.) // cria diálogo
    // Monta um GET para entrada de dados em variável string
    @ 10,10 SAY oSay1 PROMPT "Nome Jogador" SIZE 40,10 OF oDlg  PIXEL
    @ 8,50 GET oGet1 VAR cNome PICTURE "@!" SIZE 80,10 OF oDlg  PIXEL
    
    oPlayer := Player():New(cNome) //Criando o objeto Player

    oButton:=tButton():New(50,40,'Jogar',oDlg,{||oPlayer:Resultado(cNome)},80,20,,,,.T.)

 oDlg:Activate(,,,.T.,,,,)
Return  

Class Player
    Data Nome 
    Data Pontos

    Method New() CONSTRUCTOR
    Method Resultado()  
    Method CalcPontos()
    Method PrintPontos()
EndClass


Method New(cNome) Class Player
  ::Nome := cNome
  ::Pontos := 10
Return Self 

Method Resultado(cNome) Class Player
    Local cPlayer := AllTrim(cNome)
    Local nValor := Randomize( 1, 101 )
    Local cResult := ", voce Perdeu."
    IF (nValor >= 52)
        cResult := ", voce Venceu!"
    ENDIF
    Alert(cPlayer + cResult)
Return 

Method CalcPontos() Class  Player
    
Return

Method PrintPontos(nPontos) Class Player
    Alert("Seus Pontos são: "+nPontos)
Return
