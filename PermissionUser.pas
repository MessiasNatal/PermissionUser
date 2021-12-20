unit PermissionUser;

interface

uses
  Query, System.Classes, System.SysUtils, System.UITypes, Data.DB, Vcl.Forms, Vcl.Controls, Vcl.Dialogs,
  Vcl.Buttons;

type
  TDataBase = (Mysql {Implement your base});
  TMiddleware = (Firedac {Implement your middleware});
  TNotAuthorized = (naDisabled, naInvisible);
  TLoginOperation = (loAuthorized, loNotAuthorized, loCancel);

  TPermissionUser = class;
  TPermissionUserRegistration = class;

{***********************************************************************************************************************
*******************************************************CONNECTION*******************************************************
************************************************************************************************************************}

  TPermissionUserConection = class(TComponent)
  strict private
    FConnection: TCustomConnection;
    FDataBase: TDataBase;
    FMiddleware: TMiddleware;
  published
    property Connection: TCustomConnection read FConnection write FConnection;
    property DataBase: TDataBase read FDataBase write FDataBase default Mysql;
    property Middleware: TMiddleware read FMiddleware write FMiddleware default Firedac;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

{***********************************************************************************************************************
*********************************************************TABLES*********************************************************
************************************************************************************************************************}

  TPermissionUserTable = class(TPersistent)
  strict private
    FPermissionUser: TPermissionUser;
    FUserTableName: string;
    FUserFieldId: string;
    FUserFieldName: string;
    FUserFieldEmail: string;
    FUserFieldAdmin: string;
    FUserFieldLogin: string;
    FUserFieldPassword: string;
    FUserFieldActive: string;
    FUserFieldUserSystem: string;
    FUserFieldIdGroup: string;
    procedure CreateTable;
  published
    property UserTableName: string read FUserTableName write FUserTableName;
    property UserFieldId: string read FUserFieldId write FUserFieldId;
    property UserFieldName: string read FUserFieldName write FUserFieldName;
    property UserFieldEmail: string read FUserFieldEmail write FUserFieldEmail;
    property UserFieldAdmin: string read FUserFieldAdmin write FUserFieldAdmin;
    property UserFieldLogin: string read FUserFieldLogin write FUserFieldLogin;
    property UserFieldPassword: string read FUserFieldPassword write FUserFieldPassword;
    property UserFieldActive: string read FUserFieldActive write FUserFieldActive;
    property UserFieldUserSystem: string read FUserFieldUserSystem write FUserFieldUserSystem;
    property UserFieldIdGroup: string read FUserFieldIdGroup write FUserFieldIdGroup;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Load;
  end;

  TPermissionUserTableGroupComponents = class(TPersistent)
  strict private
    FPermissionUser: TPermissionUser;
    FUserTableName: string;
    FUserFieldId: string;
    FUserFieldComponent: string;
    FUserFieldGroup: string;
    FUserFieldForm: string;
    FUserFieldDescription: string;
    procedure CreateTable;
    procedure InsertComponents;
  published
    property UserTableName: string read FUserTableName write FUserTableName;
    property UserFieldId: string read FUserFieldId write FUserFieldId;
    property UserFieldComponent: string read FUserFieldComponent write FUserFieldComponent;
    property UserFieldGroup: string read FUserFieldGroup write FUserFieldGroup;
    property UserFieldForm: string read FUserFieldForm write FUserFieldForm;
    property UserFieldDescription: string read FUserFieldDescription write FUserFieldDescription;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Load;
    procedure OpenViewGroup;
  end;

  TPermissionUserTableGroupUser = class(TPersistent)
  strict private
    FPermissionUser: TPermissionUser;
    FUserTableName: string;
    FUserFieldId: string;
    FUserFieldIdGroup: string;
    FUserFieldIdUser: string;
    procedure CreateTable;
  published
    property UserTableName: string read FUserTableName write FUserTableName;
    property UserFieldId: string read FUserFieldId write FUserFieldId;
    property UserFieldIdGroup: string read FUserFieldIdGroup write FUserFieldIdGroup;
    property UserFieldIdUser: string read FUserFieldIdUser write FUserFieldIdUser;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Load;
  end;

