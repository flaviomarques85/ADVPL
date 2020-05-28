#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function ZHELP05()
Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZ5')
	oBrowse:SetDescription('Relação Tecnico x Ticket')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.ZHELP05' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.ZHELP05' OPERATION 8 ACCESS 0


Return aRotina

Static Function ModelDef() 
Local oModel 
Local oStruZZ5 := FWFormStruct(1,"ZZ5") 
Local oStruZZ8 := FWFormStruct(1,"ZZ8") 

	
	 
	oModel := MPFormModel():New("ZHELP05M")  
	oModel:addFields('ZZ5MASTER', ,oStruZZ5)  
	oModel:addGrid('ZZ8DETAIL','ZZ5MASTER',oStruZZ8)  
	
	oModel:SetRelation("ZZ8DETAIL", ;       
	 					{{"ZZ8_FILIAL","ZZ5_FILIAL"},;        
						{"ZZ8_TECNIC","ZZ5_COD"  }}, ;       
						ZZ8->(IndexKey(2)))  
    oModel:SetPrimaryKey({})       
 	oModel:SetDescription("Chamado por Atendente.")
						
Return oModel 

Static Function ViewDef() 
    Local oModel := ModelDef() 
    Local oView 
    Local oStrZZ5:= FWFormStruct(2, 'ZZ5')   
    Local oStrZZ8:= FWFormStruct(2, 'ZZ8')   
    
	oView := FWFormView():New()  
	oView:SetModel(oModel)    
	oView:AddField('FORM_TECNICOS' , oStrZZ5,'ZZ5MASTER')  
	oView:AddGrid( 'FORM_CHAMADOS' , oStrZZ8,'ZZ8DETAIL')  
	
	oView:CreateHorizontalBox( 'BOX_FORM_TECNICOS', 30)  
	oView:CreateHorizontalBox( 'BOX_FORM_CHAMADOS', 70)  
 	
 	oView:SetOwnerView('FORM_TECNICOS','BOX_FORM_TECNICOS')  
 	oView:SetOwnerView('FORM_CHAMADOS','BOX_FORM_CHAMADOS')   
    
    //Remover os campo não importates do grid.
    oStrZZ8:RemoveField('ZZ8_TECNIC')
    oStrZZ8:RemoveField('ZZ8_TECDES')
    oStrZZ8:RemoveField('ZZ8_SETOR') //Codigo do Setor
    oStrZZ8:RemoveField('ZZ8_CODPRI')
    
 	 
Return oView