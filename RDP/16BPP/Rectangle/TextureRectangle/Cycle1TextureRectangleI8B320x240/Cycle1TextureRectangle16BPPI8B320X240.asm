; N64 'Bare Metal' 16BPP 320x240 Cycle1 Texture Rectangle I8B RDP Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 320,240, BPP16|AA_MODE_2, $A0100000 ; Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  DMA Texture,TextureEnd, $00200000 ; DMA Data Copy Cart->DRAM: Start Cart Address, End Cart Address, Destination DRAM Address

  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank

  DPC RDPBuffer,RDPBufferEnd ; Run DPC Command Buffer: Start Address, End Address

Loop:
  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-bit
RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Color_Image SIZE_OF_PIXEL_16B|(320-1), $00100000 ; Set Color Image: SIZE 16B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 ; Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER, B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN ; Set Other Modes
  Set_Combine_Mode $0, $00, 0, 0, $1, $01, $0, $F, 1, 0, $1, $0, 0, 7, 7, 7 ; Set Combine Mode: SubA RGB0, MulRGB0, SubA Alpha0, MulAlpha0, SubA RGB1, MulRGB1, SubB RGB0, SubB RGB1, SubA Alpha1, MulAlpha1, AddRGB0, SubB Alpha0, AddAlpha0, AddRGB1, SubB Alpha1, AddAlpha1
  Set_Prim_Color 0,0, $FFFFFFFF ; Set Prim Color: Prim Min Level 0, Prim Level Frac 0, R 255, G 255, B 255, A 255


  Set_Texture_Image SIZE_OF_PIXEL_8B|(8-1), $00200000 ; Set Texture Image: SIZE 8B, WIDTH 8, DRAM ADDRESS $00200000
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_8B|(2<<9)|$000, 0<<24 ; Set Tile: I, SIZE 8B, Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 ; Load Tile: SL 0.0, TL 0.0, Tile 0, SH 7.0, TH 7.0
  Texture_Rectangle 80<<2,68<<2, 0, 64<<2,52<<2, 0<<5,0<<5, $200,$200 ; Texture Rectangle: XL 80.0, YL 68.0, Tile 0, XH 64.0, YH 52.0, S 0.0, T 0.0, DSDX 0.5, DTDY 0.5

  Sync_Tile ; Sync Tile
  Texture_Rectangle 80<<2,130<<2, 0, 72<<2,122<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 80.0, YL 130.0, Tile 0, XH 72.0, YH 122.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Texture_Rectangle_Flip 80<<2,200<<2, 0, 72<<2,192<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle Flip: XL 80.0, YL 200.0, Tile 0, XH 72.0, YH 192.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0


  Sync_Tile ; Sync Tile
  Set_Texture_Image SIZE_OF_PIXEL_8B|(16-1), $00200040 ; Set Texture Image: SIZE 8B, WIDTH 16, DRAM ADDRESS $00200040
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_8B|(4<<9)|$000, (0<<24)|SHIFT_S_1|SHIFT_T_1 ; Set Tile: I, SIZE 8B, Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0, Shift S 1,Shift T 1
  Load_Tile 0<<2,0<<2, 0, 15<<2,15<<2 ; Load Tile: SL 0.0, TL 0.0, Tile 0, SH 15.0, TH 15.0
  Texture_Rectangle 168<<2,76<<2, 0, 136<<2,44<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 168.0, YL 76.0, Tile 0, XH 136.0, YH 44.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_8B|(4<<9)|$000, 0<<24 ; Set Tile: I, SIZE 8B, Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 168<<2,130<<2, 0, 152<<2,114<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 168.0, YL 130.0, Tile 0, XH 152.0, YH 114.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Texture_Rectangle_Flip 168<<2,200<<2, 0, 152<<2,184<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle Flip: XL 168.0, YL 200.0, Tile 0, XH 152.0, YH 184.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0


  Sync_Tile ; Sync Tile
  Set_Texture_Image SIZE_OF_PIXEL_8B|(32-1), $00200140 ; Set Texture Image: SIZE 8B, WIDTH 32, DRAM ADDRESS $00200140
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_8B|(8<<9)|$000, (0<<24)|MIRROR_S|MIRROR_T|MASK_S_4|MASK_T_4 ; Set Tile: I, SIZE 8B, Tile Line Size 8 (64bit Words), TMEM Address $000, Tile 0, MIRROR S, MIRROR T, MASK S 4, MASK T 4
  Load_Tile 0<<2,0<<2, 0, 31<<2,31<<2 ; Load Tile: SL 0.0, TL 0.0, Tile 0, SH 31.0, TH 31.0
  Texture_Rectangle 276<<2,92<<2, 0, 212<<2,28<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 276.0, YL 92.0, Tile 0, XH 212.0, YH 28.0, S 0.0, T 0.0, DSDX 0.5, DTDY 0.5

  Sync_Tile ; Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_8B|(8<<9)|$000, 0<<24 ; Set Tile: I, SIZE 8B, Tile Line Size 8 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 276<<2,130<<2, 0, 244<<2,98<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture_Rectangle: XL 276.0, YL 130.0, Tile 0, XH 244.0, YH 98.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Texture_Rectangle_Flip 276<<2,200<<2, 0, 244<<2,168<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle Flip: XL 276.0, YL 200.0, Tile 0, XH 244.0, YH 168.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Full ; Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

Texture:
  db $E0,$00,$00,$80,$80,$00,$00,$00 // 8x8x8B = 64 Bytes
  db $00,$00,$80,$FF,$FF,$80,$00,$00
  db $00,$80,$FF,$FF,$FF,$FF,$80,$00
  db $80,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $80,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $80,$80,$80,$FF,$FF,$80,$80,$80
  db $00,$00,$80,$FF,$FF,$80,$00,$00
  db $00,$00,$80,$80,$80,$80,$00,$00

  db $E0,$E0,$00,$00,$00,$00,$00,$80,$80,$00,$00,$00,$00,$00,$00,$00 // 16x16x8B = 256 Bytes
  db $E0,$E0,$00,$00,$00,$00,$80,$FF,$FF,$80,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00
  db $00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00
  db $00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00
  db $00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00
  db $80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $80,$80,$80,$80,$80,$80,$FF,$FF,$FF,$FF,$80,$80,$80,$80,$80,$80
  db $00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00,$00

  db $E0,$E0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 32x32x8B = 1024 Bytes
  db $E0,$E0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $E0,$E0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $E0,$E0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00
  db $00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00
  db $00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00
  db $00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00
  db $80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
TextureEnd: