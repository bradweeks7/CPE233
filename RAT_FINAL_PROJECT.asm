
;---------------------------------------------------------------
; To modify for testing: 	change array sizes
;							change line 30 to 2 times number of mines desired
;							change pointer in line 59 to start of Y coords
;							change value in line 101 to start of Y coords
;							change value in line 120 to end of Y coords
;							change value in line 124 to start of Y coords
;							change value in line 129 to start of Y coords
;---------------------------------------------------------------

.DSEG
minefieldX: .BYTE 1		
minefieldY: .BYTE 1

; registers used: R0, R1, R2, R3, R4, R5

.CSEG
.ORG 0x10
									; port id's for the various input/output
.EQU RANDOM_ID = 0x21				; get random values
.EQU SWITCHES_ID = 0x20				; get switch value
.EQU KEYPAD_ID = 0x22				; get keypad value
.EQU LEDS_ID = 0x40					; output to leds
.EQU SEVSEG_ID = 0x81				; output to sevseg

;---------------------------------------------------------------
; Mine locations are generated and stored. First half of Memory is X coord,
; second half of Memory is corresponding Y coord
;---------------------------------------------------------------

MOV R0, 0x00						; counter for number of mines (120 total)
MOV R2, 0x00						; pointer for the arrays

SETUP:		CMP R0, 0x02			; check if total coords generated (reduced for testing)
			BREQ MAIN
			IN R1, RANDOM_ID		; get random number
			CALL DIVIDE				; routine gets num in range 0-29
			ADD R0, 0x01			; increment num of mines
			BRN SETUP
			
	
DIVIDE: 
SUBTRACT:	SUB R1, 0x1D			; keep subtracting
			CMP R1, 0x1D
			BRCS DONE				; if num become less than 30, or 0, store it
			BREQ DONE
			BRN SUBTRACT
DONE:		ST R1, (R2)				; store value
			ADD R2, 0x01			; increment counter
			RET						; return from routine

;---------------------------------------------------------------
; Main loop is where movements are taken in, current pos is updated, 
; and check for mines are completed
;---------------------------------------------------------------
			
			
MAIN:		SEI						; interrupts are now enabled
			MOV R3, 0x02			; initial X coord
			MOV R4, 0x02			; initial Y coord
			MOV R0, 0x00			; pointer for beginning of X values
			MOV R1, 0x01			; pointer for beginning of Y values (must be updated later)
			
; get a move 
			
MOVE: 		IN R5, KEYPAD_ID		; get key press
			CMP R5, 0x02			; 2 is pressed, go up
			BREQ UP			
			CMP R5, 0x05			; 5 is pressed, go down
			BREQ DOWN
			CMP R5, 0x04			; 4 is pressed, go left
			BREQ LEFT
			CMP R5, 0x06			; 6 is pressed, go right
			BREQ RIGHT
			BRN MOVE				; else, get another press
			
;---------------------------------------------------------------
; Check to see which move was triggered
;---------------------------------------------------------------
			
UP:			SUB R4, 0x01			; decrement Y by 1
			BRN MINE
DOWN:		ADD R4, 0x01			; increment Y by 1
			BRN MINE
LEFT:		SUB R3, 0x01			; decrement X by 1
			BRN MINE
RIGHT:		ADD R3, 0x01			; increment X by 1
			BRN MINE

MINE: 		BRN CHECK_X

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
			CMP R0, 0x01			; check if the end of X coords was reached (must be updated later)
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
			CMP R1, 0x02			; check if the end of Y coords was reached (must be updated later)
			BREQ NO_MATCH			; if so, no Y matches, so no mine can match
			BRN NEXT_Y				; otherwise, go to next coord

Y_MATCH:	MOV R1, 0x01			; reset Y pointer to 3 (must be changed later)
			BRN GAME_OVER			; if Y matches, a mine was hit
			
NO_MATCH:	MOV R0, 0x00			; reset X pointer
			MOV R1, 0x01			; reset Y pointer
			BRN MOVE				; if there is no match, get another move			

;---------------------------------------------------------------
; Some game over procedure occurs
;---------------------------------------------------------------			
			
GAME_OVER:	OUT R1, LEDS_ID			;do something
