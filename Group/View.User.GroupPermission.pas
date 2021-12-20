unit View.User.GroupPermission;

interface

uses
  PermissionUser, Query, DM.User.Group, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.ImageList, System.UITypes, Data.DB, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ImgList, Vcl.ComCtrls;

type
  TViewUserGroupPermission = class(TForm)
    pnl1: TPanel;
    lblGroup: TLabel;
    edtGroup: TEdit;
    pnlDefault: TPanel;
    pnlOperation: TPanel;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    pnlGrid: TPanel;
    pgcDefault: TPageControl;
    tshGrid: TTabSheet;
    tshRecord: TTabSheet;
    DBGrid1: TDBGrid;
    dsRecords: TDataSource;
    pnlOperacoes: TPanel;
    btnInsert: TBitBtn;
    btnDelete: TBitBtn;
    btnEdit: TBitBtn;
    btnPesquisar: TBitBtn;
    btnClose: TBitBtn;
    pnlOperationCheck: TPanel;
    btnNotAll: TSpeedButton;
    bntAll: TSpeedButton;
    scrList: TScrollBox;
    ImgList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bntAllClick(Sender: TObject);
    procedure btnNotAllClick(Sender: TObject);
  private
    FDataGroup: TDMUserGroup;
    FDataSetGroup: TDataSet;
    FDataSetComponents: TDataSet;
    FPermissionUser: TPermissionUser;
    procedure OnDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure OnDblClick(Sender: TObject);
    procedure FreeObjectGrid;
    procedure DeleteGroup(IdGroup: Integer);
    procedure OpenGroup;
    procedure CheckGroups(Selected: string; IdItemGroup: Integer = 0);
    procedure OnClickOperation(Sender: TObject);
  public
    property PermissionUser: TPermissionUser read FPermissionUser write FPermissionUser;
  end;

implementation

{$R *.dfm}

procedure TViewUserGroupPermission.CheckGroups(Selected: string; IdItemGroup: Integer = 0);
var
  i,y: Integer;
begin
  for i := 0 to Pred(scrList.ControlCount) do
    if (scrList.Controls[i] is TPanel) then
      for y := 0 to Pred(TPanel(scrList.Controls[i]).ControlCount) do
        if TPanel(scrList.Controls[i]).Controls[y] is TDBGrid then
          with TDBGrid(TPanel(scrList.Controls[i]).Controls[y]).DataSource do
            try
              DataSet.DisableControls;
              DataSet.First;
              while not DataSet.Eof do
              begin
                if IdItemGroup = 0 then
                begin
                  DataSet.Edit;
                  DataSet.FieldByName('selectedField').AsString := Selected;
                  DataSet.Post;
                end
                else
                begin
                  if IdItemGroup = DataSet.FieldByName(FPermissionUser.PermissionUserTableGroupUser.UserFieldId).AsInteger then
                  begin
                    DataSet.Edit;
                    DataSet.FieldByName('selectedField').AsString := Selected;
                    DataSet.Post;
                  end;
                end;
               DataSet.Next;
              end;
            finally
              DataSet.EnableControls;
            end;
end;

procedure TViewUserGroupPermission.DeleteGroup(IdGroup: Integer);
const
  SqlDelete = 'delete from %s '+
              'where '+
              '  %s = :%s';
begin
  with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlDelete,[FPermissionUser.PermissionUserTableGroupUser.UserTableName,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser])).qy do
    try
      ParamByName(FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser).AsInteger := IdGroup;
      ExecSQL;
    finally
      Free;
    end;
end;

procedure TViewUserGroupPermission.FormCreate(Sender: TObject);
begin
  FDataGroup := TDMUserGroup.Create(Self);

  pgcDefault.ActivePageIndex := 0;
  tshRecord.TabVisible := False;

  btnInsert.OnClick := OnClickOperation;
  btnEdit.OnClick := OnClickOperation;
  btnDelete.OnClick := OnClickOperation;
  btnClose.OnClick := OnClickOperation;
  btnSave.OnClick := OnClickOperation;
  btnCancel.OnClick := OnClickOperation;
end;

procedure TViewUserGroupPermission.FormShow(Sender: TObject);
begin
  OpenGroup;
end;

procedure TViewUserGroupPermission.FreeObjectGrid;
var
  i: Integer;
begin
  try
    scrList.Visible := False;
     for i := scrList.ControlCount - 1 downto 0 do
       scrList.Controls[i].Destroy;
  finally
    scrList.Visible := True;
  end;
