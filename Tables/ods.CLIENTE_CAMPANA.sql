﻿CREATE TABLE [ods].[CLIENTE_CAMPANA] (
  [TIPO_DOCUMENTO_CLIENTE] [varchar](50) NULL,
  [DUI_VALIDEZ] [varchar](9) NULL,
  [DUI] [nvarchar](52) NULL,
  [NOMBRE_CLIENTE] [varchar](50) NULL,
  [APELLIDO_CLIENTE] [varchar](50) NULL,
  [CLIENTE] [varchar](101) NOT NULL,
  [TELEFONO] [varchar](50) NULL,
  [DEPARTAMENTO] [varchar](50) NULL,
  [PROVINCIA] [varchar](50) NULL,
  [DISTRITO] [varchar](50) NULL,
  [DIRECCION] [varchar](100) NULL,
  [NUMERO_DE_CALLE] [varchar](50) NULL,
  [MANZANA] [varchar](50) NULL,
  [LOTE] [varchar](50) NULL,
  [NRO_INTERNO] [varchar](50) NULL,
  [URB_COND] [varchar](100) NULL,
  [REFERENCIA] [varchar](100) NULL,
  [FEC_1ER_CMPN_PARTICIPACION] [varchar](8) NULL,
  [FEC_ULT_CMPN_PARTICIPACION] [varchar](8) NULL,
  [CAMPANAS_PARTICIPADAS_CNTD] [int] NULL,
  [CAMPANA_MAYOR_PARTICIPACION] [varchar](100) NULL,
  [CAMPANA_MAYOR_PARTICIPACION_CNTD] [int] NULL,
  [PARTICIPACIONES_CCPN_CNTD] [int] NULL,
  [PARTICIPACIONES_MDS_CNTD] [int] NULL,
  [PARTICIPACIONES_GTT_CNTD] [int] NULL,
  [STATUS_PERDIO_CNTD] [int] NULL,
  [STATUS_PENDIENTE_CNTD] [int] NULL,
  [STATUS_GANADOR_CNTD] [int] NULL
)
ON [PRIMARY]
GO