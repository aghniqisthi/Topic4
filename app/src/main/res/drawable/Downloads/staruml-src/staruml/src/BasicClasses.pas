unit BasicClasses;

{******************************************************************************}
{                                                                              }
{                StarUML - The Open Source UML/MDA Platform.                   }
{                                                                              }
{              Copyright (C) 2002-2005 - Plastic Software, Inc.                }
{                                                                              }
{                                                                              }
{ This program is free software; you can redistribute it and/or modify it      }
{ under the terms of the GNU General Public License as published by the Free   }
{ Software Foundation; either version 2 of the License, or (at your option)    }
{ any later version.                                                           }
{                                                                              }
{ This program is distributed in the hope that it will be useful, but WITHOUT  }
{ ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        }
{ FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for     }
{ more details.                                                                }
{                                                                              }
{ You should have received a copy of the GNU General Public License along with }
{ this program; if not, write to the Free Software Foundation, Inc., 51        }
{ Franklin St, Fifth Floor, Boston, MA 02110-1301 USA                          }
{                                                                              }
{ Linking StarUML statically or dynamically with other modules is making a     }
{ combined work based on StarUML. Thus, the terms and conditions of the GNU    }
{ General Public License cover the whole combination.                          }
{                                                                              }
{ In addition, as a special exception, Plastic Software give you permission to }
{ combine StarUML program with free software programs or libraries that are    }
{ released under the GNU LGPL/Mozilla/Apache/BSD and with code included in the }
{ standard release of ExpressBar, ExpressNavBar, ExpressInspector,             }
{ ExpressPageControl, ProGrammar, NextGrid under the commercial license (or    }
{ modified versions of such code, with unchanged license). You may copy and    }
{ distribute such a system following the terms of the GNU GPL for StarUML and  }
{ the licenses of the other code concerned, provided that you include the      }
{ source code of that other code when and as the GNU GPL requires distribution }
{ of source code. Plastic Software also give you permission to combine StarUML }
{ program with dynamically linking plug-in (or add-in) programs that are       }
{ released under the GPL-incompatible and proprietary license.                 }
{                                                                              }
{ Note that people who make modified versions of StarUML are not obligated to  }
{ grant this special exception for their modified versions; it is their choice }
{ whether to do so. The GNU General Public License gives permission to release }
{ a modified version without this exception; this exception also makes it      }
{ possible to release a modified version which carries forward this exception. }
{******************************************************************************}

interface

uses
  Types, Classes, SysUtils, IniFiles, ComObj;

