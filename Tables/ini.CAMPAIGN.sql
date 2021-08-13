CREATE TABLE [ini].[CAMPAIGN] (
  [GUID] [uniqueidentifier] NULL DEFAULT (newid()),
  [SECUENCIAL] [int] IDENTITY,
  [FECINI_CLNT] [varchar](8) NULL,
  [FECFIN_CLNT] [varchar](8) NULL,
  [CAMPANA] [varchar](100) NULL,
  [FECINI_CMPN] [varchar](8) NULL,
  [FECFIN_CMPN] [varchar](8) NULL
)
ON [PRIMARY]
GO