unit jlinkarm;

interface

uses
  SysUtils, Windows;

(* 
RegIndex    RegName

0           R0
1           R1   
2           R2   
3           R3   
4           R4   
5           R5   
6           R6 
7           R7 
8           R8 
9           R9 
10          R10
11          R11
12          R12
13          R13
14          R14
15          R15

16          XPSR
17          MSP
18          PSP
19          RAZ
20          CFBP
21          APSR
22          EPSR
23          IPSR
24          PRIMASK
25          BASEPRI
26          FAULTMASK
27          CONTROL 
28          BASEPRI_MAX
29          IAPSR
30          EAPSR
31          IEPSR

32          FPSCR
33          FPS0
34          FPS1
35          FPS2
36          FPS3
37          FPS4
38          FPS5
39          FPS6
40          FPS7       
41          FPS8      
42          FPS9      
43          FPS10      
44          FPS11      
45          FPS12      
46          FPS13      
47          FPS14  
48          FPS15
49          FPS16
50          FPS17
51          FPS18
52          FPS19
53          FPS20
54          FPS21
55          FPS22
56          FPS23
57          FPS24
58          FPS25
59          FPS26
60          FPS27
61          FPS28
62          FPS29
63          FPS30
64          FPS31
*)


const CM3_Registers :  array[0..64] of string = 
(
  '         CM3_R0',
  '         CM3_R1',
  '         CM3_R2',
  '         CM3_R3',
  '         CM3_R4',
  '         CM3_R5',
  '         CM3_R6',
  '         CM3_R7',
  '         CM3_R8',
  '         CM3_R9',
  '        CM3_R10',
  '        CM3_R11',
  '        CM3_R12',
  '        CM3_R13',
  '        CM3_R14',
  '        CM3_R15',
  '       CM3_XPSR',
  '        CM3_MSP',
  '        CM3_PSP',
  '        CM3_RAZ',
  '       CM3_CFBP',
  '       CM3_APSR',
  '       CM3_EPSR',
  '       CM3_IPSR',
  '    CM3_PRIMASK',
  '    CM3_BASEPRI',
  '  CM3_FAULTMASK',
  '    CM3_CONTROL',
  'CM3_BASEPRI_MAX',
  '      CM3_IAPSR',
  '      CM3_EAPSR',
  '      CM3_IEPSR',
  '      CM3_FPSCR',
  '       CM3_FPS0',
  '       CM3_FPS1',
  '       CM3_FPS2',
  '       CM3_FPS3',
  '       CM3_FPS4',
  '       CM3_FPS5',
  '       CM3_FPS6',
  '       CM3_FPS7',
  '       CM3_FPS8',
  '       CM3_FPS9',
  '      CM3_FPS10',
  '      CM3_FPS11',
  '      CM3_FPS12',
  '      CM3_FPS13',
  '      CM3_FPS14',
  '      CM3_FPS15',
  '      CM3_FPS16',
  '      CM3_FPS17',
  '      CM3_FPS18',
  '      CM3_FPS19',
  '      CM3_FPS20',
  '      CM3_FPS21',
  '      CM3_FPS22',
  '      CM3_FPS23',
  '      CM3_FPS24',
  '      CM3_FPS25',
  '      CM3_FPS26',
  '      CM3_FPS27',
  '      CM3_FPS28',
  '      CM3_FPS29',
  '      CM3_FPS30',
  '      CM3_FPS31'
);

