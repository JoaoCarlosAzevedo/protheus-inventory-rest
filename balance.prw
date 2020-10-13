#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

WSRESTFUL balances DESCRIPTION "ENDPOINT for balances by product"

    WSMETHOD GET   DESCRIPTION "List of balances by products"  WSSYNTAX "/balances/ || /balances/{id} "

END WSRESTFUL
 

WSMETHOD GET WSSERVICE balances
    Local aArea     := GetArea() 
    Local cProduct  := IIF(Len(::aURLParms) > 0,ALLTRIM(::aURLParms[1]),"")
    Local oJson     := JsonObject():new()
    Local lFound    := .F.
    ::SetContentType("application/json")

    IF !EMPTY(cProduct)    
        dbSelectArea("SB1")
        dbSetOrder(1)
        IF dbSeek( xFilial("SB1") + cProduct)
            lFound := .T.
            oJson["productCode"     ] := alltrim(SB1->B1_COD)
            oJson["description"     ] := alltrim(SB1->B1_DESC)
            oJson["type"            ] := alltrim(SB1->B1_TIPO)
            oJson["standardWarehous"] := alltrim(SB1->B1_LOCPAD)
            oJson["unitMeasure"     ] := alltrim(SB1->B1_UM)
            oJson["warehouses"      ] := U_ProductWarehose(cProduct)
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
            oJson["warehouses"      ] := U_ProductWarehose(SB1->B1_COD)
            ::SetResponse(oJson:toJSON())
  
            IF !SB1->(EoF())    
                ::SetResponse(",")
            ENDIF 
            DbSkip()
        ENDDO
        ::SetResponse("]")   
    ENDIF

Return(lFound) 

//U_ProductWarehose("000000000000003")
User Function ProductWarehose(cProduct)
    Local aRet := {}
    Local i    := 0
    Local aAreaAnt := GETAREA()
 
    dbSelectArea("SB2")
    dbSetOrder(1)
    IF dbSeek( xFilial("SB2") + cProduct)
        WHILE !EOF() .AND. SB2->B2_COD == cProduct
            Aadd(aRet, JsonObject():new() ) 
            i := i + 1
            aRet[i]["warehouse"        ] := alltrim(SB2->B2_LOCAL)
            aRet[i]["warehouseBalance" ] := SB2->B2_QATU
            aRet[i]["lots"             ] := U_ProductLots(cProduct,SB2->B2_LOCAL)
            dbSkip() 
        ENDDO 
    ENDIF  
    RestArea(aAreaAnt)  
     
Return aRet 

User Function ProductLots(cProduct,cWarehouse)
    Local aRet := {} 
    Local i    := 0
    Local aAreaAnt := GETAREA()
 
    dbSelectArea("SB8")
    dbSetOrder(1)
    IF dbSeek( xFilial("SB8") + cProduct + cWarehouse)
        WHILE !EOF() .AND. SB8->B8_PRODUTO == cProduct .AND. SB8->B8_LOCAL == cWarehouse
            Aadd(aRet, JsonObject():new() )
            i := i + 1
            aRet[i]["lotnumber" ] := alltrim(SB8->B8_LOTECTL)
            aRet[i]["lotBalance"] := SB8->B8_SALDO
            dbSkip()
        ENDDO
    ENDIF 
    RestArea(aAreaAnt) 
 
Return aRet 
