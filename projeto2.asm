TITLE Sudoku_PedroTrevisan_RafaelPerroni
.MODEL SMALL
.stack 100h

.data

    ; Apresentation Prints
    BOUNDUP	    DB "=======================================================$"
	TITULO 	    DB "|                Sudoku - Projeto 2                   |$"
    COMPS 	    DB "|              Rafael & Pedro Trevisan                |$"
	DIGITE 	    DB "|  Opcoes: (selecione um)                             |$"
	CMDPLAY	    DB "|  1 - Iniciar o Jogo                                 |$"
	CMDHTP	    DB "|  2 - Como Jogar                                     |$"
	CMDEND	    DB "|  x - Encerrar o jogo                                |$"
    BOUNDDOWN	DB "|=====================================================|$"

    GAME_LINE   DB "------------------------------------- $"
    GAME_COLUM  DB "|   |   |   |   |   |   |   |   |   | $"

    ; General Usage Prints
    END_GAME    DB "Obrigado por jogar!!!$"
    OBJ_GAME    DB "O objetivo do jogo eh completar todos os quadrados utilizando numeros de 1 a 9.$"
    REGRAS      DB "REGRA: Nao podem haver numeros repetidos nas linhas horizontais e verticais, assim como nas sub-Matrizes $"
    BACKMENU    DB "Pressione ENTER para voltar para o Menu $"

    ;Errors Messages
    INVOPT      DB "Opcao Invalida. Tente Novamente $"

.CODE

; ----------------------------------------------------- MACROS ---------------------------------------------------------------
;Function Name: NewLine (MACRO)
;Description: Funtion used only to jump to next line
;Register used: None
NewLine MACRO
    ; to jump to next line
    MOV DL, 10 
    MOV AH, 02h 
    INT 21h
    MOV DL, 13
    MOV AH, 02h
    INT 21h
ENDM

;Function Name: ClearScreen (MACRO)
;Description: Funtion used only to clean the screen
;Register used: None
ClearScreen MACRO
    MOV AX,3H			
	INT 10H	
ENDM
; ----------------------------------------------------- MACROS ---------------------------------------------------------------

; ----------------------------------------------------- MAIN PROC ------------------------------------------------------------
MAIN PROC

    MOV AX, @DATA
    MOV DS,AX

    call printMenu

; End of program
FIM:

    ClearScreen

    MOV AH, 09
    LEA DX, END_GAME
    INT 21h

    MOV AH, 4CH ;retorna ao programa
    INT 21h
MAIN ENDP

; ----------------------------------------------------- Functions ------------------------------------------------------------

;Function Name: printMenu
;Description: Funtion used only to print the game Menu
;Register used: None
printMenu PROC

    ; Clear the screen
    MOV AX,3H			
	INT 10H	

    MOV AH, 09
    LEA DX, BOUNDUP
    INT 21h

    NewLine
    
    MOV AH, 09
    LEA DX, TITULO
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, COMPS
    INT 21h

    NewLine
    
    MOV AH, 09
    LEA DX, DIGITE
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDPLAY
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDHTP
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDEND
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, BOUNDDOWN
    INT 21h

    NewLine

    call checkInput
    
printMenu ENDP

;Function Name: checkInput
;Description: Funtion used to verify user Input on Menu
;Register used: None
checkInput PROC

    MOV AH,08h
    INT 21H
    MOV BL, AL ; Get answer and save it in BL to compare to our options

    ; CMP 1
    CMP BL, 31h
    JE playGame

    ; CMP 2
    CMP BL, 32h
    JE howToPlay

    ; CMP x
    CMP BL, 78h
    JNE InvalidInput

    JMP FIM

InvalidInput:
    ; Invalid Option Insert -> Print error and ask for it again
    MOV AH, 09
    LEA DX, INVOPT
    INT 21h

    NewLine

    JMP checkInput
checkInput ENDP

;Function Name: playGame
;Description: Funtion used to print the game and check user options (mouse Click and number input)
;Register used: 
playGame PROC
    ClearScreen

    call printMap

    NewLine

        MOV AH, 09h
    LEA DX, BACKMENU
    INT 21h

    ; Waits for a ENTER
    MOV AH, 01h
    INT 21H

playGame ENDP

;Function Name: howToPlay
;Description: Funtion used only to print the game Rules
;Register used: None
howToPlay PROC
    ClearScreen

    MOV AH, 09H
    LEA DX, OBJ_GAME
    INT 21h

    NewLine
    NewLine

    MOV AH, 09H
    LEA DX, REGRAS
    INT 21h

    NewLine
    NewLine

    ; Message to indicate how to turn back to the menu
    MOV AH, 09h
    LEA DX, BACKMENU
    INT 21h

    ; Waits for a ENTER
    MOV AH, 01h
    INT 21H

    call printMenu
howToPlay ENDP

;Function Name: printMap
;Description: Funtion used only to print the game structure
;Register used: None
printMap proc

    MOV AH, 09h
    LEA DX, GAME_LINE
    INT 21h

    NewLine

    XOR CX, CX
    MOV CX, 9

printES:

    MOV AH, 09h
    LEA DX, GAME_COLUM
    INT 21h

    NewLine

    CMP CX, 0
    JZ SAI
    MOV AH, 09h
    LEA DX, GAME_LINE
    INT 21h
    NewLine
    LOOP printES

SAI:
    RET
printMap endp

End MAIN