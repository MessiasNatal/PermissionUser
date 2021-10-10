unit DM.User.Registration;

interface

uses
  System.SysUtils,
  System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDMUserRegistration = class(TDataModule)
    qyUserRegistration: TFDQuery;
    qyUserRegistrationnome: TStringField;
    qyUserRegistrationemail: TStringField;
    qyUserRegistrationlogin: TStringField;
    qyUserRegistrationsenha: TStringField;
    qyUserRegistrationativo: TStringField;
    qyUserRegistrationadministrador: TStringField;
    qyUserRegistrationusuario_sistema: TStringField;
    qyUserRegistrationid: TFDAutoIncField;
    qyListGroup: TFDQuery;
    qyListGroupid: TIntegerField;
    qyListGroupnome: TStringField;
    qyUserRegistrationid_grupo: TIntegerField;
  public
    function LoadListGroup(Connection: TComponent; SqlGroup: string): TDataSet;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMUserRegistration }

function TDMUserRegistration.LoadListGroup(Connection: TComponent; SqlGroup: string): TDataSet;
begin
  qyListGroup.Connection := Connection as TFDConnection;
  qyListGroup.SQL.Text := SqlGroup;
  qyListGroup.Open;
  Result := qyListGroup;
end;

end.
