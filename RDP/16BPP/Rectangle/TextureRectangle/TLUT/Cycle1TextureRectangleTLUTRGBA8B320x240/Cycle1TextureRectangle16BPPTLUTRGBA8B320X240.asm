// N64 'Bare Metal' 16BPP 320x240 Cycle1 Texture Rectangle TLUT RGBA8B RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "Cycle1TextureRectangle16BPPTLUTRGBA8B320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $6,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, Tlut // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, Tlut DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 3<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 3.0,TH 0.0


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture8x8 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture8x8 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 80<<2,68<<2, 0, 64<<2,52<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 80.0,YL 68.0, Tile 0, XH 64.0,YH 52.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Texture_Rectangle 80<<2,130<<2, 0, 72<<2,122<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 80.0,YL 130.0, Tile 0, XH 72.0,YH 122.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Texture_Rectangle_Flip 80<<2,200<<2, 0, 72<<2,192<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle Flip: XL 80.0,YL 200.0, Tile 0, XH 72.0,YH 192.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,16-1, Texture16x16 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 16, Texture16x16 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,2, $000, 0,0, 0,0,0,SHIFT_T_1, 0,0,0,SHIFT_S_1 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0, Shift T 1,Shift S 1
  Load_Tile 0<<2,0<<2, 0, 15<<2,15<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 15.0,TH 15.0
  Texture_Rectangle 168<<2,76<<2, 0, 136<<2,44<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 168.0,YL 76.0, Tile 0, XH 136.0,YH 44.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,2, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 168<<2,130<<2, 0, 152<<2,114<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 168.0,YL 130.0, Tile 0, XH 152.0,YH 114.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Texture_Rectangle_Flip 168<<2,200<<2, 0, 152<<2,184<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle Flip: XL 168.0,YL 200.0, Tile 0, XH 152.0,YH 184.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,32-1, Texture32x32 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 32, Texture32x32 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,4, $000, 0,0, 0,MIRROR_T,MASK_T_4,0, 0,MIRROR_S,MASK_S_4,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0, MIRROR T,MASK T 4, MIRROR S,MASK S 4
  Load_Tile 0<<2,0<<2, 0, 31<<2,31<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 31.0,TH 31.0
  Texture_Rectangle 276<<2,92<<2, 0, 212<<2,28<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 276.0,YL 92.0, Tile 0, XH 212.0,YH 28.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5
  
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,4, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 276<<2,130<<2, 0, 244<<2,98<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 276.0,YL 130.0, Tile 0, XH 244.0,YH 98.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Texture_Rectangle_Flip 276<<2,200<<2, 0, 244<<2,168<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle Flip: XL 276.0,YL 200.0, Tile 0, XH 244.0,YH 168.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

Texture8x8:
  db $03,$00,$00,$02,$02,$00,$00,$00 // 8x8x8B = 64 Bytes
  db $00,$00,$02,$01,$01,$02,$00,$00
  db $00,$02,$01,$01,$01,$01,$02,$00
  db $02,$01,$01,$01,$01,$01,$01,$02
  db $02,$01,$01,$01,$01,$01,$01,$02
  db $02,$02,$02,$01,$01,$02,$02,$02
  db $00,$00,$02,$01,$01,$02,$00,$00
  db $00,$00,$02,$02,$02,$02,$00,$00

Texture16x16:
  db $03,$03,$00,$00,$00,$00,$00,$02,$02,$00,$00,$00,$00,$00,$00,$00 // 16x16x8B = 256 Bytes
  db $03,$03,$00,$00,$00,$00,$02,$01,$01,$02,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00
  db $00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00
  db $00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00
  db $00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00
  db $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02
  db $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02
  db $02,$02,$02,$02,$02,$02,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02
  db $00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00

Texture32x32:
  db $03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 32x32x8B = 1024 Bytes
  db $03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00
  db $00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00
  db $00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00
  db $00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00
  db $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02
  db $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02
  db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

Tlut:
  dh $0000,$FFFF,$0001,$F001 // 4x16B = 8 Bytes