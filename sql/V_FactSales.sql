-- CRIANDO A TABELA DE FATOS DE VENDAS COM AS INFORMAÇÕES DAS VENDAS.

SELECT * FROM FactSales

CREATE VIEW dbo.V_FactSales AS
SELECT 
	SalesKey,
	DateKey,
	channelKey,
	StoreKey,
	ProductKey,
	PromotionKey,
	CurrencyKey,
	UnitCost,
	UnitPrice,
	SalesQuantity,
	ReturnQuantity,
	ReturnAmount,
	DiscountQuantity,
	DiscountAmount,
	TotalCost,
	SalesAmount
FROM 
	FactSales