const            CM3_R0  = $00;
const            CM3_R1  = $01;
const            CM3_R2  = $02;
const            CM3_R3  = $03;
const            CM3_R4  = $04;
const            CM3_R5  = $05;
const            CM3_R6  = $06;
const            CM3_R7  = $07;
const            CM3_R8  = $08;
const            CM3_R9  = $09;
const           CM3_R10  = $0A;
const           CM3_R11  = $0B;
const           CM3_R12  = $0C;
const           CM3_R13  = $0D;
const           CM3_R14  = $0E;
const           CM3_R15  = $0F;
const          CM3_XPSR  = $10;
const           CM3_MSP  = $11;
const           CM3_PSP  = $12;
const           CM3_RAZ  = $13;
const          CM3_CFBP  = $14;
const          CM3_APSR  = $15;
const          CM3_EPSR  = $16;
const          CM3_IPSR  = $17;
const       CM3_PRIMASK  = $18;
const       CM3_BASEPRI  = $19;
const     CM3_FAULTMASK  = $1A;
const       CM3_CONTROL  = $1B;
const   CM3_BASEPRI_MAX  = $1C;
const         CM3_IAPSR  = $1D;
const         CM3_EAPSR  = $1E;
const         CM3_IEPSR  = $1F;
const         CM3_FPSCR  = $20;
const          CM3_FPS0  = $21;
const          CM3_FPS1  = $22;
const          CM3_FPS2  = $23;
const          CM3_FPS3  = $24;
const          CM3_FPS4  = $25;
const          CM3_FPS5  = $26;
const          CM3_FPS6  = $27;
const          CM3_FPS7  = $28;
const          CM3_FPS8  = $29;
const          CM3_FPS9  = $2A;
const         CM3_FPS10  = $2B;
const         CM3_FPS11  = $2C;
const         CM3_FPS12  = $2D;
const         CM3_FPS13  = $2E;
const         CM3_FPS14  = $2F;
const         CM3_FPS15  = $30;
const         CM3_FPS16  = $31;
const         CM3_FPS17  = $32;
const         CM3_FPS18  = $33;
const         CM3_FPS19  = $34;
const         CM3_FPS20  = $35;
const         CM3_FPS21  = $36;
const         CM3_FPS22  = $37;
const         CM3_FPS23  = $38;
const         CM3_FPS24  = $39;
const         CM3_FPS25  = $3A;
const         CM3_FPS26  = $3B;
const         CM3_FPS27  = $3C;
const         CM3_FPS28  = $3D;
const         CM3_FPS29  = $3E;
const         CM3_FPS30  = $3F;
const         CM3_FPS31  = $40;


function JLINKARM_IsConnected() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_IsConnected';

function JLINKARM_Open() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_Open';
function JLINKARM_IsOpen() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_IsOpen';
function JLINKARM_Close() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_Close';

function JLINKARM_Test() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_Test';

function JLINKARM_Go() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_Go';
function JLINKARM_GoEx(param1 : integer; param2 : integer) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_GoEx';
function JLINKARM_GoHalt() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_GoHalt';

function JLINKARM_Halt() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_Halt';
function JLINKARM_IsHalted() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_IsHalted';


function JLINKARM_SetResetType(ResetType : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_SetResetType';
function JLINKARM_SetResetDelay(ResetDelay : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_SetResetDelay';
function JLINKARM_Reset() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_Reset';

function JLINKARM_ResetNoHalt() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_ResetNoHalt';

// JLINKARM_ResetNoHalt
// JLINKARM_Reset then JLINKARM_Go

function JLINKARM_TIF_Select(is_swd_intf : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_TIF_Select';
function JLINKARM_TIF_GetAvailable(param : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_TIF_GetAvailable';


function JLINKARM_SetSpeed(jlink_speed : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_SetSpeed';
function JLINKARM_SetMaxSpeed() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_SetMaxSpeed';
function JLINKARM_GetSpeed() : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_GetSpeed';

function JLINKARM_ReadMem(memaddr : DWORD; size : DWORD; var buff : array of BYTE) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_ReadMem';
function JLINKARM_ReadMemU8(memaddr : DWORD; size : DWORD; var buff : array of BYTE; flag : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_ReadMemU8';
function JLINKARM_ReadMemU16(memaddr : DWORD; size : DWORD; var buff : array of WORD; flag : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_ReadMemU16';
function JLINKARM_ReadMemU32(memaddr : DWORD; size : DWORD; var buff : array of DWORD; flag : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_ReadMemU32';

function JLINKARM_WriteMem(memaddr : DWORD; size : DWORD; buff : array of BYTE) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_WriteMem';

function JLINKARM_WriteU8(memaddr : DWORD; data : BYTE) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_WriteU8';
function JLINKARM_WriteU16(memaddr : DWORD; data : WORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_WriteU16';
function JLINKARM_WriteU32(memaddr : DWORD; data : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_WriteU32';
function JLINKARM_WriteU64(memaddr : DWORD; data : INT64) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_WriteU64';

function JLINKARM_ReadReg(RegIndex : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_ReadReg';
function JLINKARM_WriteReg(RegIndex : DWORD; RegValue : DWORD) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_WriteReg';


function JLINKARM_ExecCommand(pbCommand : pAnsichar; param1 : integer; param2 : integer) : integer;
  cdecl; external 'jlinkarm.dll' name 'JLINKARM_ExecCommand';

implementation

end.