{***********************************************************************************************************************
****************************************************GROUP COMPONENTS****************************************************
************************************************************************************************************************}

  //COMPONENTS VIEW

  TPermissionUserComponentsItems = class(TCollectionItem)
  strict private
    FComponent: TControl;
    FDescription: string;
  private
    procedure SetComponent(const Value: TControl);
  published
    property Component: TControl read FComponent write SetComponent;
    property Description: string read FDescription write FDescription;
  protected
    function GetDisplayName: String; override;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  TPermissionUserComponents = class(TCollection)
  strict private
    function GetItem(Index: Integer): TPermissionUserComponentsItems;
    procedure SetItem(Index: Integer; Value: TPermissionUserComponentsItems);
  public
    constructor Create;
    function Add: TPermissionUserComponentsItems;
    property Items[Index: Integer]: TPermissionUserComponentsItems read GetItem write SetItem; default;
  end;

  TPermissionUserComponentsConfiguration = class(TComponent)
  strict private
    FPermissionUser: TPermissionUser;
    FView: TForm;
    FGroup: string;
    FNotAuthorized: TNotAuthorized;
    FPermissionUserComponents: TPermissionUserComponents;
    FActive: Boolean;
    FMain: Boolean;
  published
    property PermissionUser: TPermissionUser read FPermissionUser write FPermissionUser;
    property View: TForm read FView write FView;
    property Group: string read FGroup write FGroup;
    property NotAuthorized: TNotAuthorized read FNotAuthorized write FNotAuthorized;
    property PermissionUserComponents: TPermissionUserComponents read FPermissionUserComponents write FPermissionUserComponents;
    property Active: Boolean read FActive write FActive;
    property Main: Boolean read FMain write FMain;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load;
  end;

  //COMPONENTS ALL

  TPermissionUserComponentsItemsAll = class(TCollectionItem)
  strict private
    FPermissionUser: TPermissionUser;
    FComponent: string;
    FDescription: string;
    FGroup: string;
    FView: string;
  published
    property Component: string read FComponent write FComponent;
    property Description: string read FDescription write FDescription;
    property Group: string read FGroup write FGroup;
    property View: string read FView write FView;
  protected
    function GetDisplayName: String; override;
  public
    procedure Assign(Source: TPersistent); override;
    property PermissionUser: TPermissionUser read FPermissionUser write FPermissionUser;
  end;

  TPermissionUserComponentsAll = class(TCollection)
  strict private
    function GetItem(Index: Integer): TPermissionUserComponentsItemsAll;
    procedure SetItem(Index: Integer; Value: TPermissionUserComponentsItemsAll);
  public
    constructor Create;
    function Add: TPermissionUserComponentsItemsAll;
    property Items[Index: Integer]: TPermissionUserComponentsItemsAll read GetItem write SetItem; default;
  end;

{***********************************************************************************************************************
******************************************************REGISTRATION******************************************************
************************************************************************************************************************}

  TPermissionUserRegistration = class
  strict private
    FPermissionUser: TPermissionUser;
    FId: Integer;
    FName: string;
    FEmail: string;
    FLogin: string;
    FPassword: string;
    FActive: Boolean;
    FAdmin: Boolean;
    FUserSystem: Boolean;
    FIdGroup: Integer;
    FComponents: TDataSet;
  private
    function LoginUser: TLoginOperation;
    procedure OpenViewRegistration;
  public
    property PermissionUser: TPermissionUser read FPermissionUser write FPermissionUser;
    property Id: Integer read FId write FId;
    property Login: string read FLogin write FLogin;
    property Name: string read FName write FName;
    property Email: string read FEmail write FEmail;
    property Admin: Boolean read FAdmin write FAdmin;
    property Password: string read FPassword write FPassword;
    property Active: Boolean read FActive write FActive;
    property UserSystem: Boolean read FUserSystem write FUserSystem;
    property IdGroup: Integer read FIdGroup write FIdGroup;
    property Components: TDataSet read FComponents write FComponents;
  public
    constructor Create(PermissionUser: TPermissionUser);
    destructor Destroy; override;
    procedure ModifyPassword;
  end;