type
  // Forward Declarations
  PAutoObject = class;
  POrderedSet = class;
  PObjectWriter = class;
  PObjectReader = class;
  PCommand = class;

  // Enumerations
  PCommandPos = (cpReexecuteStack, cpUnexecuteStack);

  // Event Types
  PCommandEvent = procedure(Sender: TObject; Command: PCommand) of object;

  // Exceptions
  EColumnNotExist = class(Exception);

  // PObjectClass
  PClass = class of PObject;
  PAutoClass = class of PAutoObject;

  // PObject
  PObject = class
  private
    FGUID: string;
    FData: Pointer;
    FAutoObject: PAutoObject;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Store(Writer: PObjectWriter); virtual;
    procedure Load(Reader: PObjectReader); virtual;
    function GetAutomationObject: PAutoObject; virtual;
    property GUID: string read FGUID write FGUID;
    property Data: Pointer read FData write FData;
  end;

  // PAutoObject
  // ---------------------------------------------------------------------------
  // PObject?? ???? Automation Object?? ?????????? ?? ???????????? ???? ???? ??.
  // if you want to implement Automation Object for PObject, Inherit from this class 
  // ---------------------------------------------------------------------------
  PAutoObject = class(TAutoIntfObject)
  protected
    TheObject: PObject;
  end;

  // POrderedSet
  POrderedSet = class
  private
    FList: TList;
    function GetItem(Index: Integer): PObject;
    procedure SetItem(Index: Integer; Value: PObject);
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(OrderedSet: POrderedSet);
    procedure Add(Obj: PObject);
    procedure Remove(Obj: PObject);
    procedure Delete(Index: Integer);
    procedure Insert(Index: Integer; Obj: PObject);
    procedure Clear;
    procedure Sort(Compare: TListSortCompare);
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Union(ASet: POrderedSet);
    procedure Subtract(ASet: POrderedSet);
    function IndexOf(Obj: PObject): Integer;
    function Contains(Obj: PObject): Boolean;
    function IsEmpty: Boolean;
    function FindByGuid(AGuid: string): PObject;
    property Items[Index: Integer]: PObject read GetItem write SetItem;
    property Count: Integer read GetCount;
  end;

  // PStack
  PStack = class
  private
    FStackList: TList;
    FCapacity: Integer;
    function GetCount: Integer;
    procedure SetCapacity(Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Push(Obj: PObject);
    function Pop: PObject;
    function Top: PObject;
    function PopBottom: PObject;
    function IsEmpty: Boolean;
    function IsFull: Boolean;
    property Count: Integer read GetCount;
    property Capacity: Integer read FCapacity write SetCapacity;
  end;

  // PTableRow
  PTableRow = class
  private
    Values: array of string;
    Objects: array of TObject;
  public
    constructor Create(Size: Integer);
    destructor Destroy; override;
  end;

  // PTable
  PTable = class
  private
    FColumns: array of string;
    FRows: TList;
    function GetRowCount: Integer;
    function GetColumn(Index: Integer): string;
    function GetColumnCount: Integer;
    function GetValue(Row: Integer; Column: Integer): string;
    procedure SetValue(Row: Integer; Column: Integer; Value: string);
    function GetObject(Row: Integer; Column: Integer): TObject;
    procedure SetObject(Row: Integer; Column: Integer; Value: TObject);
  public
    constructor Create(ColumnArray: array of string);
    destructor Destroy; override;
    procedure Clear;
    function ContainsColumn(Column: string): Boolean;
    function IndexOfColumn(Column: string): Integer;
    function AddRow(ValueArray: array of string): Integer; overload;
    function AddRow(ValueArray: array of string; ObjectArray: array of TObject): Integer; overload;
    procedure DeleteRow(Row: Integer);
    procedure SortByColumn(Column: string; TreatValueAsInteger: Boolean = False);
    function GetValueAt(Row: Integer; Column: string): string;
    function GetObjectAt(Row: Integer; Column: string): TObject;
    procedure PutValueAt(Row: Integer; Column: string; AValue: string);
    procedure PutObjectAt(Row: Integer; Column: string; AObject: TObject);
    property RowCount: Integer read GetRowCount;
    property Columns[Index: Integer]: string read GetColumn;
    property ColumnCount: Integer read GetColumnCount;
    property Values[Row: Integer; Column: Integer]: string read GetValue write SetValue;
    property Objects[Row: Integer; Column: Integer]: TObject read GetObject write SetObject;
  end;

  // PReferenceTable
  PReferenceTable = class
  private
    ObjectList: THashedStringList;
    function GetItem(Index: Integer): PObject;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(Key: string);
    procedure Put(Key: string; Value: PObject);
    function Get(Key: string): PObject;
    property Items[Index: Integer]: PObject read GetItem;
    property Count: Integer read GetCount;
  end;

  // PObjectReader
  PObjectReader = class
  public
    function ReadInteger(Key: string; Default: Integer = 0): Integer; virtual; abstract;
    function ReadBoolean(Key: string; Default: Boolean = False): Boolean; virtual; abstract;
    function ReadReal(Key: string; Default: Real = 0.0): Real; virtual; abstract;
    function ReadString(Key: string; Default: string = ''): string; virtual; abstract;
    function ReadObject(Key: string; Default: PObject = nil): PObject; virtual; abstract;
    function ReadReference(Key: string; Default: PObject = nil): PObject; virtual; abstract;
    function ReadUserDefinedType(TypeName, Key: string; Default: string = ''): string; virtual; abstract;
  end;

  // PObjectWriter
  PObjectWriter = class
  public
    procedure WriteInteger(Key: string; Value: Integer; Default: Integer = 0); virtual; abstract;
    procedure WriteBoolean(Key: string; Value: Boolean; Default: Boolean = False); virtual; abstract;
    procedure WriteReal(Key: string; Value: Real; Default: Real = 0.0); virtual; abstract;
    procedure WriteString(Key: string; Value: string; Default: string = ''); virtual; abstract;
    procedure WriteObject(Key: string; Value: PObject; Default: PObject = nil); virtual; abstract;
    procedure WriteReference(Key: string; Value: PObject; Default: PObject = nil); virtual; abstract;
    procedure WriteUserDefinedType(TypeName, Key, Value: string; Default: string = ''); virtual; abstract;
  end;

  // PCommand
  PCommand = class(PObject)
  private
    FName: string;
  protected
    FErrorMessage: string;
    FCommandPos: PCommandPos;
    function Precondition: Boolean; virtual;
    procedure Preprocess; virtual;
    procedure SetCommandPos(Value: PCommandPos); virtual;
  public
    constructor Create; override;
    procedure Execute; virtual;
    procedure Reexecute; virtual; abstract;
    procedure Unexecute; virtual; abstract;
    property CommandPos: PCommandPos read FCommandPos write SetCommandPos;
    property Name: string read FName write FName;
    property ErrorMessage: string read FErrorMessage;
  end;

  // PGroupCommand
  PGroupCommand = class(PCommand)
  private
    CommandSet: POrderedSet;
  protected
    procedure SetCommandPos(Value: PCommandPos); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Reexecute; override;
    procedure Unexecute; override;
    procedure AddCommand(ACommand: PCommand);
  end;

  // PEngine
  PEngine = class
  private
    // TEST
    GroupCommand: PGroupCommand;
    GroupingMode: Boolean;
    // TEST


    FUnexecuteStack, FReexecuteStack: PStack;
    FCapacity: Integer;
    FErrorMessage: string;
    FOnCommandExecuted: PCommandEvent;
    FOnCommandUnexecuted: PCommandEvent;
    function GetToUnexecuteCommand: PCommand;
    function GetToReexecuteCommand: PCommand;
    function GetUnexecuteCommandCount: Integer;
    function GetReexecuteCommandCount: Integer;
    procedure SetCapacity(Value: Integer);
    procedure Empty(AStack: PStack);
    procedure PushOut(AStack: PStack; ACmd: PCommand);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    // TEST
    procedure BeginGrouping;
    procedure EndGrouping;
    function IsGroupingMode: Boolean;
    // TEST

    function Execute(ACmd: PCommand): Boolean;
    procedure Unexecute;
    procedure Reexecute;
    function CanUnexecute: Boolean;
    function CanReexecute: Boolean;

    // TEST
    function ToUnexecuteIsGroup: Boolean;
    function ToReexecuteIsGroup: Boolean;
    // TEST

    property ToUnexecuteCommand: PCommand read GetToUnexecuteCommand;
    property ToReexecuteCommand: PCommand read GetToReexecuteCommand;
    property UnexecuteCommandCount: Integer read GetUnexecuteCommandCount;
    property ReexecuteCommandCount: Integer read GetReexecuteCommandCount;
    property Capacity: Integer read FCapacity write SetCapacity;
    property ErrorMessage: string read FErrorMessage;
    property OnCommandExecuted: PCommandEvent read FOnCommandExecuted write FOnCommandExecuted;
    property OnCommandUnexecuted: PCommandEvent read FOnCommandUnexecuted write FOnCommandUnexecuted;
  end;

  // PClassRegistryEntry
  PClassRegistryEntry = class
  private
    FClassRef: PClass;
    FAutoClassRef: PAutoClass;
    FDispatchID: TGUID;
  public
    constructor Create(AClass: PClass); overload;
    constructor Create(AClass: PClass; AAutoClass: PAutoClass; ADispID: TGUID); overload;
    property ClassRef: PClass read FClassRef;
    property AutoClassRef: PAutoClass read FAutoClassRef;
    property DispatchID: TGUID read FDispatchID;
  end;

  // PClassRegistry
  PClassRegistry = class
  private
    FEntryList: THashedStringList;
    function GetEntry(Index: Integer): PClassRegistryEntry;
    function GetEntryCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterClass(AClass: PClass);
    procedure RegisterAutomationClass(AClass: PClass; AAutoClass: PAutoClass; ADispID: TGUID);
    function FindEntry(AClass: PClass): PClassRegistryEntry; overload;
    function FindEntry(AClassName: string): PClassRegistryEntry; overload;
    property Entries[Index: Integer]: PClassRegistryEntry read GetEntry;
    property EntryCount: Integer read GetEntryCount;
  end;

  function CreateGUIDBase64: string;

var
  ClassRegistry: PClassRegistry;

implementation

uses
  StrUtils, Variants, Forms, ComServ;

////////////////////////////////////////////////////////////////////////////////
// Utility Functions

function CreateGUIDBase64: string;
var
  AGuid: TGUID;
  Buf: array[0..17] of Char;
  BufStr: string;
  I: Integer;

  function Encode3To4(Byte1, Byte2, Byte3: Byte): string;
  const
    Base64Chars: array[0..63] of Char =
      ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R',
       'S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j',
       'k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1',
       '2','3','4','5','6','7','8','9','+','/');
  var
    Val: Longword;
    Buf4: array[0..3] of Char;
  begin
    Val := (Byte1*65536)+(Byte2*256)+Byte3;
    Buf4[3] := Base64Chars[Val mod 64]; Val := Val div 64;
    Buf4[2] := Base64Chars[Val mod 64]; Val := Val div 64;
    Buf4[1] := Base64Chars[Val mod 64]; Val := Val div 64;
    Buf4[0] := Base64Chars[Val mod 64];
    Result := Buf4;
  end;

begin
  CreateGuid(AGuid);
  FillChar(Buf, 18, 0);
  Move(AGuid, Buf, 16);
  BufStr := '';
  for I := 0 to 5 do
    BufStr := BufStr + Encode3To4(Ord(Buf[I*3]), Ord(Buf[I*3+1]), Ord(Buf[I*3+2]));
  Result := BufStr;
end;

// Utility Functions
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PObject

constructor PObject.Create;
begin
  inherited;
  FData := nil;
  FGUID := CreateGUIDBase64;
  FAutoObject := nil;
end;

destructor PObject.Destroy;
begin
  if FAutoObject <> nil then
    FAutoObject._Release;
  FAutoObject := nil;
  inherited;
end;

procedure PObject.Store(Writer: PObjectWriter);
begin
  // Blank implementation.
end;

procedure PObject.Load(Reader: PObjectReader);
begin
  // Blank implementation.
end;

function PObject.GetAutomationObject: PAutoObject;
var
  AEntry: PClassRegistryEntry;
begin
  if FAutoObject = nil then
  begin
    AEntry := ClassRegistry.FindEntry(ClassName);
    if (AEntry <> nil) and (AEntry.AutoClassRef <> nil) then
    begin
      FAutoObject := AEntry.AutoClassRef.Create(ComServer.TypeLib, AEntry.DispatchID);
      FAutoObject.TheObject := Self;
      FAutoObject._AddRef;
    end;
  end;
  Result := FAutoObject;
