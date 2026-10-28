-- CRIANDO A TABELA DE PRODUTOS COM AS INFORMAÇÕES DAS DIMENSÕES DE CATEGORIA E SUBCATEGORIA
CREATE VIEW dbo.V_DimProduct AS
SELECT 
	ProductKey,
	ProductLabel,
	ProductName,
	ProductDescription,
	DimProduct.ProductSubcategoryKey,
	Manufacturer,
	BrandName,
	ClassID,
	ClassName,
	StyleID,
	StyleName,
	ColorID,
	ColorName,
	Size,
	SizeRange,
	SizeUnitMeasureID,
	Weight,
	UnitCost,
	UnitPrice,
	ImageURL,
	ProductURL,
	ProductSubcategoryName,
	ProductCategoryName
FROM DimProduct
INNER JOIN DimProductSubcategory 
	ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
INNER JOIN DimProductCategory 
	ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
