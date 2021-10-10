unit RegisterComponent;

interface

procedure register;

implementation

uses
  System.Classes,
  PermissionUser;

procedure register;
begin
  RegisterComponents('Permission User',[TPermissionUser, TPermissionUserConection, TPermissionUserComponentsConfiguration]);
end;

end.
