DECLARE @SourceMarket INT;
DECLARE @DestMarket   INT;
/*
CURRENT MARKET ALIGNMENT
=========================================
MarketID	BMID	Description
1		    1		LEGACY
2			2		BASE TIER
3			2		TIER 2
4			2		BUDDY'S PENNSYLVANIA
5			2		BUDDY'S CALIFORNIA
7			2		BUDDYS GUAM
8			3		PAUHANA WAREHOUSE
9			4		BHF_DEP_INF-SL
11			5		BUDDYS WHSE
15			7		TNM_INF-SL-INF
17			6		KGL_PSL_RCL_SL-INF
18			8		BNC_SL_MCR
19			9		BRC_BRG_MMS_SL_INF
20			10		GUY_SL_AIF
=========================================
*/

SET @SourceMarket=2; -- SET the source market
SET @DestMarket=4;   -- SET the destination market

--DROP the temp table if it already exists
IF OBJECT_ID('VersiRentDB.dbo.SourceMarket') IS NOT NULL
	DROP TABLE VersiRentDB.dbo.SourceMarket;

--SELECT all source market records into a table
SELECT *
INTO SourceMarket
FROM ModelMarket
WHERE MarketID=@SourceMarket

--DELETE entries from source market that already exist in destination market
DELETE FROM SourceMarket
WHERE ModID IN (SELECT ModID 
                FROM ModelMarket 
				WHERE MarketID=@DestMarket);

--SET new MMID's to prevent duplications
--SET new destination market 
UPDATE SourceMarket
SET MMID=NEWID(), MarketID=@DestMarket;

--INSERT the new MM records from SourceMarket
INSERT INTO ModelMarket
SELECT *
FROM SourceMarket

--CLEAN UP after ourselves
DROP TABLE VersiRentDB.dbo.SourceMarket;

SELECT 
	(SELECT COUNT(MMID)
	 FROM ModelMarket
	 WHERE MarketID=@SourceMarket) AS SourceMarket,
	(SELECT COUNT(MMID)
	 FROM ModelMarket
	 WHERE MarketID=@DestMarket) AS DestMarket