end;

procedure TViewUserGroupPermission.OnClickOperation(Sender: TObject);

  function GetSQLComponents: string;
  const
    SqlGroup = 'select '+
               '  * '+
               'from '+
               '  %s '+
               'order by 2';
  begin
    case FPermissionUser.PermissionUserConnection.DataBase of
      Mysql: Result := Format(SqlGroup,[FPermissionUser.PermissionUserTableGroupComponents.UserTableName]);
    end;
  end;

  function GetSQLGroup: string;
  const
    SqlGroup = 'select '+
               '  * '+
               'from '+
               '  %s '+
               'group by '+
               '  %s ';
  begin
    case FPermissionUser.PermissionUserConnection.DataBase of
      Mysql: Result := Format(SqlGroup,[FPermissionUser.PermissionUserTableGroupComponents.UserTableName,
                                        FPermissionUser.PermissionUserTableGroupComponents.UserFieldGroup]);
    end;
  end;

  procedure CreateGridComponents(Group: string);
  var
    grdComponents: TDBGrid;
    dsComponents: TDataSource;
    Bookmark: TBookmark;
    PnlParent, PnlTitle : TPanel;
  begin
    //PANEL TITLE GROUP
    PnlTitle := TPanel.Create(Self);
    PnlTitle.Caption := Group+':';
    PnlTitle.Font.Size := 9;
    PnlTitle.Font.Name := 'Segoe UI';
    PnlTitle.Font.Style := [fsBold];
    PnlTitle.Height := 20;
    PnlTitle.Alignment := taLeftJustify;
    PnlTitle.Align := alTop;
    PnlTitle.BevelOuter := bvNone;

    //GRID
    grdComponents := TDBGrid.Create(Self);
    dsComponents := TDataSource.Create(grdComponents);
    dsComponents.DataSet := FDataGroup.GetNewDataset(grdComponents,FPermissionUser.PermissionUserTableGroupComponents.UserFieldId,FPermissionUser.PermissionUserTableGroupComponents.UserFieldDescription);
    grdComponents.DataSource := dsComponents;
    grdComponents.OnDrawColumnCell := Self.OnDrawColumnCell;
    grdComponents.OnDblClick := Self.OnDblClick;
    grdComponents.Align := alClient;
    grdComponents.Columns[0].Width := 25;
    grdComponents.Columns[2].Width := scrList.Width - 50;
    grdComponents.Columns[1].Visible := False;
    grdComponents.Columns[3].Visible := False;
    grdComponents.BorderStyle := bsNone;
    grdComponents.Tag := 1;
    grdComponents.Options := [dgRowSelect];

    Bookmark := FDataSetComponents.GetBookmark;
    try
      FDataSetComponents.Filter := Format('%s = %s',[FPermissionUser.PermissionUserTableGroupComponents.UserFieldGroup,QuotedStr(Group)]);
      FDataSetComponents.Filtered := True;
      FDataSetComponents.First;
      while not FDataSetComponents.Eof do
      begin
        dsComponents.DataSet.Append;
        dsComponents.DataSet.FieldByName(FPermissionUser.PermissionUserTableGroupComponents.UserFieldDescription).AsString := FDataSetComponents.FieldByName(FPermissionUser.PermissionUserTableGroupComponents.UserFieldDescription).AsString;
        dsComponents.DataSet.FieldByName(FPermissionUser.PermissionUserTableGroupComponents.UserFieldId).AsInteger := FDataSetComponents.FieldByName(FPermissionUser.PermissionUserTableGroupComponents.UserFieldId).AsInteger;
        dsComponents.DataSet.FieldByName('selectedField').AsString := 'N';
        dsComponents.DataSet.Post;
        FDataSetComponents.Next;
      end;
      dsComponents.DataSet.First;
      grdComponents.Height := grdComponents.DataSource.DataSet.RecordCount * 25;
    finally
      FDataSetComponents.Filtered := False;
      FDataSetComponents.GotoBookmark(Bookmark);
      FDataSetComponents.FreeBookmark(Bookmark);
    end;

    //PANEL PARENT
    PnlParent := TPanel.Create(Self);
    PnlParent.Height := PnlTitle.Height + grdComponents.Height;
    PnlParent.Align := alTop;
    PnlParent.BevelOuter := bvNone;
    PnlParent.Parent := scrList;

    PnlTitle.Parent := PnlParent;
    grdComponents.Parent := PnlParent;
  end;

  procedure CreateGroupListPanel;
  begin
    try
      FDataSetGroup.First;
      FDataSetGroup.DisableControls;
      while not FDataSetGroup.Eof do
      begin
        CreateGridComponents(FDataSetGroup.FieldByName(FPermissionUser.PermissionUserTableGroupComponents.UserFieldGroup).AsString);
        FDataSetGroup.Next;
      end;
    finally
      FDataSetGroup.EnableControls;
    end;
  end;

  procedure SelectedEdit(IdGroup: Integer);
  const
    SqlEdit = 'select '+
              '  * '+
              'from '+
              '  %s '+
              'where '+
              '  %s = :%s ';
  begin
    with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlEdit,[FPermissionUser.PermissionUserTableGroupUser.UserTableName,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser])).qy do
      try
        ParamByName(FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser).AsInteger := IdGroup;
        Open;
        First;
        while not Eof do
        begin
          CheckGroups('S',FieldByName(FPermissionUser.PermissionUserTableGroupUser.UserFieldIdGroup).AsInteger);
          Next;
        end;
      finally
        Free;
      end;
  end;

  procedure SaveComponentsGroup(IdGroup: Integer);
  const
    SqlInsertGroupComponents = 'insert into %s '+
                               ' (%s, '+
                               '  %s) '+
                               'values '+
                               ' (:%s, '+
                               '  :%s) ';
  var
    i,y: Integer;
  begin
    for i := 0 to Pred(scrList.ControlCount) do
      if (scrList.Controls[i] is TPanel) then
        for y := 0 to Pred(TPanel(scrList.Controls[i]).ControlCount) do
          if TPanel(scrList.Controls[i]).Controls[y] is TDBGrid then
            with TDBGrid(TPanel(scrList.Controls[i]).Controls[y]).DataSource do
              try
                DataSet.DisableControls;
                DataSet.First;
                while not DataSet.Eof do
                begin
                  if DataSet.FieldByName('selectedField').AsString = 'S' then
                  begin
                    with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlInsertGroupComponents,[FPermissionUser.PermissionUserTableGroupUser.UserTableName,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdGroup,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdGroup,FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser])).qy do
                      try
                        ParamByName(FPermissionUser.PermissionUserTableGroupUser.UserFieldIdGroup).AsInteger := DataSet.FieldByName(FPermissionUser.PermissionUserTableGroupComponents.UserFieldId).AsInteger;
                        ParamByName(FPermissionUser.PermissionUserTableGroupUser.UserFieldIdUser).AsInteger := IdGroup;
                        ExecSQL;
                      finally
                        Free;
                      end;
                  end;
                  DataSet.Next;
                end;
              finally
                DataSet.EnableControls;
              end;
  end;

  procedure SaveGroup;
  const
    SqlMaxId = 'select '+
               '  max(%s) as %s '+
               'from '+
               '  %s ';
    SqlInsertGroup = 'insert into %s '+
                     '  (%s) '+
                     'values '+
                     '  (:%s) ';
  begin
    try
      DeleteGroup(dsRecords.DataSet.Fields[0].AsInteger);
      if dsRecords.DataSet.State = dsInsert then
      begin
        with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlInsertGroup,[FPermissionUser.PermissionUserTable.UserTableName,FPermissionUser.PermissionUserTable.UserFieldName,FPermissionUser.PermissionUserTable.UserFieldName])).qy do
          try
            ParamByName(FPermissionUser.PermissionUserTable.UserFieldName).AsString := edtGroup.Text;
            ExecSQL;
          finally
            Free;
          end;
        with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlMaxId,[FPermissionUser.PermissionUserTable.UserFieldId,FPermissionUser.PermissionUserTable.UserFieldId,FPermissionUser.PermissionUserTable.UserTableName])).qy do
          try
            Open;
            SaveComponentsGroup(FieldByName(FPermissionUser.PermissionUserTable.UserFieldId).AsInteger);
          finally
            Free;
          end;
      end
      else
      if dsRecords.DataSet.State = dsEdit then
        SaveComponentsGroup(dsRecords.DataSet.Fields[0].AsInteger);
    except
      on e: Exception do
        raise Exception.Create(e.Message);
    end;
  end;

  procedure Loads;
  begin
    FDataGroup.LoadGroup(FPermissionUser.PermissionUserConnection.Connection,GetSQLGroup,FDataSetGroup);
    FDataGroup.LoadComponents(FPermissionUser.PermissionUserConnection.Connection,GetSQLComponents,FDataSetComponents);
    CreateGroupListPanel;
  end;

