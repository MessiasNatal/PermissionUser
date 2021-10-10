unit View.User.Registration;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Data.DB,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  DM.User.Registration,
  Query,
  View.User.InsertEdit;

type
  TViewUserRegistration = class(TForm)
    pnlDefault: TPanel;
    pnlPesquisa: TPanel;
    btnInsert: TBitBtn;
    btnEdit: TBitBtn;
    btnDelete: TBitBtn;
    grdRecords: TDBGrid;
    dsRegistration: TDataSource;
    btnFechar: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDMUserRegistration: TDMUserRegistration;
    FPermissionUser: TComponent;
    FSQLUserRegistration: string;
    procedure OpenViewInsertEdit(Operation: TDataSetState);
    procedure Operation(Sender: TObject);
  public
    property PermissionUser: TComponent read FPermissionUser write FPermissionUser;
    property SQLUserRegistration: string read FSQLUserRegistration write FSQLUserRegistration;
  end;

implementation

{$R *.dfm}

uses
  PermissionUser;

{ TViewUserRegistration }

procedure TViewUserRegistration.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TViewUserRegistration.FormCreate(Sender: TObject);
begin
  FDMUserRegistration := TDMUserRegistration.Create(Self);
  dsRegistration.DataSet := FDMUserRegistration.qyUserRegistration;

  btnInsert.OnClick := Operation;
  btnEdit.OnClick := Operation;
  btnDelete.OnClick := Operation;
end;

procedure TViewUserRegistration.FormShow(Sender: TObject);
begin
  try
    FDMUserRegistration.qyUserRegistration.SQL.Text := SQLUserRegistration;
    FDMUserRegistration.qyUserRegistration.Connection := TQueryFD.GetConn(TPermissionUser(FPermissionUser).PermissionUserConnection.Connection);
    FDMUserRegistration.qyUserRegistration.Open;
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

procedure TViewUserRegistration.OpenViewInsertEdit(Operation: TDataSetState);
begin
  with TViewUserInsertEdit.Create(Self) do
    try
      dsRegistrationInsertEdit.DataSet := dsRegistration.DataSet;
      case Operation of
        dsInsert: dsRegistrationInsertEdit.DataSet.Insert;
        dsEdit: dsRegistrationInsertEdit.DataSet.Edit;
      end;
      PermissionUser := Self.FPermissionUser as TPermissionUser;
      DMUserRegistration := Self.FDMUserRegistration;
      ShowModal;
    finally
      Free;
    end;
end;

procedure TViewUserRegistration.Operation(Sender: TObject);
begin
  if Sender = btnInsert then
    OpenViewInsertEdit(dsInsert)
  else
  if (Sender = btnEdit) and dsRegistration.DataSet.FieldByName(TPermissionUser(FPermissionUser).PermissionUserTable.UserFieldAdmin).AsBoolean then
    OpenViewInsertEdit(dsEdit)
  else
  if (Sender = btnDelete) and (dsRegistration.DataSet.FieldByName(TPermissionUser(FPermissionUser).PermissionUserTable.UserFieldAdmin).AsBoolean) and (MessageBox(0,'Confirma exclusão do registro ?'+'','Informação',mb_iconquestion+mb_taskmodal+mb_yesno)=id_yes) then
    TQueryFD.Operation(toDelete,dsRegistration.DataSet);
end;

end.
