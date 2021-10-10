unit DM.User.Group;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDMUserGroup = class(TDataModule)
    qyGroup: TFDQuery;
    qyComponents: TFDQuery;
    qyListGroup: TFDQuery;
    qyListGroupid: TIntegerField;
    qyListGroupnome: TStringField;
    qyGroupComponentsUserLogged: TFDQuery;
  public
    procedure LoadGroup(Connection: TComponent; SqlGroup: string; out DataSetGroup: TDataSet);
    function LoadListGroup(Connection: TComponent; SqlGroup: string): TDataSet;
    procedure LoadComponents(Connection: TComponent; SqlComponents: string; out DataSetComponents: TDataSet);
    function GetNewDataset(AOwner: TComponent; FieldId,FieldDescritpion: string): TDataSet;
    function LoadGroupComponentsUserLogged(Connection: TComponent; SqlGroupComponentsUserLogged: string): TDataSet;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMUserGroup }

function TDMUserGroup.GetNewDataset(AOwner: TComponent; FieldId,FieldDescritpion: string): TDataSet;
var
  memComponentsFilter: TFDMemTable;
begin
  memComponentsFilter := TFDMemTable.Create(AOwner);
  memComponentsFilter.FieldDefs.Add('selectedImage',ftString,1,True);
  memComponentsFilter.FieldDefs.Add('selectedField',ftString,1,True);
  memComponentsFilter.FieldDefs.Add(FieldDescritpion,ftString,50,True);
  memComponentsFilter.FieldDefs.Add(FieldId,ftInteger);
  memComponentsFilter.CreateDataSet;
  Result := memComponentsFilter;
end;

procedure TDMUserGroup.LoadComponents(Connection: TComponent; SqlComponents: string; out DataSetComponents: TDataSet);
begin
  qyComponents.Connection := Connection as TFDConnection;
  qyComponents.SQL.Text := SqlComponents;
  qyComponents.Open;
  DataSetComponents := qyComponents;
end;

procedure TDMUserGroup.LoadGroup(Connection: TComponent; SqlGroup: string; out DataSetGroup: TDataSet);
begin
  qyGroup.Connection := Connection as TFDConnection;
  qyGroup.SQL.Text := SqlGroup;
  qyGroup.Open;
  DataSetGroup := qyGroup;
end;

function TDMUserGroup.LoadListGroup(Connection: TComponent; SqlGroup: string): TDataSet;
begin
  qyListGroup.Connection := Connection as TFDConnection;
  qyListGroup.SQL.Text := SqlGroup;
  qyListGroup.Open;
  Result := qyListGroup;
end;

function TDMUserGroup.LoadGroupComponentsUserLogged(Connection: TComponent; SqlGroupComponentsUserLogged: string): TDataSet;
begin
  qyGroupComponentsUserLogged.Connection := Connection as TFDConnection;
  qyGroupComponentsUserLogged.SQL.Text := SqlGroupComponentsUserLogged;
  qyGroupComponentsUserLogged.Open;
  Result := qyGroupComponentsUserLogged;
end;

end.
