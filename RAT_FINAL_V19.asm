
;---------------------------------------------------------------
; To modify for testing: 	change array sizes
;							change line 30 to 2 times number of mines desired
;							change pointer in line 59 to start of Y coords
;							change value in line 101 to start of Y coords
;							change value in line 120 to end of Y coords
;							change value in line 124 to start of Y coords
;							change value in line 129 to start of Y coords
;---------------------------------------------------------------

; to do: if using switches, remap controls and set leds for switches used to light up
; if using keypad, find a use for leds


.DSEG
minefieldX: .BYTE 20		
minefieldY: .BYTE 20

; registers used: R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12

.CSEG
.ORG 0x10
									; port id's for the various input/output
.EQU RANDOM_ID = 0x21				; get random values
.EQU SWITCHES_ID = 0x20				; get switch value
.EQU KEYBOARD_ID = 0x22				; get keyboard value
.EQU LEDS_ID = 0x40					; output to leds
.EQU SEVSEG_ID = 0x81				; output to sevseg
.EQU VGA_HI = 0x82					; output for col
.EQU VGA_LO = 0x83					; output for row
.EQU COLOR = 0x84					; output for color

;---------------------------------------------------------------
; In order to start, a button must be pressed. This allows a random amount of time
; to pass in order to generate a "random" board. 
;---------------------------------------------------------------
WAIT:		MOV R0, 0x00			; initialize a register for button value
			MOV R1, 0x00
			OUT R1, SEVSEG_ID
			MOV R2, 0x05
			OUT R2, LEDS_ID
			IN R0, SWITCHES_ID		; get a button value
			CMP R0, 0x05			; check if button 5 is pressed
			BRNE WAIT				; if not, leep waiting. Otherwise, move on to SETUP
			
;---------------------------------------------------------------
; Mine locations are generated and stored. First half of Memory is X coord,
; second half of Memory is corresponding Y coord
;---------------------------------------------------------------

MOV R0, 0x00						; counter for number of mines (120 total)
MOV R2, 0x00						; pointer for the arrays
MOV R1, 0x00
MOV R3, 0x00
MOV R4, 0x00
MOV R5, 0x00
MOV R6, 0x00
MOV R7, 0x00
MOV R8, 0x00

SETUP:		CMP R0, 0x28			; check if total coords generated (reduced for testing)
			BREQ MAIN
			IN R1, RANDOM_ID		; get random number
			CALL SUBTRACT				; routine gets num in range 0-29
			ADD R0, 0x01			; increment num of mines
			BRN SETUP
			
	 
SUBTRACT:	CMP R1, 0x1D
			BRCS DONE				; if num become less than 30, or 0, store it
			BREQ DONE
			SUB R1, 0x1D			; keep subtracting
			BRN SUBTRACT
DONE:		ST R1, (R2)				; store value
			ADD R2, 0x01			; increment counter
			RET						; return from routine

;---------------------------------------------------------------
; Main sets up pointers and registers used to track iteration through mines
; as well as current position and previous move
;---------------------------------------------------------------
	
MAIN:		MOV R3, 0x08			; initial X coord
			MOV R4, 0x08			; initial Y coord
			MOV R0, 0x00			; pointer for beginning of X values
			MOV R1, 0x14			; pointer for beginning of Y values (must be updated later)
			MOV R6, 0x00			; a register to track the previous move
			MOV R7, 0x00			; a register to track score
			MOV R8, 0xAA			; leds corresponding to active switches
			MOV R9, 0x1C			; color corresponding to green for current pos
			MOV R10, 0x03			; blue for path
			MOV R11, 0x00			; Old X pos
			MOV R12, 0x00			; Old Y pos
			OUT R8, LEDS_ID
									; get a move 
			
;---------------------------------------------------------------
; MOVE loop is where movements are taken in, current pos is updated, 
; and check for mines are completed
;---------------------------------------------------------------
			
MOVE: 		SEI						; interrupts enabled
LOOP:		CMP R5, 0x00			; compare new move to previous move
			BREQ LOOP				; if it is the same move, you must try again
GOT_MOVE:	MOV R6, R5				; otherwise, save the current move
			CMP R5, 0x43			; I is pressed, go up
			BREQ UP			
			CMP R5, 0x42			; K is pressed, go down
			BREQ DOWN
			CMP R5, 0x3B			; J is pressed, go left
			BREQ LEFT
			CMP R5, 0x4B			; L is pressed, go right
			BREQ RIGHT
			MOV R5, 0x00
			BRN MOVE				; else, get another press
			
