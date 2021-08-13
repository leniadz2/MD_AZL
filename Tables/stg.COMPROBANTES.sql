CREATE TABLE [stg].[COMPROBANTES] (
  [CORRELATIVO] [varchar](50) NULL,
  [NUMERO_DE_SERIE] [varchar](50) NULL,
  [RUC] [varchar](50) NULL,
  [LOCATARIO] [varchar](150) NULL,
  [MALL] [varchar](50) NULL,
  [CLIENTE] [varchar](100) NULL,
  [ESTADO] [varchar](50) NULL,
  [REGISTRO] [varchar](50) NULL,
  [MONTO] [varchar](50) NULL,
  [GUID_CMPN] [uniqueidentifier] NULL
)
ON [PRIMARY]
GO