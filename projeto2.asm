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
    BACKMENU    DB "<Pressione ENTER para voltar para o Menu> $"
    WRONG       DB "Resposta incorreta !!! $"

    ; Game Maps
    MAP_GAME1	DB  36h, 30h, 32h, 37h, 30h, 30h, 39h, 30h, 34h,
                DB  30h, 39h, 30h, 34h, 33h, 36h, 37h, 30h, 30h,
                DB  30h, 33h, 30h, 30h, 30h, 30h, 30h, 30h, 31h,
                DB  30h, 30h, 30h, 30h, 36h, 30h, 30h, 30h, 38h,
                DB  30h, 30h, 31h, 32h, 30h, 33h, 36h, 30h, 30h,
                DB  38h, 30h, 30h, 30h, 34h, 30h, 30h, 30h, 30h,
                DB  32h, 30h, 30h, 30h, 30h, 30h, 30h, 37h, 30h,
                DB  30h, 30h, 35h, 36h, 32h, 34h, 30h, 38h, 30h,
                DB  34h, 30h, 36h, 30h, 30h, 39h, 35h, 30h, 33h
    
    SOL_GAME1   DB  36h, 35h, 32h, 37h, 31h, 38h, 39h, 33h, 34h,
                DB  31h, 39h, 38h, 34h, 33h, 36h, 37h, 35h, 32h,
                DB  37h, 33h, 34h, 35h, 39h, 32h, 38h, 36h, 31h,
                DB  39h, 32h, 37h, 31h, 36h, 35h, 33h, 34h, 38h,
                DB  35h, 34h, 31h, 32h, 38h, 33h, 36h, 39h, 37h,
                DB  38h, 36h, 33h, 39h, 34h, 37h, 32h, 31h, 35h,
                DB  32h, 38h, 39h, 33h, 35h, 31h, 34h, 37h, 36h,
                DB  33h, 37h, 35h, 36h, 32h, 34h, 31h, 38h, 39h,
                DB  34h, 31h, 36h, 38h, 37h, 39h, 35h, 32h, 33h

    MAP_GAME2	DB  34h, 30h, 30h, 33h, 30h, 38h, 30h, 30h, 36h,
                DB  32h, 33h, 30h, 30h, 36h, 30h, 34h, 30h, 30h,
                DB  30h, 30h, 39h, 34h, 30h, 30h, 37h, 30h, 30h,
                DB  38h, 39h, 30h, 37h, 30h, 30h, 30h, 30h, 30h,
                DB  35h, 30h, 30h, 30h, 30h, 30h, 39h, 31h, 30h,
                DB  30h, 36h, 30h, 30h, 30h, 30h, 30h, 30h, 37h,
                DB  30h, 30h, 38h, 30h, 31h, 30h, 30h, 34h, 33h,
                DB  30h, 34h, 31h, 30h, 30h, 30h, 30h, 36h, 30h,
                DB  30h, 30h, 30h, 38h, 30h, 32h, 30h, 37h, 30h
    
    SOL_GAME2   DB  34h, 31h, 35h, 33h, 37h, 38h, 32h, 39h, 36h,
                DB  32h, 33h, 37h, 31h, 36h, 39h, 34h, 38h, 35h,
                DB  36h, 38h, 39h, 34h, 32h, 35h, 37h, 33h, 31h,
                DB  38h, 39h, 33h, 37h, 35h, 31h, 36h, 32h, 34h,
                DB  35h, 37h, 34h, 32h, 33h, 36h, 39h, 31h, 38h,
                DB  31h, 36h, 32h, 39h, 38h, 34h, 33h, 35h, 37h,
                DB  39h, 32h, 38h, 36h, 31h, 37h, 35h, 34h, 33h,
                DB  37h, 34h, 31h, 35h, 39h, 33h, 38h, 36h, 32h,
                DB  33h, 35h, 36h, 38h, 34h, 32h, 31h, 37h, 39h
    ;Errors Messages
    INVOPT      DB "Opcao Invalida. Tente Novamente $"

    ; Input Prints
    MSG_LINHA DB "Digite o numero da linha: $"
    MSG_COLUNA DB "Digite o numero da coluna: $"
    MSG_RESP DB "Digite o numero da resposta: $"

    ;Variables
    ROW         EQU 9
    COLUMN      EQU 9
    START_COL   DB ?
    START_ROW   DB ?
    BACKUP_BX   DW ?

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

    MOV START_COL, 2
    MOV START_ROW, 1
    call gotoxy
    LEA BX, MAP_GAME1
    
    MOV BACKUP_BX, BX

    call printNumbers

    NewLine
    NewLine
    NewLine
    NewLine

    CALL getInput

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