{***********************************************************************************************************************
*******************************************************CLASS MAIN*******************************************************
************************************************************************************************************************}

  TPermissionUser = class(TComponent)
  strict private
    FUserDefaultName: string;
    FUserDefaultLogin: string;
    FUserDefaultPassword: string;
    FUserDefaultEmail: string;
    FPermissionUserTable: TPermissionUserTable;
    FPermissionUserConection: TPermissionUserConection;
    FPermissionUserTableGroupComponents: TPermissionUserTableGroupComponents;
    FPermissionUserTableGroupUser: TPermissionUserTableGroupUser;
    FUserLogged: TPermissionUserRegistration;
    FMessageLoginNotAuthorized: string;
    FBtnUserRegistration: TSpeedButton;
    FBtnGroup: TSpeedButton;
    FBtnModifyPassword: TSpeedButton;
    FPermissionUserComponentsAll: TPermissionUserComponentsAll;
  published
    property UserDefaultName: string read FUserDefaultName write FUserDefaultName;
    property UserDefaultLogin: string read FUserDefaultLogin write FUserDefaultLogin;
    property UserDefaultPassword: string read FUserDefaultPassword write FUserDefaultPassword;
    property UserDefaultEmail: string read FUserDefaultEmail write FUserDefaultEmail;
    property MessageLoginNotAuthorized: string read FMessageLoginNotAuthorized write FMessageLoginNotAuthorized;
    property PermissionUserTable: TPermissionUserTable read FPermissionUserTable write FPermissionUserTable;
    property PermissionUserConnection: TPermissionUserConection read FPermissionUserConection write FPermissionUserConection;
    property PermissionUserTableGroupComponents: TPermissionUserTableGroupComponents read FPermissionUserTableGroupComponents write FPermissionUserTableGroupComponents;
    property PermissionUserTableGroupUser: TPermissionUserTableGroupUser read FPermissionUserTableGroupUser write FPermissionUserTableGroupUser;
    property BtnUserRegistration: TSpeedButton read FBtnUserRegistration write FBtnUserRegistration;
    property BtnGroup: TSpeedButton read FBtnGroup write FBtnGroup;
    property BtnModifyPassword: TSpeedButton read FBtnModifyPassword write FBtnModifyPassword;
    property PermissionUserComponentsAll: TPermissionUserComponentsAll read FPermissionUserComponentsAll write FPermissionUserComponentsAll;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnClickUserRegistration(Sender: TObject);
    procedure OnClickGroup(Sender: TObject);
    procedure OnClickModifyPassword(Sender: TObject);
    property UserLogged: TPermissionUserRegistration read FUserLogged;
    procedure Load;
    procedure Login;
    procedure LoadGroupPermission;
    function AsciiToInt(Caracter: Char): Integer;
    function Cript(Value:string; Key:integer): String;
    function DesCript(Value:string; Key:integer): String;
  end;

implementation

uses
  DM.User.Group, View.PermissionUser.Login, View.User.Registration, View.User.GroupPermission, View.User.Password;

{ TPermissionUser }

constructor TPermissionUser.Create(AOwner: TComponent);

  procedure LoginDefault;
  begin
    FUserDefaultLogin := 'admin';
    FUserDefaultName := 'admin admin';
    FUserDefaultPassword := '123';
    FUserDefaultEmail := 'admin@admin.com';
  end;

begin
  inherited Create(AOwner);
  LoginDefault;
  FMessageLoginNotAuthorized := 'User or Password Incorret';
  FUserLogged := TPermissionUserRegistration.Create(Self);
  FPermissionUserTable := TPermissionUserTable.Create(Self);
  FPermissionUserTableGroupComponents := TPermissionUserTableGroupComponents.Create(Self);
  FPermissionUserTableGroupUser := TPermissionUserTableGroupUser.Create(Self);
  FPermissionUserComponentsAll := TPermissionUserComponentsAll.Create;
end;

function TPermissionUser.AsciiToInt(Caracter: Char): Integer;
var
  i: Integer;
begin
  i := 32;
  while i < 255 do
  begin
    if Chr(i) = Caracter then
      Break;
    i := i + 1;
  end;
  Result := i;
end;

function TPermissionUser.Cript(Value: string; Key: integer): String;
var
  Count: integer;
  Return: string;
begin
  if (trim(Value) = EmptyStr) or (Key = 0) then
    result := Value
  else
  begin
    Return := '';
    for Count := 1 to Length(Value) do
      Return := Return + Chr(AsciiToInt(Value[Count]) + Key);
    result := Return;
  end;
end;

function TPermissionUser.DesCript(Value: string; Key: integer): String;
var
  Count: integer;
  Return: string;
begin
  if (Trim(Value) = EmptyStr) or (Key = 0) then
    Result := Value
  else
  begin
    Return := '';
    for Count := 1 to Length(Value) do
      Return := Return + Chr(AsciiToInt(Value[Count]) - Key);
    Result := Return;
  end;
end;

destructor TPermissionUser.Destroy;
begin
  FreeAndNil(FUserLogged);
  inherited;
end;

procedure TPermissionUser.Load;
begin
  FPermissionUserTable.Load;
  FPermissionUserTableGroupComponents.Load;
  FPermissionUserTableGroupUser.Load;

  FBtnUserRegistration.OnClick := Self.OnClickUserRegistration;
  FBtnGroup.OnClick := Self.OnClickGroup;
  FBtnModifyPassword.OnClick := Self.OnClickModifyPassword;
end;