end;


// PObject
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// POrderedSet

constructor POrderedSet.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor POrderedSet.Destroy;
begin
  FList.Free;
  FList := nil;
  inherited;
end;

procedure POrderedSet.Assign(OrderedSet: POrderedSet);
begin
  FList.Assign(OrderedSet.FList);
end;

function POrderedSet.GetItem(Index: Integer): PObject;
var
  C: Integer;
begin
  Result := nil;
  C := FList.Count;
  if (Index < 0) or (Index >= C) then Exit;
  Result := PObject(FList.Items[Index]);
end;

procedure POrderedSet.SetItem(Index: Integer; Value: PObject);
var
  C: Integer;
begin
  C := FList.Count;
  if (Index < 0) or (Index >= C) then Exit;
  if not (Contains(Value)) then
    FList.Items[Index] := Value;
end;

function POrderedSet.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure POrderedSet.Add(Obj: PObject);
begin
  if (Obj <> nil) and (not Contains(Obj)) then
   FList.Add(Obj);
end;

procedure POrderedSet.Remove(Obj: PObject);
begin
  if Obj <> nil then FList.Remove(Obj);
end;

procedure POrderedSet.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

procedure POrderedSet.Insert(Index: Integer; Obj: PObject);
begin
  if (Obj <> nil) and (not Contains(Obj)) then
    FList.Insert(Index, Obj);
end;

procedure POrderedSet.Clear;
begin
  FList.Clear;
end;

procedure POrderedSet.Sort(Compare: TListSortCompare);
begin
  FList.Sort(Compare);
end;

procedure POrderedSet.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure POrderedSet.Union(ASet: POrderedSet);
var
  I: Integer;
begin
  for I := 0 to ASet.Count - 1 do
    if not Contains(ASet.Items[I]) then Add(ASet.Items[I]);
end;

procedure POrderedSet.Subtract(ASet: POrderedSet);
var
  I: Integer;
begin
  for I := 0 to ASet.Count - 1 do
    if Contains(ASet.Items[I]) then Remove(ASet.Items[I]);
end;

function POrderedSet.IndexOf(Obj: PObject): Integer;
begin
  Result := FList.IndexOf(Obj);
end;

function POrderedSet.Contains(Obj: PObject): Boolean;
begin
  Result := (FList.IndexOf(Obj) > -1);
end;

function POrderedSet.IsEmpty: Boolean;
begin
  Result := (FList.Count = 0);
end;

function POrderedSet.FindByGuid(AGuid: string): PObject;
var
  I: Integer;
  O: PObject;
begin
  for I := 0 to FList.Count - 1 do
  begin
    O := FList.Items[I];
    if O.GUID = AGuid then
    begin
      Result := O;
      Exit;
    end;
  end;
  Result := nil;
end;

