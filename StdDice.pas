{+--------------------------------------------------------------------------+
 | Component:   TStandardDice
 | Created:     9/1/99 7:37:17 AM
 | Author:      Dana Dill
 | Description: Standard Dice Component
 | Version:  1.0
 | Modification History:  Updated for Delphi Berlin
 +--------------------------------------------------------------------------+}
unit StdDice;  { TStandardDice component. }

interface

uses
  Windows,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  StdCtrls,
  ExtCtrls;

type
  TRotateEvent = procedure(Sender: TObject; NewValue: Integer) of object;
  TStandardDice = class(TImage)
  private
    FDummyProperty: byte;  { Dummy field for hiding properties. }
    EmbeddedTimer: TTimer;
    FImageColor1: TColor;
    FImageColor2: TColor;
    FImageColor3: TColor;
    FImageColor4: TColor;
    FImageColor5: TColor;
    FImageColor6: TColor;
    FImageValue1: TBitmap;
    FImageValue2: TBitmap;
    FImageValue3: TBitmap;
    FImageValue4: TBitmap;
    FImageValue5: TBitmap;
    FImageValue6: TBitmap;
    FLocked: Boolean;
    FValue: Integer; // Actual Value of the Dice
    FOnRotate: TRotateEvent;
    function GetColorValue: TColor;
    procedure SetImageColor1(const Value: TColor);
    procedure SetImageColor2(const Value: TColor);
    procedure SetImageColor3(const Value: TColor);
    procedure SetImageColor4(const Value: TColor);
    procedure SetImageColor5(const Value: TColor);
    procedure SetImageColor6(const Value: TColor);
    procedure SetLocked(const Value: Boolean);
    procedure Timer_EmbeddedTimerHandler(Sender: TObject);  { TNotifyEvent }
  protected
    { Protected declarations }
    procedure SetImageValue1(newValue: TBitmap); virtual;
    procedure SetImageValue2(newValue: TBitmap); virtual;
    procedure SetImageValue3(newValue: TBitmap); virtual;
    procedure SetImageValue4(newValue: TBitmap); virtual;
    procedure SetImageValue5(newValue: TBitmap); virtual;
    procedure SetImageValue6(newValue: TBitmap); virtual;
    procedure SetValue(newValue: Integer); virtual;
    { Event triggers: }
    procedure TriggerRotateEvent(NewValue: Integer); virtual;
    procedure SetRotate(newValue: Boolean); virtual;
    function GetRotate: Boolean; virtual;
    procedure SetRotationSpeed(newValue: Cardinal); virtual;
    function GetRotationSpeed: Cardinal; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function JustGetRandomNum: Integer;
    property ColorValue: TColor read GetColorValue;
  published
    { Published properties and events }
    property ImageValue1: TBitmap read FImageValue1 write SetImageValue1;
    property ImageValue2: TBitmap read FImageValue2 write SetImageValue2;
    property ImageValue3: TBitmap read FImageValue3 write SetImageValue3;
    property ImageValue4: TBitmap read FImageValue4 write SetImageValue4;
    property ImageValue5: TBitmap read FImageValue5 write SetImageValue5;
    property ImageValue6: TBitmap read FImageValue6 write SetImageValue6;
    property Value: Integer read FValue write SetValue default 0;  { Published }
    property OnRotate: TRotateEvent read FOnRotate write FOnRotate;
    property Rotate: Boolean read GetRotate write SetRotate;
    property RotationSpeed: Cardinal read GetRotationSpeed write SetRotationSpeed default 50;
    { Inherited properties: }
    property Canvas;
    property Anchors: byte read FDummyProperty;  { Hidden Property }
    property ImageColor1: TColor read FImageColor1 write SetImageColor1;
    property ImageColor2: TColor read FImageColor2 write SetImageColor2;
    property ImageColor3: TColor read FImageColor3 write SetImageColor3;
    property ImageColor4: TColor read FImageColor4 write SetImageColor4;
    property ImageColor5: TColor read FImageColor5 write SetImageColor5;
    property ImageColor6: TColor read FImageColor6 write SetImageColor6;
    property IncrementalDisplay: byte read FDummyProperty;  { Hidden Property }
    property Locked: Boolean read FLocked write SetLocked;
    property Picture: byte read FDummyProperty;  { Hidden Property }
  end;  { TdpdStandardDice }

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Dice', [TStandardDice]);
end;		{ Register }


function TStandardDice.JustGetRandomNum: Integer;
var
  lRandom: Integer;
begin
  result := 1;
  lRandom := Random(6);

  case lRandom of    //
    0: result := 1;
    1: result := 2;
    2: result := 3;
    3: result := 4;
    4: result := 5;
    5: result := 6;
  end;    // case

end;

procedure TStandardDice.SetImageValue1(newValue: TBitmap);
{ Sets data member FImageValue1 to newValue. }
begin
  FImageValue1.Assign(newValue);
end;  { SetValue1 }

procedure TStandardDice.SetImageValue2(newValue: TBitmap);
{ Sets data member FImageValue2 to newValue. }
begin
  FImageValue2.Assign(newValue);
end;  { SetValue2 }

procedure TStandardDice.SetImageValue3(newValue: TBitmap);
{ Sets data member FImageValue3 to newValue. }
begin
  FImageValue3.Assign(newValue);
end;  { SetValue3 }

procedure TStandardDice.SetImageValue4(newValue: TBitmap);
{ Sets data member FImageValue4 to newValue. }
begin
  FImageValue4.Assign(newValue);
end;  { SetValue4 }