procedure TPermissionUser.LoadGroupPermission;

  function LoadGroupPermission: TDataSet;
  const
    SqlGroup = 'select '+
               '  %s.* '+
               'from '+
               '  %s '+
               '  left join %s on %s.id = %s.%s '+
               'where '+
               '  %s.%s = %d ';
  var
    FDataGroupPermission: TDMUserGroup;
  begin
    FDataGroupPermission := TDMUserGroup.Create(Self);
    Result := FDataGroupPermission.LoadGroupComponentsUserLogged(PermissionUserConnection.Connection,Format(SqlGroup,[PermissionUserTableGroupComponents.UserTableName,
                                                                                                                      PermissionUserTableGroupUser.UserTableName,
                                                                                                                      PermissionUserTableGroupComponents.UserTableName,
                                                                                                                      PermissionUserTableGroupComponents.UserTableName,
                                                                                                                      PermissionUserTableGroupUser.UserTableName,
                                                                                                                      PermissionUserTableGroupUser.UserFieldIdGroup,
                                                                                                                      PermissionUserTableGroupUser.UserTableName,
                                                                                                                      PermissionUserTableGroupUser.UserFieldIdUser,
                                                                                                                      UserLogged.IdGroup]));
  end;

begin
  UserLogged.Components := LoadGroupPermission;
end;

procedure TPermissionUser.Login;
begin
  Load;
  UserLogged.LoginUser;
  LoadGroupPermission;
  FBtnUserRegistration.Visible := UserLogged.Admin;
end;

procedure TPermissionUser.OnClickGroup(Sender: TObject);
begin
  FPermissionUserTableGroupComponents.OpenViewGroup
end;

procedure TPermissionUser.OnClickModifyPassword(Sender: TObject);
begin
  FUserLogged.ModifyPassword;
end;

procedure TPermissionUser.OnClickUserRegistration(Sender: TObject);
begin
  FUserLogged.OpenViewRegistration;
end;

{ TPermissionUserConection }

constructor TPermissionUserConection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPermissionUserConection.Destroy;
begin
  FConnection := nil;
  inherited;
end;

{ TPermissionUserComponents }

constructor TPermissionUserComponentsConfiguration.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPermissionUserComponents := TPermissionUserComponents.Create;
  if not (AOwner is TForm) then
    raise Exception.Create('AOwner is not TForm');
  FView := AOwner as TForm;
end;

destructor TPermissionUserComponentsConfiguration.Destroy;
begin
  inherited;
end;

procedure TPermissionUserComponentsConfiguration.Load;
var
  i: Integer;
begin
  if (not FActive) or (FPermissionUser.UserLogged.UserSystem) then
    Exit;
  for i := 0 to Pred(FPermissionUserComponents.Count) do
  begin
    try
      FPermissionUser.UserLogged.Components.Filtered := False;
      FPermissionUser.UserLogged.Components.Filter := Format('%s = %s and %s = %s and %s = %s',[FPermissionUser.PermissionUserTableGroupComponents.UserFieldComponent,
                                                                                                QuotedStr(TControl(FPermissionUserComponents.Items[i].Component).Name),
                                                                                                FPermissionUser.PermissionUserTableGroupComponents.UserFieldForm,
                                                                                                QuotedStr(Self.FView.Name),
                                                                                                FPermissionUser.PermissionUserTableGroupComponents.UserFieldGroup,
                                                                                                QuotedStr(Self.FGroup)]);
      FPermissionUser.UserLogged.Components.Filtered := True;
      case Self.FNotAuthorized of
        naDisabled: TControl(FPermissionUserComponents.Items[i].Component).Enabled := not FPermissionUser.UserLogged.Components.IsEmpty;
        naInvisible: TControl(FPermissionUserComponents.Items[i].Component).Visible := not FPermissionUser.UserLogged.Components.IsEmpty;
      end;
    finally
      FPermissionUser.UserLogged.Components.Filtered := False;
    end;
  end;
end;

{ TPermissionUserTable }

constructor TPermissionUserTable.Create(AOwner: TComponent);

  procedure TableDefault;
  begin
    FUserTableName := 'permissionuser';
    FUserFieldId := 'id';
    FUserFieldName := 'name';
    FUserFieldEmail := 'email';
    FUserFieldAdmin := 'admin';
    FUserFieldLogin := 'login';
    FUserFieldPassword := 'password';
    FUserFieldActive := 'active';
    FUserFieldUserSystem := 'user_system';
    FUserFieldIdGroup := 'id_group';
  end;

begin
  FPermissionUser := AOwner as TPermissionUser;
  TableDefault;
end;

