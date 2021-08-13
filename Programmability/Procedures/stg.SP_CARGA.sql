SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [stg].[SP_CARGA]
AS
  /***************************************************************************************************
  Procedure:          stg.SP_CARGA
  Create Date:        20210812
  Author:             dÁlvarez
  Description:        tbd
  Call by:            tbd
  Affected table(s):  tbd
  Used By:            BI
  Parameter(s):       none
  Log:                none
  Prerequisites:      tbd
  ****************************************************************************************************
  SUMMARY OF CHANGES
  Date(YYYYMMDD)      Author              Comments
  ------------------- ------------------- ------------------------------------------------------------
  20210812            dÁlvarez            creacion
  
  ***************************************************************************************************/

INSERT INTO stg.CLIENTE
SELECT *
  FROM MD_AZL.dbo.clcom;

--'Campaña de Introducción'
INSERT INTO stg.COMPROBANTES
SELECT Correlativo
      ,[Número de Serie]
      ,RUC
      ,Locatario
      ,Mall
      ,Cliente
      ,Estado
      ,Registro
      ,Monto
      ,(SELECT c.GUID FROM ini.CAMPAIGN c WHERE c.campana = 'Campaña de Introducción') AS GUID
FROM MD_AZL.dbo.comprobantes_campaña_introduccion2;

--'Dia del Padre'
INSERT INTO stg.COMPROBANTES
SELECT Correlativo
      ,[Número de Serie]
      ,RUC
      ,Locatario
      ,Mall
      ,Cliente
      ,Estado
      ,Registro
      ,Monto
      ,(SELECT c.GUID FROM ini.CAMPAIGN c WHERE c.campana = 'Dia del Padre') AS GUID
FROM MD_AZL.dbo.comprobantespadre;

--'Dia del Madre'
INSERT INTO stg.COMPROBANTES
SELECT Correlativo
      ,[Número de Serie]
      ,RUC
      ,Locatario
      ,Mall
      ,Cliente
      ,Estado
      ,Registro
      ,Monto
      ,(SELECT c.GUID FROM ini.CAMPAIGN c WHERE c.campana = 'Dia del Madre') AS GUID
FROM MD_AZL.dbo.comprobantes_campaña_dia_madre2;

INSERT INTO ini.CAMPAIGN(FECINI_CLNT, FECFIN_CLNT, CAMPANA)
SELECT MIN(CONCAT(SUBSTRING(fecha,7,4),SUBSTRING(fecha,1,2),SUBSTRING(fecha,4,2))) AS FECINI_CLNT
      ,MAX(CONCAT(SUBSTRING(fecha,7,4),SUBSTRING(fecha,1,2),SUBSTRING(fecha,4,2))) AS FECFIN_CLNT
      ,CAMPANA
  FROM stg.CLIENTE
 GROUP BY CAMPANA
 ORDER BY 1;


GO