-- CRIANDO A TABELA DE PRODUTOS COM AS INFORMAÇÕES DAS DIMENSÕES DE CATEGORIA E SUBCATEGORIA

select * from dbo.DimProduct

create view dbo.V_DimProduct AS
select  
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
from DimProduct
inner join DimProductSubcategory 
	on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
inner join DimProductCategory 
	on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