procedure TPermissionUserTable.CreateTable;

  procedure ValidadeUserDefaultExists;
  const
    SqlExistsUserDefault = 'select * from %s '+
                           'where '+
                           '  %s = %s and '+
                           '  %s = %s and '+
                           '  %s = %s ';

    function GetSQLInsertLoginDefault: string;
    const
      SqlInsertUserDefault = 'insert into %s ('+
                             '  %s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s) '+
                             'values ('+
                             '  %s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s, '+
                             '	%s); ';
    begin
      Result := Format(SqlInsertUserDefault,[FUserTableName,
                                             FUserFieldName,
                                             FUserFieldEmail,
                                             FUserFieldLogin,
                                             FUserFieldPassword,
                                             FUserFieldActive,
                                             FUserFieldAdmin,
                                             FUserFieldUserSystem,
                                             QuotedStr(FPermissionUser.UserDefaultName),
                                             QuotedStr(FPermissionUser.UserDefaultEmail),
                                             QuotedStr(FPermissionUser.UserDefaultLogin),
                                             QuotedStr(FPermissionUser.Cript(FPermissionUser.UserDefaultPassword,100)),
                                             QuotedStr('true'),
                                             QuotedStr('true'),
                                             QuotedStr('true')]);
    end;

  begin
    with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlExistsUserDefault,[FUserTableName,FUserFieldName,QuotedStr(FPermissionUser.UserDefaultName),FUserFieldLogin,QuotedStr(FUserFieldLogin),FUserFieldUserSystem,QuotedStr('true')])).qy do
      try
        Open;
        if IsEmpty then
          try
            TQueryFD.GetConn(FPermissionUser.PermissionUserConnection.Connection).ExecSQL(GetSQLInsertLoginDefault);
          except
            Exit;
          end;
      finally
        Free;
      end;
  end;

  function GetSQLTable: string;
  const
    SqlCreateTablle = 'create table %s ( '+
                      '  %s int(11) not null auto_increment, '+
                      '  %s int(11), '+
                      '  %s varchar(50) not null, '+
                      '  %s varchar(50) null, '+
                      '  %s varchar(50) null, '+
                      '  %s varchar(50) null, '+
                      '  %s varchar(5) null default ''true'', '+
                      '  %s varchar(5) null default ''false'', '+
                      '  %s varchar(5) null default ''false'', '+
                      '  primary key (%s), '+
                      '  unique index %s (%s), '+
                      '  unique index %s (%s), '+
                      '  unique index %s (%s), '+
                      '  index %s (%s) '+
                      ');';
  begin
    case FPermissionUser.PermissionUserConnection.DataBase of
      Mysql: Result := Format(SqlCreateTablle,[FUserTableName,
                                               FUserFieldId,
                                               FUserFieldIdGroup,
                                               FUserFieldName,
                                               FUserFieldEmail,
                                               FUserFieldLogin,
                                               FUserFieldPassword,
                                               FUserFieldActive,
                                               FUserFieldAdmin,
                                               FUserFieldUserSystem,
                                               FUserFieldId,
                                               FUserFieldName,
                                               FUserFieldName,
                                               FUserFieldEmail,
                                               FUserFieldEmail,
                                               FUserFieldLogin,
                                               FUserFieldLogin,
                                               FUserFieldId,
                                               FUserFieldId]);
    end;
  end;

  procedure ValidadeTableExists;
  var
    TempList: TStringList;
  begin
    TempList:= TStringList.Create;
    try
      TQueryFD.GetConn(FPermissionUser.PermissionUserConnection.Connection).GetTableNames('',FUserTableName,'',TempList);
      if Pos(TempList.Text,FPermissionUser.PermissionUserTable.FUserTableName) = 0 then
        try
          TQueryFD.GetConn(FPermissionUser.PermissionUserConnection.Connection).ExecSQL(GetSQLTable);
        except
          Exit;
        end;
    finally
      FreeAndNil(TempList);
    end;
  end;

begin
  ValidadeTableExists;
  ValidadeUserDefaultExists;
end;

destructor TPermissionUserTable.Destroy;
begin
  inherited;
end;

procedure TPermissionUserTable.Load;
begin
  CreateTable;
end;

{ TPermissionUserRegistration }

constructor TPermissionUserRegistration.Create(PermissionUser: TPermissionUser);
begin
  FPermissionUser := PermissionUser;
end;

destructor TPermissionUserRegistration.Destroy;
begin
  inherited;
end;