// POrderedSet
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PStack

constructor PStack.Create;
begin
  inherited;
  FCapacity := 100;
  FStackList := TList.Create;
end;

destructor PStack.Destroy;
begin
  FStackList.Free;
  inherited;
end;

function PStack.GetCount: Integer;
begin
  Result := FStackList.Count;
end;

procedure PStack.SetCapacity(Value: Integer);
var
  I, C: Integer;
begin
  FCapacity := Value;
  C := FStackList.Count - FCapacity;
  if C > 0 then
    for I := C - 1 downto 0 do FStackList.Delete(I);
end;

procedure PStack.Clear;
begin
  FStackList.Clear;
end;

procedure PStack.Push(Obj: PObject);
begin
  if FStackList.Count >= FCapacity then FStackList.Delete(0);
  FStackList.Add(Obj);
end;

function PStack.Pop: PObject;
var
  Obj: PObject;
begin
  if not IsEmpty then begin
    Obj := FStackList.Items[FStackList.Count - 1];
    Result := Obj;
    FStackList.Delete(FStackList.Count - 1);
  end
  else Result := nil;
end;

function PStack.Top: PObject;
begin
  Result := FStackList.Items[FStackList.Count - 1];
end;

function PStack.PopBottom: PObject;
begin
  if FStackList.Count > 0 then begin
    Result := FStackList.Items[0];
    FStackList.Delete(0);
  end
  else
    Result := nil;
end;

function PStack.IsEmpty: Boolean;
begin
  Result := FStackList.Count <= 0;
end;

function PStack.IsFull: Boolean;
begin
  Result := (FStackList.Count >= FCapacity);
end;

// PStack
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PTableRow

constructor PTableRow.Create(Size: Integer);
begin
  SetLength(Values, Size);
  SetLength(Objects, Size);
end;

destructor PTableRow.Destroy;
begin
  Values := nil;
  Objects := nil;
  inherited;
end;

// PTableRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PTable

constructor PTable.Create(ColumnArray: array of string);
var
  I: Integer;
begin
  SetLength(FColumns, Length(ColumnArray));
  for I := 0 to High(ColumnArray) do
    FColumns[I] := ColumnArray[I];
  FRows := TList.Create;
end;

destructor PTable.Destroy;
begin
  SetLength(FColumns, 0);
  Clear;
  FRows.Free;
  inherited;
end;

procedure PTable.Clear;
var
  I: Integer;
  R: PTableRow;
begin
  for I := FRows.Count - 1 downto 0 do
  begin
    R := FRows.Items[I];
    if R <> nil then R.Free;
  end;
  FRows.Clear;
end;

function PTable.GetRowCount: Integer;
begin
  Result := FRows.Count;
end;

function PTable.GetColumn(Index: Integer): string;
begin
  Result := FColumns[Index];
end;

function PTable.GetColumnCount: Integer;
begin
  Result := Length(FColumns);
end;

function PTable.GetValue(Row: Integer; Column: Integer): string;
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  Result := R.Values[Column];
end;

procedure PTable.SetValue(Row: Integer; Column: Integer; Value: string);
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  R.Values[Column] := Value;
end;

function PTable.GetObject(Row: Integer; Column: Integer): TObject;
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  Result := R.Objects[Column]
end;

procedure PTable.SetObject(Row: Integer; Column: Integer; Value: TObject);
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  R.Objects[Column] := Value;
end;