begin
  if Sender = btnInsert then
  begin
    try
      dsRecords.DataSet.Append;
      edtGroup.Clear;
      Loads;
    finally
      tshGrid.TabVisible := False;
      tshRecord.TabVisible := True;
    end;
  end
  else
  if Sender = btnEdit then
  begin
    if dsRecords.DataSet.IsEmpty then
      Exit;
    try
      dsRecords.DataSet.Edit;
      edtGroup.Text := dsRecords.DataSet.FieldByName(FPermissionUser.PermissionUserTable.UserFieldName).AsString;
      Loads;
      SelectedEdit(dsRecords.DataSet.Fields[0].AsInteger);
    finally
      tshGrid.TabVisible := False;
      tshRecord.TabVisible := True;
    end;
  end
  else
  if Sender = btnSave then
  begin
    if edtGroup.Text = '' then
    begin
      MessageDlg('Favor preencher o(s) seguinte(s) campo(s) obrigatório(s) '+ #13 + '- Descrição do Grupo',mtWarning,[mbok],0);
      Exit;
    end;
    try
      SaveGroup;
      OpenGroup;
      FreeObjectGrid;
    finally
      tshRecord.TabVisible := False;
      tshGrid.TabVisible := True;
    end;
  end
  else
  if Sender = btnDelete then
  begin
    if (dsRecords.DataSet.IsEmpty) or (MessageBox(0,'Confirma exclusão do registro ?'+'','Informação',mb_iconquestion+mb_taskmodal+mb_yesno)=id_no) then
      Exit;
    DeleteGroup(dsRecords.DataSet.Fields[0].AsInteger);
    TQueryFD.Operation(toDelete,dsRecords.DataSet);
  end
  else
  if Sender = btnCancel then
  begin
    try
      FreeObjectGrid;
      dsRecords.DataSet.Cancel;
    finally
      tshRecord.TabVisible := False;
      tshGrid.TabVisible := True;
    end;
  end
  else
  if Sender = btnClose then
    Close;
end;

procedure TViewUserGroupPermission.OnDblClick(Sender: TObject);
begin
  if TDBGrid(Sender).DataSource.DataSet.FieldByName('selectedField').AsString = 'S' then
  begin
    TDBGrid(Sender).DataSource.DataSet.Edit;
    TDBGrid(Sender).DataSource.DataSet.FieldByName('selectedField').AsString := 'N';
    TDBGrid(Sender).DataSource.DataSet.Post;
  end
  else
  begin
    TDBGrid(Sender).DataSource.DataSet.Edit;
    TDBGrid(Sender).DataSource.DataSet.FieldByName('selectedField').AsString := 'S';
    TDBGrid(Sender).DataSource.DataSet.Post;
  end;
end;

procedure TViewUserGroupPermission.OnDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.Field = TDBGrid(Sender).DataSource.DataSet.FieldByName('selectedImage') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    if TDBGrid(Sender).DataSource.DataSet.FieldByName('selectedField').AsString = 'N' then
      ImgList.Draw(TDBGrid(Sender).Canvas,Rect.Left+5,Rect.Top+1,0)
    else
      ImgList.Draw(TDBGrid(Sender).Canvas,Rect.Left+5,Rect.Top+1,1);
  end;
end;

procedure TViewUserGroupPermission.OpenGroup;
const
  SqlSelect = 'select '+
              '  * '+
              'from '+
              '  %s '+
              'where '+
              '  %s is null and '+
              '  %s = ''false''';
begin
  dsRecords.DataSet := FDataGroup.LoadListGroup(FPermissionUser.PermissionUserConnection.Connection,Format(SqlSelect,[FPermissionUser.PermissionUserTable.UserTableName,
                                                                                                                      FPermissionUser.PermissionUserTable.UserFieldIdGroup,
                                                                                                                      FPermissionUser.PermissionUserTable.UserFieldUserSystem]));
end;

procedure TViewUserGroupPermission.bntAllClick(Sender: TObject);
begin
  CheckGroups('N');
end;

procedure TViewUserGroupPermission.btnNotAllClick(Sender: TObject);
begin
  CheckGroups('S');
end;

end.
