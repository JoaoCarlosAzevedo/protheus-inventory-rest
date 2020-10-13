#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

WSRESTFUL products DESCRIPTION "ENDPOINT  for products"
    WSMETHOD GET DESCRIPTION "List of all products"  WSSYNTAX "/products/ || /products/{id}"
END WSRESTFUL

WSMETHOD GET WSSERVICE products
    
    Local aArea     := GetArea() 
    Local cProduct  := IIF(Len(::aURLParms) > 0,ALLTRIM(::aURLParms[1]),"")
    Local oJson     := JsonObject():new()
    Local lFound    := .F.

    ::SetContentType("application/json") 
  
    IF !EMPTY(cProduct) 
        
        dbSelectArea("SB1") 
        dbSetOrder(1)
        IF dbSeek( xFilial("SB1") + cProduct)
            lFound    := .T.
            oJson["productCode"     ] := alltrim(SB1->B1_COD)
            oJson["description"     ] := alltrim(SB1->B1_DESC)
            oJson["type"            ] := alltrim(SB1->B1_TIPO)
            oJson["standardWarehous"] := alltrim(SB1->B1_LOCPAD)
            oJson["unitMeasure"     ] := alltrim(SB1->B1_UM)
            ::SetResponse(oJson:toJSON())
        ENDIF 
        
    ELSE
        ::SetResponse("[")  
        dbSelectArea("SB1")
        SB1->(DbGoTop()) 
        While !SB1->(EoF())    
            lFound    := .T.
            oJson["productCode"     ] := alltrim(SB1->B1_COD)
            oJson["description"     ] := alltrim(SB1->B1_DESC)
            oJson["type"            ] := alltrim(SB1->B1_TIPO)
            oJson["standardWarehous"] := alltrim(SB1->B1_LOCPAD)
            oJson["unitMeasure"     ] := alltrim(SB1->B1_UM)
            
            SB1->(DbSkip())  
 
            ::SetResponse(oJson:toJSON())
 
            IF !SB1->(EoF())   
                ::SetResponse(",")
            ENDIF 
            
        ENDDO     
        ::SetResponse("]")      
    ENDIF 
            
    RestArea(aArea)
 
Return(lFound)
