#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
  
WSRESTFUL transactions DESCRIPTION "ENDPOINT for transactions"
    WSMETHOD POST DESCRIPTION "Post method to create products transactions"  WSSYNTAX "/transactions/{id}"
END WSRESTFUL  

WSMETHOD POST WSSERVICE transactions
    Local lPost      := .T.
    Local cJSON      := Self:GetContent() // Pega a string do JSON
    Local oParseJSON := Nil
    Local cRet       := "" 
    Local aArea      := GetArea() 

    FWJsonDeserialize(cJSON, @oParseJSON)
    
    If Len(::aURLParms) == 0
        SetRestFault(400, "Invalid product code")
        lPost := .F.
    Else

        cRet := U_CreateSD3(oParseJSON)

        IF EMPTY(cRet)
            ::SetResponse('{"message": "success" }')
        ELSE 
            SetRestFault(400, cRet)
            lPost := .F.
        ENDIF
    EndIf    
    RestArea(aArea)         
      
Return(lPost)     
     

User Function CreateSD3(oJson)  
    Local cRet := "" 
    Local aRotAuto := {}   
    Local aLogAuto := {}@
    Local cLogTxt := ""
    Local nAux

    Private lAutoErrNoFile := .T.
 
    private lMsErroAuto    := .F. 
 
    aRotAuto := {   {"D3_FILIAL"	,xFilial("SD3")	  ,Nil},; 
                    {"D3_TM"		,oJson:tm	      ,Nil},; 
                    {"D3_COD"		,oJson:product	  ,Nil},; 
                    {"D3_DOC"		,oJson:docid	  ,Nil},; 
                    {"D3_QUANT"	    ,oJson:amount	  ,Nil},; 
                    {"D3_LOTECTL"   ,oJson:lotnumber  ,Nil},; 
                    {"D3_LOCAL"	    ,oJson:warehouse  ,Nil}}   

    MSExecAuto({|x,y| mata240(x,y)},aRotAuto,3)

    IF lMsErroAuto 
        aLogAuto := GetAutoGRLog() 
        For nAux := 1 To 2
            cLogTxt += aLogAuto[nAux]
            cRet :=  EncodeUTF8(cLogTxt, "cp1252")  
        Next       
    ELSE   
        conout("success")   
    Endif   
   
Return cRet
