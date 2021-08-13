SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[SP_CARGA]
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

--CLIENTE---------------
DROP TABLE ods.CLIENTE_CAMPANA_00;
DROP TABLE ods.CLIENTE_CAMPANA_01;
DROP TABLE ods.CLIENTE_CAMPANA_02;
DROP TABLE ods.CLIENTE_CAMPANA_03;
DROP TABLE ods.CLIENTE_CAMPANA;

SELECT FECHA
      ,CAMPANA
      ,MALL
      ,NOMBRE_CLIENTE
      ,APELLIDO_CLIENTE
      ,TIPO_DOCUMENTO_CLIENTE
      ,CASE
         WHEN  TIPO_DOCUMENTO_CLIENTE = 'Carné de Extranjería' THEN ods.fn_ajustaCE(TRIM(NUMERO_DOCUMENTO_CLIENTE))
         WHEN  TIPO_DOCUMENTO_CLIENTE = 'DNI' THEN ods.fn_ajustaDNI(TRIM(NUMERO_DOCUMENTO_CLIENTE))
         ELSE CONCAT('X|',NUMERO_DOCUMENTO_CLIENTE)
       END AS DUI_VALIDEZ$DUI
      ,TELEFONO
      ,DEPARTAMENTO
      ,PROVINCIA
      ,DISTRITO
      ,DIRECCION
      ,NUMERO_DE_CALLE
      ,MANZANA
      ,LOTE
      ,NRO_INTERNO
      ,URB_COND
      ,REFERENCIA
      ,ESTADO
      ,GUID_CMPN
  INTO ods.CLIENTE_CAMPANA_00
  FROM stg.CLIENTE;


SELECT TIPO_DOCUMENTO_CLIENTE AS TIPO_DUI
      ,CASE LEFT(DUI_VALIDEZ$DUI,1)
         WHEN 'X' THEN NULL
         WHEN '0' THEN 'NO VALIDO'
         WHEN '1' THEN 'VALIDO'
       END AS DUI_VALIDEZ
      ,RIGHT(DUI_VALIDEZ$DUI,LEN(DUI_VALIDEZ$DUI)-2) AS DUI
      ,(SELECT c.SECUENCIAL FROM ini.CAMPAIGN c WHERE c.GUID = GUID_CMPN) AS SEC_CMPN
      ,COUNT(*) AS CUENTA
 INTO ods.CLIENTE_CAMPANA_01
 FROM ods.CLIENTE_CAMPANA_00
GROUP BY TIPO_DOCUMENTO_CLIENTE
        ,DUI_VALIDEZ$DUI
        ,GUID_CMPN
ORDER BY 1 ASC;

SELECT TIPO_DUI
      ,DUI_VALIDEZ
      ,DUI
      ,MAX(CUENTA) AS MAX_CUENTA
  INTO ods.CLIENTE_CAMPANA_02
  FROM ods.CLIENTE_CAMPANA_01
 GROUP BY TIPO_DUI
         ,DUI_VALIDEZ
         ,DUI;

SELECT cc.TIPO_DUI
      ,cc.DUI_VALIDEZ
      ,cc.DUI
      ,MAX(cc.SEC_CMPN) AS MAX_SEC_CMPN
      ,cc1.MAX_CUENTA
  INTO ods.CLIENTE_CAMPANA_03
  FROM ods.CLIENTE_CAMPANA_01 cc
       INNER JOIN ods.CLIENTE_CAMPANA_02 cc1
         ON cc.DUI = cc1.DUI 
           AND cc.TIPO_DUI = cc1.TIPO_DUI 
           AND cc.CUENTA = cc1.MAX_CUENTA
 GROUP BY cc.TIPO_DUI
         ,cc.DUI_VALIDEZ
         ,cc.DUI
         ,cc1.MAX_CUENTA;



--SELECT t.NUMERO_DOCUMENTO_CLIENTE, t.CAMPANA, COUNT(*) FROM (
--SELECT DISTINCT NUMERO_DOCUMENTO_CLIENTE, CONCAT(NOMBRE_CLIENTE,' ',APELLIDO_CLIENTE) AS ass,CAMPANA
--  FROM stg.CLIENTE) AS t
--  GROUP BY t.NUMERO_DOCUMENTO_CLIENTE, t.CAMPANA
--  ORDER BY 3 DESC
--
--
--SELECT dui, COUNT(*) 
--  FROM ods.CLIENTE_CAMPANA_03
--  GROUP BY dui
--  having COUNT(*) > 1


