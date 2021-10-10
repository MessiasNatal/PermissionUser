unit Query;

interface

uses
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Stan.Param,
  System.Classes,
  System.SysUtils,
  System.UITypes,
  Data.DB,
  Vcl.Dialogs;

type
  TOperation = (toSave, toDelete, toCancel);

  TQueryFD = class
  private
    FQuery: TFDQuery;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
  public
    constructor Create(Conexao: TComponent; Sql: string = '');
    destructor Destroy; override;
    property qy: TFDQuery read FQuery write FQuery;
    class function GetConn(Connection: TComponent): TFDConnection;
    class procedure Operation(Operation: TOperation; DataSet: TDataSet);
    class function ValidadeFields(DataSet: TDataSet): Boolean;
  end;

implementation

{ TQUERY }

class procedure TQueryFD.Operation(Operation: TOperation; DataSet: TDataSet);
begin
  case Operation of
    toSave:
    begin
      TFDQuery(DataSet).Edit;
      TFDQuery(DataSet).ApplyUpdates(0);
      TFDQuery(DataSet).CommitUpdates;
    end;
    toDelete:
    begin
      TFDQuery(DataSet).Delete;
      TFDQuery(DataSet).ApplyUpdates(0);
      TFDQuery(DataSet).CommitUpdates;
    end;
    toCancel:
    begin
      TFDQuery(DataSet).Cancel;
      TFDQuery(DataSet).CancelUpdates;
    end;
  end;
end;

constructor TQueryFD.Create(Conexao: TComponent; Sql: string = '');
begin
  FDPhysMySQLDriverLink := TFDPhysMySQLDriverLink.Create(nil);
  FDGUIxWaitCursor:= TFDGUIxWaitCursor(nil);
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TFDConnection(Conexao);
  FQuery.CachedUpdates := True;
  FQuery.SQL.Clear;
  if Sql <> '' then
    FQuery.SQL.Add(Sql);
end;

destructor TQueryFD.Destroy;
begin
  FQuery.Free;
  FDPhysMySQLDriverLink.Free;
  FDGUIxWaitCursor.Free;
  inherited;
end;

class function TQueryFD.GetConn(Connection: TComponent): TFDConnection;
begin
  Result := TFDConnection(Connection);
end;

class function TQueryFD.ValidadeFields(DataSet: TDataSet): Boolean;
var
  cont: integer;
  Fields : string;
begin
  Result := True;
  Fields := '';
  for cont := 0 to DataSet.FieldCount - 1 do
  begin
    if DataSet.Fields[cont].Required then
    begin
      if DataSet.Fields[cont].DataType=ftWideString then
      begin
        if (DataSet.Fields[cont].IsNull) or (trim(DataSet.fields[cont].asstring)='') then
        begin
          Fields := Fields + ' - '+  DataSet.Fields[cont].DisplayLabel + #13;
          DataSet.Fields[cont].FocusControl;
          Result:=False;
        end;
      end
      else if DataSet.Fields[cont].DataType=ftWideString then
      begin
        if (DataSet.Fields[cont].IsNull) or (trim(DataSet.fields[cont].asstring)='') then
        begin
          Fields := Fields + ' - '+  DataSet.Fields[cont].DisplayLabel + #13;
          DataSet.Fields[cont].FocusControl;
          Result:=False;
        end;
      end
      else if (DataSet.Fields[cont].DataType=ftinteger) then
      begin
        if (DataSet.Fields[cont].IsNull) or (DataSet.fields[cont].asinteger=0) then
        begin
          Fields := Fields + ' - '+  DataSet.Fields[cont].DisplayLabel + #13;
          DataSet.Fields[cont].FocusControl;
          Result:=False;
        end;
      end
      else if (DataSet.fields[cont].datatype=ftcurrency) then
      begin
        if (DataSet.Fields[cont].IsNull) or (DataSet.fields[cont].ascurrency=0) then
        begin
          Fields := Fields + ' - '+  DataSet.Fields[cont].DisplayLabel + #13;
          DataSet.Fields[cont].FocusControl;
          Result:=False;
        end;
      end
      else if (DataSet.fields[cont].datatype=ftfloat) then
      begin
        if (DataSet.Fields[cont].IsNull) or (DataSet.fields[cont].asfloat=0) then
        begin
          Fields := Fields + ' - '+  DataSet.Fields[cont].DisplayLabel + #13;
          DataSet.Fields[cont].FocusControl;
          Result:=False;
        end;
      end
      else if DataSet.Fields[cont].DataType=ftFMTBcd then
      begin
        if (DataSet.Fields[cont].IsNull) or (DataSet.fields[cont].AsFloat=0) then
        begin
          Fields := Fields + ' - '+  DataSet.Fields[cont].DisplayLabel + #13;
          DataSet.Fields[cont].FocusControl;
          Result:=False;
        end;
      end
      else
      begin
        if (DataSet.Fields[cont].IsNull) or (trim(DataSet.fields[cont].asstring)='') then
        begin
          Fields := Fields + ' - '+  DataSet.Fields[cont].DisplayLabel + #13;
          DataSet.Fields[cont].FocusControl;
          Result:=False;
        end;
      end;
    end;
  end;
  if not Result then
    MessageDlg('Favor preencher o(s) seguinte(s) campo(s) obrigatório(s) '+ #13 + Fields  ,mtInformation,[mbOK],0);
end;

end.
