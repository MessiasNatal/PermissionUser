object DMUserGroup: TDMUserGroup
  OldCreateOrder = False
  Height = 74
  Width = 417
  object qyGroup: TFDQuery
    CachedUpdates = True
    AggregatesActive = True
    Left = 32
    Top = 16
  end
  object qyComponents: TFDQuery
    CachedUpdates = True
    AggregatesActive = True
    Left = 99
    Top = 16
  end
  object qyListGroup: TFDQuery
    CachedUpdates = True
    AggregatesActive = True
    Left = 178
    Top = 16
    object qyListGroupid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'id'
    end
    object qyListGroupnome: TStringField
      FieldName = 'nome'
      Size = 1000
    end
  end
  object qyGroupComponentsUserLogged: TFDQuery
    CachedUpdates = True
    AggregatesActive = True
    Left = 301
    Top = 16
  end
end