function TPermissionUserRegistration.LoginUser: TLoginOperation;
const
  SqlLogin = 'select '+
             '  * '+
             'from '+
             '  %s  '+
             'where '+
             '  %s = :%s and  '+
             '  %s = :%s ';

  function ValidadeLogin(User, Password: string): TLoginOperation;
  begin
    Result := loNotAuthorized;
    with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlLogin,[FPermissionUser.PermissionUserTable.UserTableName,FPermissionUser.PermissionUserTable.UserFieldLogin,FPermissionUser.PermissionUserTable.UserFieldLogin,FPermissionUser.PermissionUserTable.UserFieldPassword,FPermissionUser.PermissionUserTable.UserFieldPassword])) do
      try
        qy.Close;
        qy.ParamByName(FPermissionUser.PermissionUserTable.UserFieldLogin).AsString := User;
        qy.ParamByName(FPermissionUser.PermissionUserTable.UserFieldPassword).AsString := PermissionUser.Cript(Password,100);
        qy.Open;

        if (not qy.IsEmpty) and qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldActive).AsBoolean then
          Result := loAuthorized;

        if Result = loNotAuthorized then
        begin
          MessageDlg(FPermissionUser.MessageLoginNotAuthorized,mtWarning,[mbok],0);
          Exit;
        end;

        FId := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldId).AsInteger;
        FIdGroup := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldIdGroup).AsInteger;
        FLogin := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldLogin).AsString;
        FName := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldName).AsString;
        FEmail := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldEmail).AsString;
        FAdmin := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldAdmin).AsBoolean;
        FPassword := Password;
        FActive := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldActive).AsBoolean;
        FUserSystem := qy.FieldByName(FPermissionUser.PermissionUserTable.UserFieldUserSystem).AsBoolean;

      finally
        Free;
      end;
  end;

  function GetLogin: TLoginOperation;
  begin
    with TViewPermissionUserLogin.Create(FPermissionUser) do
      try
        ShowModal;
        Result := loCancel;
        if ModalResult = mrOk then
          Result := ValidadeLogin(edtUser.Text,edtPassword.Text);
      finally
        Free;
      end;
  end;

var
  RepeatLogin: Integer;
begin
  RepeatLogin := 0;
  repeat
    Result := GetLogin;
    Inc(RepeatLogin)
  until ((Result = loAuthorized) or (Result = loCancel) or (RepeatLogin = 5));
  if (Result = loNotAuthorized) or (Result = loCancel) then
    Application.Terminate;
end;

procedure TPermissionUserRegistration.ModifyPassword;
const
  SqlModify = 'update %s set '+
              '  %s = :%s '+
              'where '+
              '  %s = :%s ';

  procedure Modify(Password: string);
  begin
    with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,Format(SqlModify,[FPermissionUser.PermissionUserTable.UserTableName,FPermissionUser.PermissionUserTable.UserFieldPassword,FPermissionUser.PermissionUserTable.UserFieldPassword,FPermissionUser.PermissionUserTable.UserFieldId,FPermissionUser.PermissionUserTable.UserFieldId])).qy do
      try
        ParamByName(FPermissionUser.PermissionUserTable.UserFieldPassword).AsString := PermissionUser.Cript(Password,100);
        ParamByName(FPermissionUser.PermissionUserTable.UserFieldId).AsInteger := FPermissionUser.UserLogged.FId;
        ExecSQL;
      finally
        Free;
      end;
  end;

var
  PasswordModify: string;
begin
  with TViewUserPassword.Create(FPermissionUser) do
    try
      PasswordModify := GetPassword(toUpdate,FPassword);
      if PasswordModify = '' then
        Exit;
    finally
      Free;
    end;
  Modify(PasswordModify);
end;

procedure TPermissionUserRegistration.OpenViewRegistration;

  function GetSQLUserRegistration: string;
  const
    SQLUserRegistration = 'select '+
                          '  * '+
                          'from '+
                          '  %s  '+
                          'where '+
                          '  %s is not null';
  begin
    Result := Format(SQLUserRegistration,[FPermissionUser.PermissionUserTable.UserTableName,
                                          FPermissionUser.PermissionUserTable.UserFieldIdGroup])
  end;

begin
  if not FPermissionUser.UserLogged.FAdmin then
    Exit;
  with TViewUserRegistration.Create(FPermissionUser) do
    try
      PermissionUser := Self.FPermissionUser;
      SQLUserRegistration := GetSQLUserRegistration;
      ShowModal;
    finally
      Free;
    end;
end;

{ TPermissionUserComponentsItens }

function TPermissionUserComponents.Add: TPermissionUserComponentsItems;
begin
  Result := TPermissionUserComponentsItems(inherited Add);
end;

constructor TPermissionUserComponents.Create;
begin
  inherited Create(TPermissionUserComponentsItems);
end;

function TPermissionUserComponents.GetItem(Index: Integer): TPermissionUserComponentsItems;
begin
  Result := TPermissionUserComponentsItems(inherited GetItem(Index));
end;

procedure TPermissionUserComponents.SetItem(Index: Integer; Value: TPermissionUserComponentsItems);
begin
  inherited SetItem(Index, Value);
end;

{ TPermissionUserComponentsItems }

