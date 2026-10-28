-- CRIANDO A TABELA DE LOJAS COM AS INFORMAÇÕES DA DIMENSÃO DE GEOGRAFIA
CREATE VIEW dbo.V_DimStore AS
SELECT 
	StoreKey,
	DimStore.GeographyKey,
	StoreManager,
	StoreType,
	StoreName,
	StoreDescription,
	Status,
	EntityKey,
	ZipCode,
	ZipCodeExtension,
	StorePhone,
	StoreFax,
	AddressLine1,
	AddressLine2,
	EmployeeCount,
	SellingAreaSize,
	LastRemodelDate,
	GeoLocation,
	DimGeography.Geometry,
	DimGeography.ContinentName,
	DimGeography.CityName,
	DimGeography.RegionCountryName
FROM 
	dbo.DimStore
INNER JOIN dbo.DimGeography 
	ON DimStore.GeographyKey = DimGeography.GeographyKey
