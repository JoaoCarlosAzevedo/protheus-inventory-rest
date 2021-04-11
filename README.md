# Fontes exemplos de uma API REST para controle de estoque do protheus

### Fonte: products.prw - Dados da tabela SB1

```http
GET http://localhost:port/rest/products/{productCode}
```
### Retorno

```javascript
{
  "type": "MP",
  "standardWarehous": "01",
  "productCode": "000000000000002",
  "unitMeasure": "UN",
  "description": "DESCRICAO PRODUTO"
}
```

```http
GET http://localhost:port/rest/products/
```
### Retorno
```javascript
[
    {
    "type": "MP",
    "standardWarehous": "01",
    "productCode": "000000000000002",
    "unitMeasure": "UN",
    "description": "DESCRICAO PRODUTO"
    },
    {
        "type": "MP",
        "standardWarehous": "01",
        "productCode": "000000000000002",
        "unitMeasure": "UN",
        "description": "DESCRICAO PRODUTO 2"
    },
]
```

### balance.prw - Dados da tabela SB1, SB2, SB8

```http
GET http://localhost:port/rest/balances/{productCode}
GET http://localhost:port/rest/balances/
```
### Retorno
```javascript
{
    "type": "MP",
    "standardWarehous": "01",
    "productCode": "000000000000003",
    "unitMeasure": "UN",
    "description": "PRODUTO DE TESTE DE NUMERO 03",
    "warehouses": [
    {
      "warehouse": "01"
      "warehouseBalance": 10012,
      "lots": [
        {
          "lotnumber": "COD LOTE 1",
          "lotBalance": 5000
        },
        {
          "lotnumber": "TESTE",
          "lotBalance": 0
        },
        {
          "lotnumber": "LTOE 02",
          "lotBalance": 5000
        }
      ], 
    },
    {
      "warehouse": "02"
      "warehouseBalance": 990,
      "lots": [
        {
          "lotnumber": "PPPPDSASS",
          "lotBalance": 500
        },
        {
          "lotnumber": "XXYYWEQW",
          "lotBalance": 490
        }
      ],
    }
  ],
}
```
### Fonte: transactions.prw - MsExecAuto - mata240
```http
POST http://localhost:port/rest/transactions/{productCode}
```
### Body
```javascript
{
    "tm": String,
    "product": String,
    "docid": String,
    "amount": Number,
    "lotnumber": String,
    "warehouse": String
}
```  