procedure TStandardDice.SetImageValue5(newValue: TBitmap);
{ Sets data member FImageValue5 to newValue. }
begin
  FImageValue5.Assign(newValue);
end;  { SetValue5 }

procedure TStandardDice.SetImageValue6(newValue: TBitmap);
{ Sets data member FImageValue6 to newValue. }
begin
  FImageValue6.Assign(newValue);
end;  { SetValue6 }

procedure TStandardDice.SetValue(newValue: Integer);  { protected }
begin
  if FValue <> newValue then
    begin
      FValue := newValue;
        case FValue of    //
          1: Canvas.Draw(0, 0, FImageValue1);
          2: Canvas.Draw(0, 0, FImageValue2);
          3: Canvas.Draw(0, 0, FImageValue3);
          4: Canvas.Draw(0, 0, FImageValue4);
          5: Canvas.Draw(0, 0, FImageValue5);
          6: Canvas.Draw(0, 0, FImageValue6);
        end;  // case
    end;
  TriggerRotateEvent(newValue);
end;  { SetValue }

{ Event triggers: }
procedure TStandardDice.TriggerRotateEvent(NewValue: Integer);
{ Triggers the OnRotate event. This is a virtual method (descendants of this component can override it). }
begin
  if assigned(FOnRotate) then
    FOnRotate(Self, NewValue);
end;  { TriggerRotateEvent }

{ Exposed properties' Read/Write methods: }
procedure TStandardDice.SetRotate(newValue: Boolean);
{ Sets the EmbeddedTimer subcomponent's Enabled property to newValue. }
begin
  EmbeddedTimer.Enabled := newValue;
end;  { SetRotate }

function TStandardDice.GetRotate: Boolean;
{ Returns the Enabled property from the EmbeddedTimer subcomponent. }
begin
  GetRotate := EmbeddedTimer.Enabled;
end;  { GetRotate }

procedure TStandardDice.SetRotationSpeed(newValue: Cardinal);
{ Sets the EmbeddedTimer subcomponent's Interval property to newValue. }
begin
  EmbeddedTimer.Interval := newValue;
end;  { SetRotationSpeed }

function TStandardDice.GetRotationSpeed: Cardinal;
{ Returns the Interval property from the EmbeddedTimer subcomponent. }
begin
  GetRotationSpeed := EmbeddedTimer.Interval;
end;  { GetRotationSpeed }

procedure TStandardDice.Timer_EmbeddedTimerHandler(Sender: TObject);
{ Handles the EmbeddedTimer OnTimer event. }
var
  CurrentValue: Integer;
  lRandom: Integer;
begin
  if Locked = False then begin

    CurrentValue := Value;
    lRandom := Random(6);

    if CurrentValue  = lRandom + 1 then
      if lRandom + 1 = 6 then
        lRandom := lRandom - 1
      else
        lRandom := lRandom + 1;

    case lRandom of    //
      0: Value := 1;
      1: Value := 2;
      2: Value := 3;
      3: Value := 4;
      4: Value := 5;
      5: Value := 6;
    end;    // case
    
  end;
end;  { Timer_EmbeddedTimerHandler }

destructor TStandardDice.Destroy;
begin
  { Free member variables: }
  FImageValue1.Free;
  FImageValue2.Free;
  FImageValue3.Free;
  FImageValue4.Free;
  FImageValue5.Free;
  FImageValue6.Free;
  inherited Destroy;
end;  { Destroy }

constructor TStandardDice.Create(AOwner: TComponent);
{ Creates an object of type TStandardDice, and initializes properties. }
begin
  inherited Create(AOwner);
  { Create member variables (that are objects): }
  EmbeddedTimer := TTimer.Create(Self);
  EmbeddedTimer.OnTimer := Timer_EmbeddedTimerHandler;
  { Make sure EmbeddedTimer has been created (make sure it's valid). }
//  EmbeddedTimer.OnTimer := Timer_EmbeddedTimerHandler;

  { Create property fields (that are objects): }
  FImageValue1 := TBitmap.Create;
  FImageValue2 := TBitmap.Create;
  FImageValue3 := TBitmap.Create;
  FImageValue4 := TBitmap.Create;
  FImageValue5 := TBitmap.Create;
  FImageValue6 := TBitmap.Create;
  { Initialize properties with default values: }
  RotationSpeed := 100;
  FValue := 0;
  Height := 64;
  Width := 64;
  Stretch := True;
  Rotate := False;
  Locked := False;
end;  { Create }

function TStandardDice.GetColorValue: TColor;
begin
  // TODO -cMM: TStandardDice.GetColorValue default body inserted
  Result := clNone;

  case FValue of
    1: Result := FImageColor1;
    2: Result := FImageColor2;
    3: Result := FImageColor3;
    4: Result := FImageColor4;
    5: Result := FImageColor5;
    6: Result := FImageColor6;
  end;
end;

procedure TStandardDice.SetImageColor1(const Value: TColor);
begin
  FImageColor1 := Value;
end;

procedure TStandardDice.SetImageColor2(const Value: TColor);
begin
  FImageColor2 := Value;
end;

procedure TStandardDice.SetImageColor3(const Value: TColor);
begin
  FImageColor3 := Value;
end;

procedure TStandardDice.SetImageColor4(const Value: TColor);
begin
  FImageColor4 := Value;
end;

procedure TStandardDice.SetImageColor5(const Value: TColor);
begin
  FImageColor5 := Value;
end;

procedure TStandardDice.SetImageColor6(const Value: TColor);
begin
  FImageColor6 := Value;
end;

procedure TStandardDice.SetLocked(const Value: Boolean);
begin
  FLocked := Value;
end;

initialization
  Randomize;
end.



