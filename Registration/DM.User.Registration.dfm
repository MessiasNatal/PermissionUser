object DMUserRegistration: TDMUserRegistration
  OldCreateOrder = False
  Height = 69
  Width = 185
  object qyUserRegistration: TFDQuery
    CachedUpdates = True
    AggregatesActive = True
    Left = 40
    Top = 12
    object qyUserRegistrationid: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'id'
      ReadOnly = True
    end
    object qyUserRegistrationnome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Required = True
      Size = 50
    end
    object qyUserRegistrationemail: TStringField
      DisplayLabel = 'E-Mail'
      FieldName = 'email'
      Required = True
      Size = 50
    end
    object qyUserRegistrationlogin: TStringField
      DisplayLabel = 'Login'
      FieldName = 'login'
      Required = True
      Size = 50
    end
    object qyUserRegistrationsenha: TStringField
      DisplayLabel = 'Senha'
      FieldName = 'senha'
      Size = 50
    end
    object qyUserRegistrationativo: TStringField
      FieldName = 'ativo'
      Size = 50
    end
    object qyUserRegistrationadministrador: TStringField
      FieldName = 'administrador'
      Size = 50
    end
    object qyUserRegistrationusuario_sistema: TStringField
      FieldName = 'usuario_sistema'
      Size = 50
    end
    object qyUserRegistrationid_grupo: TIntegerField
      DisplayLabel = 'Grupo de Permiss'#227'o'
      FieldName = 'id_grupo'
      Required = True
    end
  end
  object qyListGroup: TFDQuery
    CachedUpdates = True
    AggregatesActive = True
    Left = 128
    Top = 12
    object qyListGroupid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'id'
    end
    object qyListGroupnome: TStringField
      FieldName = 'nome'
      Size = 1000
    end
  end
end