function PTable.ContainsColumn(Column: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to High(FColumns) do
    if FColumns[I] = Column then
    begin
      Result := True;
      Exit;
    end;
end;

function PTable.IndexOfColumn(Column: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(FColumns) do
    if FColumns[I] = Column then
    begin
      Result := I;
      Exit;
    end;
end;

function PTable.AddRow(ValueArray: array of string): Integer;
var
  R: PTableRow;
  I: Integer;
begin
  R := PTableRow.Create(Length(FColumns));
  for I := 0 to High(FColumns) do
  begin
    R.Values[I] := ValueArray[I];
    R.Objects[I] := nil;
  end;
  Result := FRows.Add(R);
end;

function PTable.AddRow(ValueArray: array of string; ObjectArray: array of TObject): Integer;
var
  R: PTableRow;
  I: Integer;
begin
  R := PTableRow.Create(Length(FColumns));
  for I := 0 to High(FColumns) do
  begin
    R.Values[I] := ValueArray[I];
    R.Objects[I] := ObjectArray[I];
  end;
  Result := FRows.Add(R);
end;

procedure PTable.DeleteRow(Row: Integer);
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  FRows.Delete(Row);
  if R <> nil then R.Free;
end;

var
  CompareColumn: Integer;
  CompareAsInteger: Boolean;

function CompareRowByColumn(Item1, Item2: Pointer): Integer;
var
  R1, R2: PTableRow;
  Val1, Val2: string;
  Int1, Int2: Integer;
begin
  R1 := Item1; R2 := Item2;
  Val1 := R1.Values[CompareColumn];
  Val2 := R2.Values[CompareColumn];
  if CompareAsInteger then
  begin
    Int1 := StrToInt(Val1);
    Int2 := StrToInt(Val2);
    if Int1 < Int2 then
      Result := -1
    else if Int1 > Int2 then
      Result := 1
    else
      Result := 0;
  end
  else
    Result := CompareStr(Val1, Val2);
end;

procedure PTable.SortByColumn(Column: string; TreatValueAsInteger: Boolean = False);
begin
  if not ContainsColumn(Column) then
    EColumnNotExist.Create(Column);
  CompareColumn := IndexOfColumn(Column);
  CompareAsInteger := TreatValueAsInteger;
  FRows.Sort(CompareRowByColumn);
end;

function PTable.GetValueAt(Row: Integer; Column: string): string;
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  Result := R.Values[IndexOfColumn(Column)];
end;

function PTable.GetObjectAt(Row: Integer; Column: string): TObject;
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  Result := R.Objects[IndexOfColumn(Column)];
end;

procedure PTable.PutValueAt(Row: Integer; Column: string; AValue: string);
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  R.Values[IndexOfColumn(Column)] := AValue;
end;

procedure PTable.PutObjectAt(Row: Integer; Column: string; AObject: TObject);
var
  R: PTableRow;
begin
  R := FRows.Items[Row];
  R.Objects[IndexOfColumn(Column)] := AObject;
end;

// PTable
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PReferenceTable

constructor PReferenceTable.Create;
begin
  ObjectList := THashedStringList.Create;
  ObjectList.CaseSensitive := True;
end;

destructor PReferenceTable.Destroy;
begin
  ObjectList.Free;
  ObjectList := nil;
  inherited;
end;

function PReferenceTable.GetItem(Index: Integer): PObject;
begin
  Result := ObjectList.Objects[Index] as PObject;
end;

function PReferenceTable.GetCount: Integer;
begin
  Result := ObjectList.Count;
end;

procedure PReferenceTable.Clear;
begin
  ObjectList.Clear;
end;

procedure PReferenceTable.Delete(Key: string);
var
  I: Integer;
begin
  I := ObjectList.IndexOf(Key);
  if I > -1 then ObjectList.Delete(I);
end;

procedure PReferenceTable.Put(Key: string; Value: PObject);
var
  I: Integer;
begin
  I := ObjectList.IndexOf(Key);
  if I < 0 then ObjectList.AddObject(Key, Value);
end;

function PReferenceTable.Get(Key: string): PObject;
var
  I: Integer;
begin
  I := ObjectList.IndexOf(Key);
  if I < 0 then Result := nil
           else Result := ObjectList.Objects[I] as PObject;
end;

// PReferenceTable
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PCommand

constructor PCommand.Create;
begin
  inherited;
end;

function PCommand.Precondition: Boolean;
begin
  Result := True;
end;

procedure PCommand.Preprocess;
begin
  // Blank implementation.
end;

procedure PCommand.SetCommandPos(Value: PCommandPos);
begin
  FCommandPos := Value;
end;

procedure PCommand.Execute;
begin
  Preprocess;
  Reexecute;
end;

// PCommand
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PGroupCommand

constructor PGroupCommand.Create;
begin
  inherited;
  CommandSet := POrderedSet.Create;
end;

destructor PGroupCommand.Destroy;
var
  I: Integer;
  C: PCommand;
begin
  for I := CommandSet.Count - 1 downto 0 do
  begin
    C := CommandSet.Items[I] as PCommand;
    C.Free;
  end;
  CommandSet.Free;
  inherited;
end;

procedure PGroupCommand.SetCommandPos(Value: PCommandPos);
var
  I: Integer;
  C: PCommand;
begin
  inherited;
  for I := 0 to CommandSet.Count - 1 do
  begin
    C := CommandSet.Items[I] as PCommand;
    C.CommandPos := Value;
  end;
end;

procedure PGroupCommand.Execute;
begin
  // Nothing to do.
end;

procedure PGroupCommand.Reexecute;
var
  I: Integer;
  C: PCommand;
begin
  for I := 0 to CommandSet.Count - 1 do
  begin
    C := CommandSet.Items[I] as PCommand;
    C.Reexecute;
  end;
end;

procedure PGroupCommand.Unexecute;
var
  I: Integer;
  C: PCommand;
begin
  for I := CommandSet.Count - 1 downto 0 do
  begin
    C := CommandSet.Items[I] as PCommand;
    C.Unexecute;
  end;
end;

procedure PGroupCommand.AddCommand(ACommand: PCommand);
begin
  CommandSet.Add(ACommand);
end;

// PGroupCommand
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PEngine

constructor PEngine.Create;
begin
  FCapacity := 100;
  FUnexecuteStack := PStack.Create;
  FReexecuteStack := PStack.Create;

  // TEST
  GroupCommand := nil;
  GroupingMode := False;
  // TEST

end;

destructor PEngine.Destroy;
begin
  Clear;
  FUnexecuteStack.Free;
  FReexecuteStack.Free;
  FUnexecuteStack := nil;
  FReexecuteStack := nil;
  inherited;
end;

procedure PEngine.Empty(AStack: PStack);
var
  Cmd: PCommand;
begin
  while not AStack.IsEmpty do begin
    Cmd := AStack.Pop as PCommand;
    Cmd.Free;
  end;
  AStack.Clear;
end;

procedure PEngine.PushOut(AStack: PStack; ACmd: PCommand);
var
  Cmd: PCommand;
begin
  if AStack.IsFull then begin
    Cmd := AStack.PopBottom as PCommand;
    Cmd.Free;
  end;
  AStack.Push(ACmd);
end;

function PEngine.Execute(ACmd: PCommand): Boolean;
begin
{
  -- ORIGINAL IMPLEMENTATION ---------------------------------------------------
  FErrorMessage := '';
  Result := True;
  if not ACmd.Precondition then begin
    FErrorMessage := ACmd.ErrorMessage;
    ACmd.Free;
    Result := False;
    Exit;
  end;
  ACmd.CommandPos := cpUnexecuteStack;
  ACmd.Execute;
  Empty(FReexecuteStack);
  PushOut(FUnexecuteStack, ACmd);
  if Assigned(FOnCommandExecuted) then FOnCommandExecuted(Self, ACmd);
  -- ORIGINAL IMPLEMENTATION ---------------------------------------------------
}

  FErrorMessage := '';
  Result := True;
  if not ACmd.Precondition then begin
    FErrorMessage := ACmd.ErrorMessage;
    ACmd.Free;
    Result := False;
    Exit;
  end;
  ACmd.CommandPos := cpUnexecuteStack;
  ACmd.Execute;

  // modified
  if GroupingMode then
  begin
    GroupCommand.AddCommand(ACmd);
  end
  else begin
    Empty(FReexecuteStack);
    PushOut(FUnexecuteStack, ACmd);
  end;
  // modified

  if Assigned(FOnCommandExecuted) then FOnCommandExecuted(Self, ACmd);
end;

procedure PEngine.Clear;
begin
  Empty(FUnexecuteStack);
  Empty(FReexecuteStack);
end;


// TEST ------------------------------------------------------------------------
procedure PEngine.BeginGrouping;
begin
  GroupingMode := True;
  GroupCommand := PGroupCommand.Create;
end;

procedure PEngine.EndGrouping;
begin
  GroupingMode := False;
  Execute(GroupCommand);
end;

function PEngine.IsGroupingMode: Boolean;
begin
  Result := GroupingMode;
end;
// TEST ------------------------------------------------------------------------




function PEngine.CanUnexecute: Boolean;
begin
{
  -- ORIGINAL IMPLEMENTATION ---------------------------------------------------
  Result := not FUnexecuteStack.IsEmpty;
  -- ORIGINAL IMPLEMENTATION ---------------------------------------------------
}
  if GroupingMode then
    Result := False
  else
    Result := not FUnexecuteStack.IsEmpty;
end;

function PEngine.CanReexecute: Boolean;
begin
  Result := not FReexecuteStack.IsEmpty;
end;

// TEST ------------------------------------------------------------------------
function PEngine.ToUnexecuteIsGroup: Boolean;
begin
  Result := ToUnexecuteCommand is PGroupCommand;
end;

function PEngine.ToReexecuteIsGroup: Boolean;
begin
  Result := ToReexecuteCommand is PGroupCommand;
end;
// TEST ------------------------------------------------------------------------

procedure PEngine.Unexecute;
var
  ACmd: PCommand;
begin
  if CanUnexecute then begin
    ACmd := PCommand(FUnexecuteStack.Pop);
    ACmd.CommandPos := cpReexecuteStack;
    PushOut(FReexecuteStack, ACmd);
    ACmd.Unexecute;
    if Assigned(FOnCommandUnexecuted) then FOnCommandUnexecuted(Self, ACmd);
  end;
end;

procedure PEngine.Reexecute;
var
  ACmd: PCommand;
begin
  if CanReexecute then begin
    ACmd := PCommand(FReexecuteStack.Pop);
    ACmd.CommandPos := cpUnexecuteStack;
    PushOut(FUnexecuteStack, ACmd);
    ACmd.Reexecute;
    if Assigned(FOnCommandExecuted) then FOnCommandExecuted(Self, ACmd);
  end;
end;

function PEngine.GetToUnexecuteCommand: PCommand;
begin
  if FUnexecuteStack.IsEmpty then
    Result := nil
  else
    Result := FUnexecuteStack.Top as PCommand;
end;

function PEngine.GetToReexecuteCommand: PCommand;
begin
  if FReexecuteStack.IsEmpty then
    Result := nil
  else
    Result := FReexecuteStack.Top as PCommand;
end;

function PEngine.GetUnexecuteCommandCount: Integer;
begin
  Result := FUnexecuteStack.Count;
end;

function PEngine.GetReexecuteCommandCount: Integer;
begin
  Result := FReexecuteStack.Count;
end;

procedure PEngine.SetCapacity(Value: Integer);
begin
  FCapacity := Value;
  FUnexecuteStack.Capacity := Value;
  FReexecuteStack.Capacity := Value;
end;

// PEngine
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PClassRegistryEntry

constructor PClassRegistryEntry.Create(AClass: PClass);
begin
  FClassRef := AClass;
  FAutoClassRef := nil;
end;

constructor PClassRegistryEntry.Create(AClass: PClass; AAutoClass: PAutoClass; ADispID: TGUID);
begin
  FClassRef := AClass;
  FAutoClassRef := AAutoClass;
  FDispatchID := ADispID;
end;

// PClassRegistryEntry
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PClassRegistry

constructor PClassRegistry.Create;
begin
  inherited;
  FEntryList := THashedStringList.Create;
  FEntryList.CaseSensitive := True;
end;

destructor PClassRegistry.Destroy;
var
  I: Integer;
  E: PClassRegistryEntry;
begin
  for I := FEntryList.Count - 1 downto 0 do
  begin
    E := FEntryList.Objects[I] as PClassRegistryEntry;
    E.Free;
  end;
  inherited;
end;

function PClassRegistry.GetEntry(Index: Integer): PClassRegistryEntry;
begin
  Result := FEntryList.Objects[Index] as PClassRegistryEntry;
end;

function PClassRegistry.GetEntryCount: Integer;
begin
  Result := FEntryList.Count;
end;

procedure PClassRegistry.RegisterClass(AClass: PClass);
var
  AEntry: PClassRegistryEntry;
begin
  AEntry := FindEntry(AClass);
  if AEntry = nil then
  begin
    AEntry := PClassRegistryEntry.Create(AClass);
    AEntry.FClassRef := AClass;
    FEntryList.AddObject(AEntry.ClassRef.ClassName, AEntry);
  end;
end;

procedure PClassRegistry.RegisterAutomationClass(AClass: PClass; AAutoClass: PAutoClass; ADispID: TGUID);
var
  AEntry: PClassRegistryEntry;
begin
  AEntry := FindEntry(AClass);
  if AEntry <> nil then
  begin
    AEntry.FAutoClassRef := AAutoClass;
    AEntry.FDispatchID := ADispID;
  end;
end;

function PClassRegistry.FindEntry(AClass: PClass): PClassRegistryEntry;
var
  Idx: Integer;
begin
  Idx := FEntryList.IndexOf(AClass.ClassName);
  if Idx < 0 then
    Result := nil
  else
    Result := FEntryList.Objects[Idx] as PClassRegistryEntry;
end;

function PClassRegistry.FindEntry(AClassName: string): PClassRegistryEntry;
var
  Idx: Integer;
begin
  Idx := FEntryList.IndexOf(AClassName);
  if Idx < 0 then
    Result := nil
  else
    Result := FEntryList.Objects[Idx] as PClassRegistryEntry;
end;

// PClassRegistry
////////////////////////////////////////////////////////////////////////////////

procedure RegisterClasses;
begin
  ClassRegistry.RegisterClass(PObject);
end;

initialization
  ClassRegistry := PClassRegistry.Create;
finalization
  ClassRegistry.Free;
end.