;---------------------------------------------------------------
; Check to see which move was triggered
;---------------------------------------------------------------
			
UP:			CMP R4, 0x00			; check for top edge
			MOV R5, 0x00
			BREQ MOVE				; if so, new move
			MOV R11, R3				; save old X coord
			MOV R12, R4				; save old Y coord		
			SUB R4, 0x01			; decrement Y by 1
			BRN MINE
DOWN:		CMP R4, 0x1D			; check for bottom edge
			MOV R5, 0x00
			BREQ MOVE
			MOV R11, R3				; save old X coord
			MOV R12, R4				; save old Y coord
			ADD R4, 0x01			; increment Y by 1
			BRN MINE
LEFT:		CMP R3, 0x00			; check for left edge
			MOV R5, 0x00
			BREQ MOVE
			MOV R11, R3				; save old X coord
			MOV R12, R4				; save old Y coord
			SUB R3, 0x01			; decrement X by 1
			BRN MINE
RIGHT:		CMP R3, 0x27			; check for right edge
			MOV R5, 0x00
			BREQ MOVE
			MOV R11, R3				; save old X coord
			MOV R12, R4				; save old Y coord
			ADD R3, 0x01			; increment X by 1
			BRN MINE

MINE: 		CALL UPDATE
			BRN CHECK_X

;---------------------------------------------------------------
; First, compare the X coordinates. If no match is found, get a
; new move. Otherwise, check the Y values
;---------------------------------------------------------------

CHECK_X:		
NEXT_X:		LD R2, (R0)				; get value at X pointer
			CMP R2, R3				; compare X with current X coord
			ST R2, (R0)				; return value
			BREQ X_MATCH			; a match for x coor was found
			ADD R0, 0x01			; increment X pointer
			CMP R0, 0x14			; check if the end of X coords was reached (must be updated later)
			BREQ NO_MATCH			; if so, no X matches, so no mine can match
			BRN NEXT_X				; otherwise, go to next coord
		
X_MATCH:	MOV R0, 0x00			; reset X pointer to 0
			BRN CHECK_Y

;---------------------------------------------------------------
; When checking Y values, if there is no match, get a new move. 
; Otherwise, a mine was found and the game ends
;---------------------------------------------------------------			
			
CHECK_Y:
NEXT_Y:		LD R2, (R1)				; get value at Y pointer
			CMP R2, R4				; compare Y with current Y coord
			ST R2, (R1)				; return value
			BREQ Y_MATCH			; a match for Y coor was found
			ADD R1, 0x01			; increment X pointer
			CMP R1, 0x28			; check if the end of Y coords was reached (must be updated later)
			BREQ NO_MATCH			; if so, no Y matches, so no mine can match
			BRN NEXT_Y				; otherwise, go to next coord

Y_MATCH:	MOV R1, 0x14			; reset Y pointer to 3 (must be changed later)
			BRN GAME_OVER			; if Y matches, a mine was hit
			
NO_MATCH:	MOV R0, 0x00			; reset X pointer
			MOV R1, 0x14			; reset Y pointer
			ADD R7, 0x01			; add a point for a correct move
			OUT R7, SEVSEG_ID		; output current score
			MOV R5, 0x00			; reset move reg
			BRN MOVE				; if there is no match, get another move			
;---------------------------------------------------------------
; After a move occurs, before checking mines, we must update the 
; VGA deisplay by outputting data
;---------------------------------------------------------------			
							
UPDATE: 
			OUT R11, VGA_HI			; output old col val
			OUT R12, VGA_LO			; output old row val
			OUT R10, COLOR			; output path color
			OUT R4, VGA_HI			; output column value
			OUT R3, VGA_LO			; output row value
			OUT R9, COLOR			; output color update
			RET
			
;---------------------------------------------------------------
; Some game over procedure occurs
;---------------------------------------------------------------			
			
GAME_OVER:	MOV R2, 0xFF
			OUT R2, LEDS_ID			;do something
			BRN GAME_OVER


GET_MOVE:	IN R5, KEYBOARD_ID		; get in value
			RETID					; disable interrupts to prevent multiple presses

.CSEG
.ORG 0x3FF					
BRN GET_MOVE