procedure TPermissionUserComponentsItems.Assign(Source: TPersistent);
begin
  inherited;
end;

function TPermissionUserComponentsItems.GetDisplayName: String;
begin
  if FComponent <> nil then
    Result := FComponent.Name;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

procedure TPermissionUserComponentsItems.SetComponent(const Value: TControl);
var
  DescriptionParam: string;
begin
  FComponent := Value;
  if Value is TBitBtn then
    DescriptionParam := TBitBtn(Value).Caption
  else if Value is TSpeedButton then
    DescriptionParam := TSpeedButton(Value).Caption;
  if FDescription = '' then
    InputQuery('TPermissionUserComponentsItems','Description',DescriptionParam);
  FDescription := DescriptionParam;
end;

{ TPermissionUserTableGroupComponents }

constructor TPermissionUserTableGroupComponents.Create(AOwner: TComponent);

  procedure TableDefault;
  begin
    FUserTableName := 'permissionuser_group_components';
    FUserFieldId := 'id';
    FUserFieldComponent := 'component';
    FUserFieldGroup := 'group';
    FUserFieldForm := 'form';
  end;

begin
  FPermissionUser := AOwner as TPermissionUser;
  TableDefault;
end;

procedure TPermissionUserTableGroupComponents.CreateTable;

  function GetSQLTable: string;
  const
    SqlCreateTablle = 'create table %s ( '+
                      '  %s int(11) not null auto_increment, '+
                      '  %s varchar(50) not null, '+
                      '  %s varchar(50) not null, '+
                      '  %s varchar(50) not null, '+
                      '  %s varchar(50) not null, '+
                      '  primary key (%s) '+
                      ');';
  begin
    case FPermissionUser.PermissionUserConnection.DataBase of
      Mysql: Result := Format(SqlCreateTablle,[FUserTableName,
                                               FUserFieldId,
                                               FUserFieldComponent,
                                               FUserFieldDescription,
                                               FUserFieldGroup,
                                               FUserFieldForm,
                                               FUserFieldId]);
    end;
  end;

  procedure ValidadeTableExists;
  var
    TempList: TStringList;
  begin
    TempList:= TStringList.Create;
    try
      TQueryFD.GetConn(FPermissionUser.PermissionUserConnection.Connection).GetTableNames('',FUserTableName,'',TempList);
      if Pos(TempList.Text,FPermissionUser.PermissionUserTableGroupComponents.FUserTableName) = 0 then
        try
          TQueryFD.GetConn(FPermissionUser.PermissionUserConnection.Connection).ExecSQL(GetSQLTable);
        except
          Exit;
        end;
    finally
      FreeAndNil(TempList);
    end;
  end;

begin
  ValidadeTableExists;
end;

destructor TPermissionUserTableGroupComponents.Destroy;
begin
  inherited;
end;

procedure TPermissionUserTableGroupComponents.InsertComponents;

  function GetSQLSelectComponent: string;
  const
    SqlSelectComponent = 'select * from %s '+
                         'where '+
                         '  %s = :%s and '+
                         '  %s = :%s  ';
  begin
    case FPermissionUser.PermissionUserConnection.DataBase of
      Mysql: Result := Format(SqlSelectComponent,[FUserTableName,
                                                  FUserFieldComponent,
                                                  FUserFieldComponent,
                                                  FUserFieldForm,
                                                  FUserFieldForm]);
    end;
  end;

  function ValidadeComponentsExists(Component,Form: string): Boolean;
  begin
    Result := False;
    with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,GetSQLSelectComponent).qy do
      try
        try
          Close;
          ParamByName(FUserFieldComponent).AsString := Component;
          ParamByName(FUserFieldForm).AsString := Form;
          Open;
          Result := IsEmpty;
        except
          Exit;
        end;
      finally
        Free;
      end;
  end;

  function GetSQLInsertComponent: string;
  const
    SqlInsertComponent = 'insert into %s '+
                         ' (%s, '+
                         '  %s, '+
                         '  %s, '+
                         '  %s) '+
                         'values '+
                         ' (:%s, '+
                         '  :%s, '+
                         '  :%s, '+
                         '  :%s)';
  begin
    case FPermissionUser.PermissionUserConnection.DataBase of
      Mysql: Result := Format(SqlInsertComponent,[FUserTableName,
                                                  FUserFieldComponent,
                                                  FUserFieldForm,
                                                  FUserFieldGroup,
                                                  FUserFieldDescription,
                                                  FUserFieldComponent,
                                                  FUserFieldForm,
                                                  FUserFieldGroup,
                                                  FUserFieldDescription
                                                  ]);
    end;
  end;

  procedure InsertComponent(Component,Description,Form,Group: string);
  begin
    with TQueryFD.Create(FPermissionUser.PermissionUserConnection.Connection,GetSQLInsertComponent).qy do
      try
        try
          Close;
          ParamByName(FUserFieldComponent).AsString := Component;
          ParamByName(FUserFieldDescription).AsString := Description;
          ParamByName(FUserFieldForm).AsString := Form;
          ParamByName(FUserFieldGroup).AsString := Group;
          ExecSQL;
        except
          on e: exception do
            raise Exception.Create(e.Message);
        end;
      finally
        Free;
      end;
  end;

