unit View.User.Password;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons;

type
  TOperation = (toNew, toUpdate);
  TViewUserPassword = class(TForm)
    lblPassword1: TLabel;
    btnGravar: TBitBtn;
    edtPassword1: TEdit;
    lblPassword2: TLabel;
    edtPassword2: TEdit;
    lblPassword3: TLabel;
    edtPassword3: TEdit;
  public
    class function GetPassword(Operation: TOperation; PasswordCurrent: string = ''): string;
  end;

implementation

{$R *.dfm}

{ TViewUserPassword }

class function TViewUserPassword.GetPassword(Operation: TOperation; PasswordCurrent: string): string;
var
  Answer: Boolean;
begin
  with Self.Create(nil) do
  try
    case Operation of
      toNew:
      begin
        lblPassword1.Caption := 'Digite a Senha';
        lblPassword2.Caption := 'Confirme a Senha Digitada';
        lblPassword3.Visible := False;
        edtPassword3.Visible := False;
        Height := 179;
      end;
      toUpdate:
      begin
        lblPassword1.Caption := 'Digite a Senha Atual';
        lblPassword2.Caption := 'Nova Senha';
        lblPassword3.Caption := 'Confirme a Nova Senha Digitada';
        Height := 227;
      end;
    end;
    Answer := False;
    repeat
      ShowModal;
      case Operation of
        toNew:
        begin
          Result := edtPassword1.Text;
          Answer := (edtPassword1.Text = edtPassword2.Text) and (edtPassword1.Text <> '') and (edtPassword2.Text <> '');
          if not Answer then
            MessageDlg('Senha de Confirmação não Confere.',mtWarning,[mbok],0);
        end;
        toUpdate:
        begin
          Result := edtPassword2.Text;
          Answer := (edtPassword1.Text = PasswordCurrent) and (edtPassword2.Text = edtPassword3.Text) and (edtPassword1.Text <> '') and (edtPassword2.Text <> '') and (edtPassword3.Text <> '');
          if not Answer then
            MessageDlg('Senha Alterada não Confere.',mtWarning,[mbok],0);
        end;
      end;
    until (Answer);
  finally
    Free;
  end;
end;

end.
