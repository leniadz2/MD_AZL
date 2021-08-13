SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [ods].[CAMPANA_CANT_REGISTROS]
  AS
SELECT ca.GUID
      ,ca.SECUENCIAL
      ,ca.CAMPANA
      ,cl.CONTA_CL
      ,co.CONTA_CO
 FROM ini.CAMPAIGN ca
      INNER JOIN (SELECT cl.GUID_CMPN, COUNT(*) AS CONTA_CL
                    FROM stg.CLIENTE cl
                   GROUP BY cl.GUID_CMPN) AS cl
        ON ca.GUID = cl.GUID_CMPN
      INNER JOIN (SELECT co.GUID_CMPN, COUNT(*) AS CONTA_CO
                    FROM stg.COMPROBANTES co
                   GROUP BY co.GUID_CMPN) AS co
        ON ca.GUID = co.GUID_CMPN
GO