var
  i: Integer;
begin
  for i := 0 to Pred(FPermissionUser.PermissionUserComponentsAll.Count) do
    if ValidadeComponentsExists(FPermissionUser.PermissionUserComponentsAll.Items[i].Component,FPermissionUser.PermissionUserComponentsAll.Items[i].View) then
      InsertComponent(FPermissionUser.PermissionUserComponentsAll.Items[i].Component,
                      FPermissionUser.PermissionUserComponentsAll.Items[i].Description,
                      FPermissionUser.PermissionUserComponentsAll.Items[i].View,
                      FPermissionUser.PermissionUserComponentsAll.Items[i].Group);
end;

procedure TPermissionUserTableGroupComponents.Load;
begin
  CreateTable;
  InsertComponents;
end;

procedure TPermissionUserTableGroupComponents.OpenViewGroup;
begin
  with TViewUserGroupPermission.Create(FPermissionUser) do
    try
      PermissionUser := Self.FPermissionUser;
      ShowModal;
    finally
      Free;
    end;
  FPermissionUser.LoadGroupPermission;
end;

{ TPermissionUserTableGroupUser }

constructor TPermissionUserTableGroupUser.Create(AOwner: TComponent);

  procedure TableDefault;
  begin
    FUserTableName := 'permissionuser_group_components_user';
    FUserFieldId := 'id';
    FUserFieldIdGroup := 'id_group';
    FUserFieldIdUser := 'id_user';
  end;

begin
  FPermissionUser := AOwner as TPermissionUser;
  TableDefault;
end;

procedure TPermissionUserTableGroupUser.CreateTable;

  function GetSQLTable: string;
  const
    SqlCreateTablle = 'create table %s ( '+
                      '	%s int(11) not null auto_increment, '+
                      '	%s int(11) null not null, '+
                      '	%s int(11) null not null, '+
                      '	primary key (%s) '+
                      '); ';
  begin
    case FPermissionUser.PermissionUserConnection.DataBase of
      Mysql: Result := Format(SqlCreateTablle,[FUserTableName,
                                               FUserFieldId,
                                               FUserFieldIdGroup,
                                               FUserFieldIdUser,
                                               FUserFieldId]);
    end;
  end;

  procedure ValidadeTableExists;
  var
    TempList: TStringList;
  begin
    TempList:= TStringList.Create;
    try
      TQueryFD.GetConn(FPermissionUser.PermissionUserConnection.Connection).GetTableNames('',FUserTableName,'',TempList);
      if Pos(TempList.Text,FPermissionUser.PermissionUserTableGroupUser.FUserTableName) = 0 then
        try
          TQueryFD.GetConn(FPermissionUser.PermissionUserConnection.Connection).ExecSQL(GetSQLTable);
        except
          Exit;
        end;
    finally
      FreeAndNil(TempList);
    end;
  end;

begin
  ValidadeTableExists;
end;

destructor TPermissionUserTableGroupUser.Destroy;
begin
  inherited;
end;

procedure TPermissionUserTableGroupUser.Load;
begin
  CreateTable;
end;

{ TPermissionUserComponentsItemsAll }

procedure TPermissionUserComponentsItemsAll.Assign(Source: TPersistent);
begin
  inherited;
end;

function TPermissionUserComponentsItemsAll.GetDisplayName: String;
begin
  if FComponent <> '' then
    Result := FView+'.'+FComponent;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

{ TPermissionUserComponentsAll }

function TPermissionUserComponentsAll.Add: TPermissionUserComponentsItemsAll;
begin
  Result := TPermissionUserComponentsItemsAll(inherited Add);
end;

constructor TPermissionUserComponentsAll.Create;
begin
  inherited Create(TPermissionUserComponentsItemsAll);
end;

function TPermissionUserComponentsAll.GetItem(Index: Integer): TPermissionUserComponentsItemsAll;
begin
  Result := TPermissionUserComponentsItemsAll(inherited GetItem(Index));
end;

procedure TPermissionUserComponentsAll.SetItem(Index: Integer; Value: TPermissionUserComponentsItemsAll);
begin
  inherited SetItem(Index, Value);
end;

end.