SELECT c.TIPO_DOCUMENTO_CLIENTE
      ,cc.DUI_VALIDEZ
      ,cc.DUI
      ,c.NOMBRE_CLIENTE
      ,c.APELLIDO_CLIENTE
      ,CONCAT(c.NOMBRE_CLIENTE,' ',c.APELLIDO_CLIENTE) AS CLIENTE
      ,c.TELEFONO
      ,c.DEPARTAMENTO
      ,c.PROVINCIA
      ,c.DISTRITO
      ,c.DIRECCION
      ,c.NUMERO_DE_CALLE
      ,c.MANZANA
      ,c.LOTE
      ,c.NRO_INTERNO
      ,c.URB_COND
      ,c.REFERENCIA
      ,MIN(CONCAT(SUBSTRING(c.FECHA,7,4),SUBSTRING(c.FECHA,1,2),SUBSTRING(c.FECHA,4,2))) AS FEC_1ER_CMPN_PARTICIPACION
      ,MAX(CONCAT(SUBSTRING(c.FECHA,7,4),SUBSTRING(c.FECHA,1,2),SUBSTRING(c.FECHA,4,2))) AS FEC_ULT_CMPN_PARTICIPACION
      ,COUNT(DISTINCT c.CAMPANA) AS CAMPANAS_PARTICIPADAS_CNTD
      ,c1.CAMPANA AS CAMPANA_MAYOR_PARTICIPACION
      ,cc.MAX_CUENTA AS CAMPANA_MAYOR_PARTICIPACION_CNTD
      ,SUM(IIF(c.MALL='Plaza Norte',1,0)) AS PARTICIPACIONES_CCPN_CNTD
      ,SUM(IIF(c.MALL='Mall del Sur',1,0)) AS PARTICIPACIONES_MDS_CNTD
      ,SUM(IIF(c.MALL='GTT',1,0)) AS PARTICIPACIONES_GTT_CNTD
      ,SUM(IIF(c.ESTADO='Perdió',1,0)) AS STATUS_PERDIO_CNTD
      ,SUM(IIF(c.ESTADO='Pendiente',1,0)) AS STATUS_PENDIENTE_CNTD
      ,SUM(IIF(c.ESTADO='Ganador',1,0)) AS STATUS_GANADOR_CNTD
INTO ods.CLIENTE_CAMPANA
FROM stg.CLIENTE c
     INNER JOIN ods.CLIENTE_CAMPANA_03 cc
       ON c.NUMERO_DOCUMENTO_CLIENTE = cc.DUI AND c.TIPO_DOCUMENTO_CLIENTE = cc.TIPO_DUI
     INNER JOIN ini.CAMPAIGN c1
       ON c1.SECUENCIAL = cc.MAX_SEC_CMPN
GROUP BY c.TIPO_DOCUMENTO_CLIENTE
        ,cc.DUI_VALIDEZ
        ,cc.DUI
        ,c.NOMBRE_CLIENTE
        ,c.APELLIDO_CLIENTE
        ,c.TELEFONO
        ,c.DEPARTAMENTO
        ,c.PROVINCIA
        ,c.DISTRITO
        ,c.DIRECCION
        ,c.NUMERO_DE_CALLE
        ,c.MANZANA
        ,c.LOTE
        ,c.NRO_INTERNO
        ,c.URB_COND
        ,c.REFERENCIA
        ,c1.CAMPANA
        ,cc.MAX_CUENTA;


--SELECT * FROM MD_AZL.bds.CLIENTE_CAMPANA
--  WHERE TIPO_DOCUMENTO_CLIENTE = 'Carné de Extranjería'
--  AND PARTICIPACIONES_MDS_CNTD > 1
--  AND LEN(TELEFONO) = 9
--  ORDER BY PARTICIPACIONES_MDS_CNTD DESC

--SELECT * FROM MD_AZL.bds.CLIENTE_CAMPANA
--  WHERE STATUS_GANADOR_CNTD > 1
--
--  SELECT NUMERO_DOCUMENTO_CLIENTE, COUNT(*)
--    FROM MD_AZL.bds.CLIENTE_CAMPANA
--    GROUP BY NUMERO_DOCUMENTO_CLIENTE
--    ORDER BY 2 DESC


-------------COMPROBANTES

--  SELECT DISTINCT mall FROM stg.COMPROBANTES;
--
--SELECT * FROM stg.COMPROBANTES;
--,CHARINDEX(MALL,'Plaza Norte')
--,CHARINDEX(MALL,'Mall del Sur')
--  ,CASE
--     WHEN CHARINDEX(MALL,'Plaza Norte') > 0 THEN 'CCPN'
--     WHEN CHARINDEX(MALL,'Mall del Sur') > 0 THEN 'MdS'
--     WHEN CHARINDEX(MALL,'GTT') > 0 THEN 'MdS'
--  END AS UNDECO
--  ,CASE
--     WHEN CHARINDEX(MALL,'Plaza Norte') > 0 THEN SUBSTRING(MALL,12,LEN(MALL)-11)
--     WHEN CHARINDEX(MALL,'Mall del Sur') > 0 THEN SUBSTRING(MALL,13,LEN(MALL)-12)
--     WHEN CHARINDEX(MALL,'GTT') > 0 THEN SUBSTRING(MALL,4,LEN(MALL)-3)
--  END AS UBICACION_EVENTO

GO