;Function Name: printNumbers
;Description: Funtion used to print the initial game numbers inside de game structure
;Register used: None
printNumbers PROC

    MOV AH,02
    MOV CX,ROW
outer:
    MOV START_COL, 2
    call gotoxy
    MOV DI,COLUMN
    XOR SI,SI
inner:
    MOV DL, [BX][SI]
    INT 21H
    INC SI
    ADD START_COL, 4
    call gotoxy
    DEC DI
    JNZ inner
    ADD START_ROW, 2
    ADD BX,COLUMN
    LOOP outer
    RET
    
printNumbers ENDP

;Function Name: gotoxy (MACRO)
;Description: Funtion used to define the print position of the cursor
;Register used: None
gotoxy PROC
    PUSH SI
    PUSH BX
    mov ah,02h
    mov bh, 00h
    mov dl,START_COL
    mov dh,START_ROW
    int 10h
    POP BX
    POP SI
    RET
gotoxy ENDP

;Function Name: getInput
;Description: Funtion used only to get number inputs
;Register used: None
getInput proc

    NUM_INVALID_LINHA:
    NewLine
    LEA DX, MSG_LINHA
    MOV AH,09h
    INT 21h
    
    MOV ah, 01H       
    INT 21H

    MOV DL, AL
    SUB DL, 48 
    CMP DL, 9 ;Compara se o numero recebido é maior que 9, se sim ele retorna para receber um caracter valido
    JA NUM_INVALID_LINHA

    MOV CL, DL ;Guarda a linha em CL

    NUM_INVALID_COLUNA:
    NewLine
    LEA DX, MSG_COLUNA
    MOV AH,09h
    INT 21h
    
    MOV ah, 01H       
    INT 21H

    MOV DL, AL
    SUB DL, 48 
    CMP DL, 9 ;Compara se o numero recebido é maior que 9, se sim ele retorna para receber um caracter valido
    JA NUM_INVALID_COLUNA

    MOV CH, DL ;Guarda a linha em CH

    NUM_INVALID_RESP:
    NewLine
    LEA DX, MSG_RESP
    MOV AH,09h
    INT 21h
    
    MOV ah, 01H       
    INT 21H

    MOV DL, AL
    SUB DL, 48 
    CMP DL, 9 ;Compara se o numero recebido é maior que 9, se sim ele retorna para receber um caracter valido
    JA NUM_INVALID_RESP 

    MOV BH, DL ;Guarda a linha em BH

    NewLine
              
    RET
getInput endp

;Function Name: checkEntry
;Description: Funtion used only to get number inputs
;Register used: None
checkEntry proc


checkEntry endp

;Function Name: comperResp
;Description: Funtion used compare de awnser with the solution
;Register used: 
comperResp PROC
    XOR AX, AX
    MOV AL, CH ;Recebe a Coluna 
    XOR CH, CH ;Zera a parte alta do registrador e mantem linha em CL
    MOV DH, BH ;Recebe a Resposta

    XOR SI, SI

    LEA BX, SOL_GAME1
    ADD BX, AX
    ADD SI, CX
    MOV DL, [BX][SI]
    CMP DH, DL
    JE rightResp

    LEA DX, WRONG ;Imprimi mensagem de erro
    MOV AH,09h
    INT 21h
    JMP FIMPROC ;Pula para o RET

    rightResp:
    LEA BX, MAP_GAME1 ;Carrega matriz mapa
    ADD BX, AX
    MOV [BX][SI], DH ;Salva o valor correto na matriz mapa
    FIMPROC:

    RET
comperResp ENDP
End MAIN