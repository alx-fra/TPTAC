.8086
.model small
.stack 2048h

dseg    segment para public 'data'
        Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
        Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
        Fich         	db      'DADOS.TXT',0
		Fich2         	db      'NIVEL2.TXT',0
		Fichtop10      	db      'TOP10.TXT',0
		FichGanhou		db      'GANHOU.TXT',0
		FichDif			db 		'DIF.TXT',0
		PALAVRAS1		db 		'PLVR1.TXT',0
		PALAVRAS2		db 		'PLVR2.TXT',0
        HandleFich      dw      0
        car_fich        db      ?
		
		
		menujogo            db '                                                            ',13,10
							db ' __________________________________________________________ ',13,10
                            db ' |                                                        |',13,10
							db ' |                                                        |',13,10
							db ' |                                                        |',13,10
                            db ' |                                                        |',13,10
                            db ' |                  -> SOPA DE LETRAS <-                  |',13,10 
                            db ' |                                                        |',13,10
                            db ' |                    ________________                    |',13,10
                            db ' |                    |  1 - Jogar   |                    |',13,10    
                            db ' |                    |  2 - Top 10  |                    |',13,10 
                            db ' |                    |  3 - Sair    |                    |',13,10
                            db ' |                    |______________|                    |',13,10
                            db ' |                                                        |',13,10
                            db ' |                                                        |',13,10
                            db ' |                                                        |',13,10
                            db ' |                                                        |',13,10
                            db ' |                                                        |',13,10
                            db ' |                                                        |',13,10
                            db ' |________________________________________________________|',13,10,'$'
		
		Car			db	32	; Guarda um caracter do Ecran 
		Cor			db	7	; Guarda os atributos de cor do caracter
		corPintar   db  30
		POSy		db	3	; a linha pode ir de [1 .. 25]
		POSx		db	3	; POSx pode ir [1..80]	
		
		POSxerrado	db 2
		POSyerrado	db 20
		;mudar consoante nivel
		POSxstringaencontrar db 0
		POSystringaencontrar db 0
		POSxconstrutor db 0
		POSyconstrutor db 0
		POSxtimer db 0
		POSytimer db 0
		
		POSya			    db	1	
		POSxa			    db	2	
		POScbn  		    db	1	
		POSedn			    db	2	
		
		;mudar consoante nivel
		POSYRiscar 			db 	?
		POSXRiscar 			db 	0
		POSXRiscarlvl		db 	0
		
		POSxPrimLetra		db 	?
		POSyPrimLetra		db 	?
		POSx2Letra		db 	?
		POSy2Letra		db 	?
		POSx3Letra		db 	?
		POSy3Letra		db 	?
		POSx4Letra		db 	?
		POSy4Letra		db 	?
		POSy5Letra		db 	?
		POSx5Letra		db 	?
		POSy6Letra		db 	?
		POSx6Letra		db 	?
		POSy7Letra		db 	?
		POSx7Letra		db 	?
		POSy8Letra		db 	?
		POSx8Letra		db 	?
		POSx9Letra		db 	?
		POSy9Letra		db 	?
		POSx10Letra		db 	?
		POSy10Letra		db 	?
		POSx11Letra		db 	?
		POSy11Letra		db 	?
		
		POSxerro			db ?
		POSyerro			db ?
		
		POSxpontos	db 	?
		POSypontos	db	?
		
		POSxplvras1	db ?
		POSyplvras1	db ?
		POSxcertos db ?
		POSycertos db ?
        
		
		carn			    db  32  ;Guarda um caracter de teste para fazer verificaçoes 
		
		STR12	 		    DB 		"            "	; String para 12 digitos
		DDMMAAAA 		    db		"                     "
		
		Horas			    dw		0				; HORA actual
		Minutos			    dw		0				; minutos actuais
		Segundos		    dw		0				; segundos actuais
		Old_seg			    dw		0				; Guarda os �ltimos segundos que foram lidos
		String_TJ		    db		"    $"
        Timer_Count_down    dw      80
		
		pontos				db 	    "00$",0
		pontoc				db 	    "00$",0
		certos				db 	    "00$",0
		String_NR		    db		"    $"
		nr_palavras 		db  	?
		palavrasenc			db 		0   
		erros				db		48,48,"$"
		vazia 		    	db 		" $", 0
        String_nome  	    db	    "COMPUTADOR$", 0
		String_nome1  	    db	    "ASM$", 0
		String_nome2  	    db	    "MOV$", 0
		String_nome3  	    db	    "PROGRAMACAO$", 0
		String_nome4  	    db	    "TECNOLOGIAS$", 0	
		String_nome5  	    db	    "JOGO$", 0	
		String_nome6	    db	    "LETRAS$", 0	
		String_nome7  	    db	    "SOPA$", 0	
		String_nome8  	    db	    "DEIS$", 0	
		String_nome9  	    db	    "BOOLEAN$", 0	
		String_nome10 	    db	    "FACULDADE$", 0	
		String_nome11  	    db	    "NOTEPAD$", 0	
		String_a_encontrar  db      "             $", 0
		venceu  	    db	    "-->VENCEU<--$", 0	
		derrota  	    db	    "-->PERDEU<--$", 0	
		
		
		Construir_nome  	db	    "0            $", 0
		aux				  	db	    "0            $", 0
        Dim_nome		    dw		5	; Comprimento do Nome
		indice_nome		    dw		0	; indice que aponta para Construir_nome
		
dseg    ends


cseg    segment para public 'code'
		assume  cs:cseg, ds:dseg


;########################################################################
goto_xy	macro	POSx,POSy	; coloca o cursos na posição (POSx,POSy)
		mov		ah,02h
		mov		bh,0		; numero da página
		mov		dl,POSx
		mov		dh,POSy
int		10h
endm


;########################################################################
; MOSTRA - Faz o display de uma string terminada em $

MOSTRA MACRO STR 
	MOV AH,09H
	LEA DX,STR 
INT 21H
ENDM

;########################################################################
;ROTINA PARA APAGAR ECRAN - Escreve o carecter SPACE em todas as posições do Ecran

apaga_ecran	proc
		xor		bx,bx
		mov		cx,25*80
		
apaga:	mov		byte ptr es:[bx],' '	; Caracter SPACE
		mov		byte ptr es:[bx+1],7	; Caracteristicas de COR
		inc		bx
		inc 	bx
		loop	apaga
		ret
apaga_ecran	endp


;########################################################################
; LE UMA TECLA	 
; Parametros de saida: (al, ah);
; al - código ta tecla premida
; ah=0 => caracter normal ; ah=1 => Tecla Extendida (cursor, F1, F2, etc.)

LE_TECLA	PROC
sem_tecla:
		call Trata_Horas
		mov		ah,0bh
		int		21h
		cmp al,0
		je	sem_tecla
		mov		ah,08h
		int		21h
		mov		ah,0
		cmp		al,0
		jne		SAI_TECLA
		mov		ah, 08h
		int		21h
		mov		ah,1
SAI_TECLA:	RET
LE_TECLA	endp


;########################################################################
; Assinala caracter no ecran	

assinala_P	PROC
CICLO:	
		goto_xy	POSx,POSy	; Vai para nova posição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al		; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah		; Guarda a cor que está na posição do Cursor

     	goto_xy	57,0		
		mov		ah, 02h		
	 	mov		dl, Car	
		int		21H			
	
		goto_xy	POSx,POSy	; Vai para posição do cursor
	
LER_SETA:	
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND
		CMP 	AL, 27	; ESCAPE para sair do Programa
		JE		FIM
		CMP		AL, 13	; ENTER para alterar a cor do caracter na posicão do cursor
		je		ASSINALA
		jmp		LER_SETA
		
ESTEND:	cmp 	al,48h
		jne		BAIXO
		call	up	; Cima
		jmp		CICLO

BAIXO:	cmp		al,50h
		jne		ESQUERDA
		call	down	;Baixo
		jmp		CICLO

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		call 	left	;Esquerda
		jmp		CICLO

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA 
		call	right	;Direita
		jmp		CICLO

ASSINALA:
		mov ah,08h
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		int  10h            ; le caracter e atributos
		cmp ah,corPintar
		je CICLO
		
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)
		not		bl			; altera a cor
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     ; AH = 09 
		mov		al, car		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position
		call COMPARA
		jmp		CICLO
fim:	
		RET
assinala_P	endp


COMPARA proc
		cmp Construir_nome[0],'0';primeira vez logo esta limpo
		je ciclo1;é a primeira letra
		jne ciclo2;nao é a primeira letra
ciclo1:
		xor bp,bp
		xor si,si
		
	
		
  		cmp al,String_nome[si]
 		je com
		cmp al,String_nome1[si]
 		je asm
		cmp al,String_nome2[si]
 		je movp
		cmp al,String_nome3[si]
 		je pro
		cmp al,String_nome4[si]
 		je tec
		cmp al,String_nome5[si]
		je jogo
		cmp al,String_nome6[si]
 		je let
		cmp al,String_nome7[si]
 		je sopa
		cmp al,String_nome8[si]
 		je deis
		cmp al,String_nome9[si]
 		je bol
		cmp al,String_nome10[si]
 		je fac
		cmp al,String_nome11[si]
 		je notep

		
		
		mov Construir_nome[bp],'0'
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],'$'
		mov String_a_encontrar[bp],'$'
		xor bp,bp
		xor si,si ;motivo de anterior erro 

		;descelenionar
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)
		not		bl			; altera a cor
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     ; AH = 09 
		mov		al, car		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position
		
		;incremente erro
		cmp erros[1],57
		je  sigat
		jne incrt
		goto_xy POSxerro,POSyerro
		MOSTRA erros
		goto_xy 0,0
		jmp return
		
	incrt:
		inc erros[1]
		goto_xy POSxerro,POSyerro
		MOSTRA erros
		goto_xy 0,0
		jmp return
	sigat:
		mov erros[1],48
		inc erros[0]
		goto_xy POSxerro,POSyerro
		MOSTRA erros
		goto_xy 0,0
		
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
		
		
		jmp return

com:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,3
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	
	palavraaencontrar:
		mov al,String_nome[si]
		mov String_a_encontrar[si],al
		cmp String_nome[si],'$'
		jne incrementa
		jmp final
		incrementa:
			inc si
			jmp palavraaencontrar
	final:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
asm:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al 
	xor si,si   
	mov POSYRiscar,4
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar1:
		mov al,String_nome1[si]
		mov String_a_encontrar[si],al
		cmp String_nome1[si],'$'
		jne incrementa1
		jmp final1
		incrementa1:
			inc si
			jmp palavraaencontrar1
	final1:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
movp:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,5
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar2:
		mov al,String_nome2[si]
		mov String_a_encontrar[si],al
		cmp String_nome2[si],'$'
		jne incrementa2
		jmp final2
		incrementa2:
			inc si
			jmp palavraaencontrar2
	final2:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
pro:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,6
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar3:
		mov al,String_nome3[si]
		mov String_a_encontrar[si],al
		cmp String_nome3[si],'$'
		jne incrementa3
		jmp final3
		incrementa3:
			inc si
			jmp palavraaencontrar3
	final3:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
tec:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,7
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar4:
		mov al,String_nome4[si]
		mov String_a_encontrar[si],al
		cmp String_nome4[si],'$'
		jne incrementa4
		jmp final4
		incrementa4:
			inc si
			jmp palavraaencontrar4
	final4:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
jogo:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,8
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar5:
		mov al,String_nome5[si]
		mov String_a_encontrar[si],al
		cmp String_nome5[si],'$'
		jne incrementa5
		jmp final5
		incrementa5:
			inc si
			jmp palavraaencontrar5
	final5:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
let:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,9
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar6:
		mov al,String_nome6[si]
		mov String_a_encontrar[si],al
		cmp String_nome6[si],'$'
		jne incrementa6
		jmp final6
		incrementa6:
			inc si
			jmp palavraaencontrar6
	final6:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
sopa:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,10
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar7:
		mov al,String_nome7[si]
		mov String_a_encontrar[si],al
		cmp String_nome7[si],'$'
		jne incrementa7
		jmp final7
		incrementa7:
			inc si
			jmp palavraaencontrar7
	final7:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
deis:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,11
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar8:
		mov al,String_nome8[si]
		mov String_a_encontrar[si],al
		cmp String_nome7[si],'$'
		jne incrementa8
		jmp final8
		incrementa8:
			inc si
			jmp palavraaencontrar8
	final8:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
bol:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,12
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar9:
		mov al,String_nome9[si]
		mov String_a_encontrar[si],al
		cmp String_nome9[si],'$'
		jne incrementa9
		jmp final9
		incrementa9:
			inc si
			jmp palavraaencontrar9
	final9:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
fac:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,13
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar10:
		mov al,String_nome10[si]
		mov String_a_encontrar[si],al
		cmp String_nome10[si],'$'
		jne incrementa10
		jmp final10
		incrementa10:
			inc si
			jmp palavraaencontrar10
	final10:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return
notep:
	mov Construir_nome[si],al
	;guardar posicao na lista e no tabuleiro e a palavra a encontra
	xor al,al
	xor si,si
	mov POSYRiscar,14
	mov al,POSx
	mov POSxPrimLetra,al
	xor al,al
	mov al,POSy
	mov POSyPrimLetra,al
	
	palavraaencontrar11:
		mov al,String_nome11[si]
		mov String_a_encontrar[si],al
		cmp String_nome11[si],'$'
		jne incrementa11
		jmp final11
		incrementa11:
			inc si
			jmp palavraaencontrar11
	final11:
		xor al,al
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		xor si,si
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
	jmp return

	
ciclo2:
	;prim letra ja foi add
	inc si
	mov Construir_nome[si],al
	;comparar com a palavra[si] a encontrar
	;se sim escreve a palavra riscada na posicao guardada da lista
	;se nao escreve a palavra no lugar do tabuleiro
	;chama macro compara o string a encontrar e o contruir nome
	;caso == mete no palavra a encontrar '0$' e apaga o construir nome
	;risca a palavra guardando o indice dela
	;caso negativo continua
	;fazer um evento que com a tecla back space apaga e desseleciona
	
	Goto_xy POSxconstrutor, POSyconstrutor
	MOSTRA Construir_nome
	
	
	teste:
		mov al,String_a_encontrar[si]
		cmp Construir_nome[si],al
		je equal
		jne errado
	equal:
		cmp si,1
		je dois
		jne prim
				dois:
				mov al,POSx
				mov POSx2Letra,al
				xor al,al
				mov al,POSy
				mov POSy2Letra,al
				jmp senao
		prim:
		cmp si,2
		je tres
		jne segu
				tres:
				mov al,POSx
				mov POSx3Letra,al
				xor al,al
				mov al,POSy
				mov POSy3Letra,al
				jmp senao
		segu:
		cmp si,3
		je quatro
		jne ter
				quatro:
				mov al,POSx
				mov POSx4Letra,al
				xor al,al
				mov al,POSy
				mov POSy4Letra,al
				jmp senao
		ter:
		cmp si,4
		je cinco
		jne quar
				cinco:
				mov al,POSx
				mov POSx5Letra,al
				xor al,al
				mov al,POSy
				mov POSy5Letra,al
				jmp senao
		quar:
		cmp si,5
		je seis
		jne qui
				seis:
				mov al,POSx
				mov POSx6Letra,al
				xor al,al
				mov al,POSy
				mov POSy6Letra,al
				jmp senao
		qui:
		cmp si,6
		je setep
		jne sex
				setep:
				mov al,POSx
				mov POSx7Letra,al
				xor al,al
				mov al,POSy
				mov POSy7Letra,al
				jmp senao
		sex:
		cmp si,7
		je oito
		jne set
				oito:
				mov al,POSx
				mov POSx8Letra,al
				xor al,al
				mov al,POSy
				mov POSy8Letra,al
				jmp senao
		set:
		cmp si,8
		je nove
		jne oit
				nove:
				mov al,POSx
				mov POSx9Letra,al
				xor al,al
				mov al,POSy
				mov POSy9Letra,al
				jmp senao
		oit:
		cmp si,9
		je dez
		jne nov
				dez:
				mov al,POSx
				mov POSx10Letra,al
				xor al,al
				mov al,POSy
				mov POSy10Letra,al
				jmp senao
		nov:
		cmp si,10
		je onze
				onze:
				mov al,POSx
				mov POSx11Letra,al
				xor al,al
				mov al,POSy
				mov POSy11Letra,al
				jmp senao

		senao:
		;pintar a primeira letra
		Goto_xy POSxPrimLetra,POSyPrimLetra
		mov		bl, corPintar		; BL = character attribute (text) foreground color (graphics)	
		mov		corPintar, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[0]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position
		
		;pintar a letra atual
		Goto_xy POSx,POSy
		mov		bl, corPintar		; BL = character attribute (text) foreground color (graphics)
		mov		corPintar, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[si]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position
		
		inc si

		cmp String_a_encontrar[si],'$';ver se ja terminou
		je certo
		jne auxiliar
	auxiliar:
		dec si
		jmp return
		
	certo:

	;limpa posicoes das palavras
		mov POSxPrimLetra,0
		mov POSyPrimLetra,0
		mov POSx2Letra,0
		mov POSy2Letra,0
		mov POSx3Letra,0
		mov POSy3Letra,0
		mov POSx4Letra,0
		mov POSy4Letra,0
		mov POSx5Letra,0
		mov POSy5Letra,0
		mov POSx6Letra,0
		mov POSy6Letra,0
		mov POSx7Letra,0
		mov POSy7Letra,0
		mov POSx8Letra,0
		mov POSy8Letra,0
		mov POSx9Letra,0
		mov POSy9Letra,0
		mov POSx10Letra,0
		mov POSy10Letra,0
		mov POSx11Letra,0
		mov POSy11Letra,0
	
	;riscar na lista
	xor bp,bp
	pintar:
		Goto_xy POSXRiscar,POSYRiscar
		mov		bl, corPintar		; BL = character attribute (text) foreground color (graphics)
		mov		corPintar, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[bp]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position
			
		inc bp
		
		
		cmp String_a_encontrar[bp],'$'
		jne volta
		je continua
		volta:
			INC POSXRiscar
			jmp pintar
		continua:
			xor al,al 
			mov al,POSXRiscarlvl
			mov POSXRiscar,al
			
			
			
	
	
		xor al,al
		xor bp,bp
		mov Construir_nome[bp],'0'
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],'$'
		mov String_a_encontrar[bp],'$'
		xor bp,bp
		
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
			
			
		add Timer_Count_down,5
		cmp certos[1],"9"
		je aqui
		inc certos[1]
	xd:	
		inc palavrasenc
        add pontos[1],5
        cmp pontos[1],57
        jae superior
		mov ah,nr_palavras
		cmp palavrasenc,ah
        je ganhou
        jmp mostrapontos
		
	aqui:
		mov certos[1],"0"
		inc certos[0]
		jmp xd

    superior:
        mov pontos[1],48
        inc pontos[0]
		mov ah,nr_palavras
		cmp palavrasenc,ah
        je ganhou

    mostrapontos:
		GOTO_XY POSxcertos,POSycertos
        Mostra certos
        GOTO_XY POSxpontos,POSypontos
        Mostra pontos
        jmp return

    ganhou:
		goto_xy 0,0
		call apaga_ecran
		
	pose:
		goto_xy 0,0
        mov     bx,4
        call    imp_Ficheiro
		GOTO_XY 29, 8
		MOSTRA pontos
		GOTO_XY 29,13
		MOSTRA erros
		GOTO_XY 24,4
		MOSTRA venceu
		
		goto_xy 0,0
		mov     ah, 1
        int     21h
		CMP 	AL, '1'
		je menu
		jne ganhou

				
	errado:
		Goto_xy POSxPrimLetra,POSyPrimLetra
		mov		bl, cor	; BL = character attribute (text) foreground color (graphics)
		not		bl
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     ; AH = 09 
		mov		al, String_a_encontrar[0]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx2Letra,POSy2Letra
		mov		bl, cor	; BL = character attribute (text) foreground color (graphics)
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     ; AH = 09 
		mov		al, String_a_encontrar[1]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx3Letra,POSy3Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[2]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx4Letra,POSy4Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[3]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx5Letra,POSy5Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[4]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx6Letra,POSy6Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[5]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx7Letra,POSy7Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[6]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx8Letra,POSy8Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[7]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx9Letra,POSy9Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[8]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx10Letra,POSy10Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[9]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position

		Goto_xy POSx11Letra,POSy11Letra
		mov		bl, cor		; BL = character attribute (text) foreground color (graphics)	
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     		; AH = 09 
		mov		al, String_a_encontrar[10]		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position
	
		Goto_xy POSx,POSy
		mov		bl, cor	; BL = character attribute (text) foreground color (graphics)
		mov		cor, bl		; altera a cor
		mov 	ah, 09h     ; AH = 09 
		mov		al, car		; AL = ASCII character to write
		mov		bh, 0		; BH = display page  (or mode 13h, background pixel value)
		mov		cx, 1		; CX = count of characters to write (CX >= 1)
		int		10h			; INT 10,9 - Write Character and Attribute at Cursor Position
		
	
		mov POSxPrimLetra,0
		mov POSyPrimLetra,0
		mov POSx2Letra,0
		mov POSy2Letra,0
		mov POSx3Letra,0
		mov POSy3Letra,0
		mov POSx4Letra,0
		mov POSy4Letra,0
		mov POSx5Letra,0
		mov POSy5Letra,0
		mov POSx6Letra,0
		mov POSy6Letra,0
		mov POSx7Letra,0
		mov POSy7Letra,0
		mov POSx8Letra,0
		mov POSy8Letra,0
		mov POSx9Letra,0
		mov POSy9Letra,0
		mov POSx10Letra,0
		mov POSy10Letra,0
		mov POSx11Letra,0
		mov POSy11Letra,0

		xor bp,bp
		mov Construir_nome[bp],'0'
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '	
		inc bp
		mov Construir_nome[bp],' '
		mov String_a_encontrar[bp],' '
		inc bp
		mov Construir_nome[bp],'$'
		mov String_a_encontrar[bp],'$'
		xor bp,bp
		
		
		Goto_xy POSxstringaencontrar, POSystringaencontrar
		MOSTRA String_a_encontrar
		Goto_xy POSxconstrutor, POSyconstrutor
		MOSTRA Construir_nome
		
		
		cmp erros[1],57
		je  siga
		jne incr
		goto_xy POSxerro,POSyerro
		MOSTRA erros
		goto_xy 0,0
		jmp return
		
	incr:
		inc erros[1]
		goto_xy POSxerro,POSyerro
		MOSTRA erros
		goto_xy 0,0
		jmp return
	siga:
		mov erros[1],48
		inc erros[0]
		goto_xy POSxerro,POSyerro
		MOSTRA erros
		goto_xy 0,0
		jmp return
		
return:
    ret
COMPARA endp


;######################################################################## Lab confirmation
up proc
	mov al, POSy ; guarda POSy numa var de test
    mov POScbn, al
    dec POScbn ; ando com a var de teste

    goto_xy	POSx,POScbn ; coloco as POS no novo local
    mov 	ah, 08h
    mov		bh,0		; numero da página
    int		10h
    mov		carn, al	; Guarda o Caracter que está na posição do Cursor numa var de teste   
    cmp carn, 177  ; 
    je return
	  
    mov   al, POScbn ; Reset na posiçao do cursor teste
    mov   POSy,al
    mov   al, POSya ; Reset na POS de teste
    mov   POScbn,al
    jmp return

return:
    ret
up endp

down proc
    mov al, POSy ; guarda POSy numa var de test
    mov POScbn, al
    inc POScbn ; ando com a var de teste

    goto_xy	POSx,POScbn ; coloco as POS no novo local
    mov 	ah, 08h
    mov		bh,0		; numero da página
    int		10h
    mov		carn, al	; Guarda o Caracter que está na posição do Curso numa var de teste
    cmp carn, 177  ; comparo o caracter de teste com as paredes. Se for parede salta fora e não mexe o cursor
    je 	return
	  
    mov   al, POScbn ; Reset na posiçao do cursor teste
    mov   POSy,al
    mov   al, POSya ; Reset na POS de teste
    mov   POScbn,al
    jmp return
return:
    ret
down endp

right proc
 	mov al, POSx ; guarda POSy numa var de test
    mov POSedn, al
    inc POSedn ; ando com a var de teste

    goto_xy	POSedn,POSy ; coloco as POS no novo local
    mov 	ah, 08h
    mov		bh,0		; numero da página
    int		10h
    mov		carn, al	; Guarda o Caracter que está na posição do Curso numa var de teste
    cmp carn, 177  ; comparo o caracter de teste com as paredes. Se for parede salta fora e não mexe o cursor
    je 	return
	  
    mov   al, POSedn ; Reset na posiçao do cursor teste
    mov   POSx,al
	inc		POSx		
    mov   al, POSxa ; Reset na POS de teste
    mov   POSedn,al
    jmp return
return:
	ret
right endp

left proc
mov al, POSx ; guarda POSy numa var de test
    mov POSedn, al
    dec POSedn ; ando com a var de teste

    goto_xy	POSedn,POSy ; coloco as POS no novo local
    mov 	ah, 08h
    mov		bh,0		; numero da página
    int		10h
    mov		carn, al	; Guarda o Caracter que está na posição do Curso numa var de teste
    cmp carn, 177  ; comparo o caracter de teste com as paredes. Se for parede salta fora e não mexe o cursor
    je 	return
	  
    mov   al, POSedn ; Reset na posiçao do cursor teste
    mov   POSx,al
	dec		POSx
    mov   al, POSxa ; Reset na POS de teste
    mov   POSedn,al
    jmp return
return:
	ret
left endp

;########################################################################
;ROTINA PARA IMPRIMIR FICHEIRO NO ECRAN

imp_Ficheiro	proc

		

;abre ficheiro
		mov     ah,3dh
        mov     al,0

        cmp     bx,0
        je        jogar
		cmp 	bx,1
        je     imptop10
		cmp 	bx,2
        je     nivelum
		cmp 	bx,3
        je     niveldois
		cmp 	bx,5
		je		plvrnivel1
		cmp 	bx,6
		je		plvrnivel2
		jne 	ganhou

    imptop10:
        lea     dx,FichTOP10
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo
		
	plvrnivel1:
		mov     ah,3dh
        mov     al,0
        lea     dx,PALAVRAS1
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo2
		
	plvrnivel2:
		mov     ah,3dh
        mov     al,0
        lea     dx,PALAVRAS2
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo3
    jogar:
        lea     dx,FichDif
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo
		
	ganhou:
		mov Timer_Count_down,0
        lea     dx,FichGanhou
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo
		mov 	si,2
		jmp 	sai

	niveldois:
		lea     dx,Fich2
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo

	nivelum:
		lea     dx,Fich
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo
		

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai
		
	ler_ciclo2:
		mov ah,03h
		mov bh,0
		int 10h
		cmp POSyplvras1,dh
		jne dife
		je testa
	dife:
		mov ah,03h
		mov bh,0
		int 10h
		mov POSyplvras1,dh
		mov POSxplvras1,30
		goto_xy POSxplvras1,POSyplvras1
		jmp testa
		
	testa:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo2
		
		
	ler_ciclo3:
		mov ah,03h
		mov bh,0
		int 10h
		cmp POSyplvras1,dh
		jne dife2
		je testa2
	dife2:
		mov ah,03h
		mov bh,0
		int 10h
		mov POSyplvras1,dh
		mov POSxplvras1,64
		goto_xy POSxplvras1,POSyplvras1
		jmp testa2
		
	testa2:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo3
		

ler_ciclo:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h
		
sai:
		
		goto_xy 0,0
		ret
imp_Ficheiro	endp


Ler_TEMPO PROC	
 
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		MOV AH, 2CH             ; Buscar a hORAS
		INT 21H                 
		
		XOR AX,AX
		MOV AL, DH              ; segundos para al
		mov Segundos, AX		; guarda segundos na variavel correspondente
		
		XOR AX,AX
		MOV AL, CL              ; Minutos para al
		mov Minutos, AX         ; guarda MINUTOS na variavel correspondente
		
		XOR AX,AX
		MOV AL, CH              ; Horas para al
		mov Horas,AX			; guarda HORAS na variavel correspondente
 
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
Ler_TEMPO   ENDP

Trata_Horas PROC

		PUSHF
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX		

		CALL 	Ler_TEMPO				; Horas MINUTOS e segundos do Sistema
		
		MOV		AX, Segundos
		cmp		AX, Old_seg			; VErifica se os segundos mudaram desde a ultima leitura
		je		fim_horas			; Se a hora não mudou desde a última leitura sai.
		mov		Old_seg, AX			; Se segundos são diferentes actualiza informação do tempo 
        
        dec     Timer_Count_down    ; retira 1 ao timer
        mov     ax,Timer_count_down
        mov     bl, 10
        div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
        mov     String_TJ[0], al
        mov     String_TJ[1], ah
        GOTO_XY POSxtimer,POSytimer
        Mostra String_TJ
        cmp    Timer_count_down, 0
        je    	perdeu  
        
		
		mov 	ax,Horas
		MOV		bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			; 
		MOV 	STR12[1],ah
		MOV 	STR12[2],'h'		
		MOV 	STR12[3],'$'
		GOTO_XY 2,0
		MOSTRA STR12 		
        
		mov 	ax,Minutos
		MOV 	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			; 
		MOV 	STR12[1],ah
		MOV 	STR12[2],'m'		
		MOV 	STR12[3],'$'
		GOTO_XY	6,0
		MOSTRA	STR12 		
		
		mov 	ax,Segundos
		MOV 	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			; 
		MOV 	STR12[1],ah
		MOV 	STR12[2],'s'		
		MOV 	STR12[3],'$'
		GOTO_XY	10,0
		MOSTRA	STR12 		
        
		CALL 	HOJE				; Data de HOJE
		MOV 	al ,DDMMAAAA[0]	
		MOV 	STR12[0], al	
		MOV 	al ,DDMMAAAA[1]	
		MOV 	STR12[1], al	
		MOV 	al ,DDMMAAAA[2]	
		MOV 	STR12[2], al	
		MOV 	al ,DDMMAAAA[3]	
		MOV 	STR12[3], al	
		MOV 	al ,DDMMAAAA[4]	
		MOV 	STR12[4], al	
		MOV 	al ,DDMMAAAA[5]	
		MOV 	STR12[5], al	
		MOV 	al ,DDMMAAAA[6]	
		MOV 	STR12[6], al	
		MOV 	al ,DDMMAAAA[7]	
		MOV 	STR12[7], al	
		MOV 	al ,DDMMAAAA[8]	
		MOV 	STR12[8], al
		MOV 	al ,DDMMAAAA[9]	
		MOV 	STR12[9], al		
		MOV 	STR12[10],'$'
		GOTO_XY	68,0
		MOSTRA	STR12 	

					
				
fim_horas:		
		goto_xy	POSx,POSy			; Volta a colocar o cursor onde estava antes de actualizar as horas
		
		POPF
		POP DX		
		POP CX
		POP BX
		POP AX
		RET		

perdeu:
		goto_xy 0,0
		call apaga_ecran
        mov     bx,4
        call    imp_Ficheiro
		GOTO_XY 29, 8
		MOSTRA pontos
		GOTO_XY 29,13
		MOSTRA erros
		GOTO_XY 24,4
		MOSTRA derrota
		goto_xy 0,0
		mov     ah, 1
        int     21h
		CMP 	AL, '1'
		je menu
		jne perdeu
 		    
						
Trata_Horas ENDP

;######################################################################## HORAS/timer
HOJE PROC	

		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSH SI
		PUSHF
		
		MOV AH, 2AH             ; Buscar a data
		INT 21H                 
		PUSH CX                 ; Ano-> PILHA
		XOR CX,CX              	; limpa CX
		MOV CL, DH              ; Mes para CL
		PUSH CX                 ; Mes-> PILHA
		MOV CL, DL				; Dia para CL
		PUSH CX                 ; Dia -> PILHA
		XOR DH,DH                    
		XOR	SI,SI
; DIA ------------------ 
; DX=DX/AX --- RESTO DX   
		XOR DX,DX               ; Limpa DX
		POP AX                  ; Tira dia da pilha
		MOV CX, 0               ; CX = 0 
		MOV BX, 10              ; Divisor
		MOV	CX,2
DD_DIV:                         
		DIV BX                  ; Divide por 10
		PUSH DX                 ; Resto para pilha
		MOV DX, 0               ; Limpa resto
		loop dd_div
		MOV	CX,2
DD_RESTO:
		POP DX                  ; Resto da divisao
		ADD DL, 30h             ; ADD 30h (2) to DL
		MOV DDMMAAAA[SI],DL
		INC	SI
		LOOP DD_RESTO            
		MOV DL, '/'             ; Separador
		MOV DDMMAAAA[SI],DL
		INC SI
; MES -------------------
; DX=DX/AX --- RESTO DX
		MOV DX, 0               ; Limpar DX
		POP AX                  ; Tira mes da pilha
		XOR CX,CX               
		MOV BX, 10				; Divisor
		MOV CX,2
MM_DIV:                         
		DIV BX                  ; Divisao or 10
		PUSH DX                 ; Resto para pilha
		MOV DX, 0               ; Limpa resto
		LOOP MM_DIV
		MOV CX,2 
MM_RESTO:
		POP DX                  ; Resto
		ADD DL, 30h             ; SOMA 30h
		MOV DDMMAAAA[SI],DL
		INC SI		
		LOOP MM_RESTO
		
		MOV DL, '/'             ; Character to display goes in DL
		MOV DDMMAAAA[SI],DL
		INC SI
 
;  ANO ----------------------
		MOV DX, 0               
		POP AX                  ; mes para AX
		MOV CX, 0               ; 
		MOV BX, 10              ; 
 AA_DIV:                         
		DIV BX                   
		PUSH DX                 ; Guarda resto
		ADD CX, 1               ; Soma 1 contador
		MOV DX, 0               ; Limpa resto
		CMP AX, 0               ; Compara quotient com zero
		JNE AA_DIV              ; Se nao zero
AA_RESTO:
		POP DX                  
		ADD DL, 30h             ; ADD 30h (2) to DL
		MOV DDMMAAAA[SI],DL
		INC SI
		LOOP AA_RESTO
		POPF
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
HOJE   ENDP 

;########################################################################



;########################################################################


PONTO PROC

		PUSHF
		PUSH AX
		PUSH BX
		
        inc pontos[0]
        GOTO_XY POSxpontos,POSypontos
        Mostra pontos[0]
		JMP RETURN
		return:
			RET

PONTO		endp

Main    Proc
        mov     ax,dseg
        mov     ds,ax
		mov		ax,0B800h
		mov		es,ax
		
		menu proc
		;apaga o conteudo no ecra
        call apaga_ecran
        goto_xy 0,0

        lea     dx, menujogo
        mov     ah, 09h
        int     21h

        mov     ah, 1
        int     21h
		
		;le a tecla premida e redireciona ao nivel selecionado ou volta ao menu
        cmp     al,'1'
        je      inicio
		cmp     al,'2'
        je      top10
        cmp     al,'3'
        je      sair
		jmp menu
      
        menu endp
		
        mov     ah,4ch
        int     21h
Main    endp

	inicio:
		;apaga o conteudo no ecra
		call    apaga_ecran
		
		;imprime o ficheiro DIF.txt no ecra
  		goto_xy        0,0
		mov 		bx,0
  		call	imp_Ficheiro
		goto_xy	0, 0
		;reseta os valores das variaveis necessarias para começar um jogo do zero
		mov     ah, 1
        int     21h
		mov palavrasenc,0
		mov erros[0],48
		mov erros[1],48
		mov erros[2],'$'
		mov pontos[0],'0'
		mov pontos[1],'0'
		mov pontos[2],'$'
		mov certos[0],'0'
		mov certos[1],'0'
		mov certos[2],'$'
		mov POSx, 3
        mov POSY, 3
		
		;le a tecla premida e redireciona ao nivel selecionado ou volta ao menu
        cmp     al,'1'
        je      menu
		cmp     al,'2'
        je      nivel1
        cmp     al,'3'
        je      nivel2
		jmp inicio

	nivel1:
	;define os valores das variaveis consoante o nivel 1
		mov nr_palavras,8
		mov POSxerro,52
		mov POSyerro,11
		mov POSxpontos,53
		mov POSypontos,5
		mov POSXRiscarlvl , 30
		mov POSXRiscar , 30
		mov POSxstringaencontrar,45
		mov POSystringaencontrar , 9
		mov POSxconstrutor , 45
		mov POSyconstrutor , 7
		mov POSxtimer , 52
		mov POSytimer , 3
		mov POSxplvras1,30
		mov POSyplvras1,3
		mov POSxcertos,53
		mov POSycertos,13
		
		;apaga o cnteudo do ecra e define o tempo para 80 segundos
		mov Timer_Count_down,80
		call        apaga_ecran
		
		;imprime o fichiro dados.txt 
  		goto_xy        0,0
		mov 		bx,2
  		call	imp_Ficheiro
		
		;imprime a lista de palavras presentes no ficheiro PLVR1.txt
		goto_xy 	POSxplvras1,POSyplvras1
		mov 		bx,5
  		call	imp_Ficheiro
		
		;chama a metodos que trata as funçoes que : 
		;movem o cursor,impedindo sair do tabuleiro
		;implementam os procedimentos responsaveis pelo timer
		;tornam possivel selecionar as varias letras
		;comparam as letras escolhidas com as palavras da lista
		;riscam as palavras acertadas no tabuleiro e na lista
		;contam o numero de letras erradas e de palavras acertadas
		call	assinala_P
		mov     ah, 1
        int     21h
		cmp     al,27
		je sair

	nivel2:
		;define os valores das variasveis consoante o nivel 2
		mov nr_palavras,12
		mov POSxpontos,11
		mov POSypontos,21
		mov POSxerro,22
		mov POSyerro,19
		mov POSXRiscarlvl , 64
		mov POSxstringaencontrar,64
		mov POSystringaencontrar , 17
		mov POSxconstrutor , 64
		mov POSyconstrutor , 16
		mov POSxtimer , 10
		mov POSytimer , 19
		mov POSXRiscar 	, 	64
		mov POSxplvras1,64
		mov POSyplvras1,3
		mov POSxcertos,12
		mov POSycertos,23
		
		;apaga o cnteudo do ecra e define o tempo para 95 segundos
		mov Timer_Count_down,95
		call        apaga_ecran
		
		;imprime o fichiro nivel2.txt
  		goto_xy        0,0
		mov 		bx,3
  		call	imp_Ficheiro
		
		;imprime a lista de palavras presentes no ficheiro PLVR2
		goto_xy 	POSxplvras1,POSyplvras1
		mov 		bx,6
  		call	imp_Ficheiro
		
		;chama a funçao que trata as funçoes que : 
		;movem o cursor,impedindo sair do tabuleiro
		;implementam os procedimentos responsaveis pelo timer
		;tornam possivel selecionar as varias letras
		;comparam as letras escolhidas com as palavras da lista
		;riscam as palavras acertadas no tabuleiro e na lista
		;contam o numero de letras erradas e de palavras acertadas
		call	assinala_P
		mov     ah, 1
        int     21h
		cmp     al,'1'
		je sair
		
	sair:
		goto_xy 0,20
		MOSTRA vazia
		mov     ah,4ch
        int     21h
		
	top10:
		;apaga o ecra e mostra o TOP10
		call        apaga_ecran
  		goto_xy        0,0
		mov 	bx,1
		;imprime ficheiro com o layout do TOP10
		call	imp_Ficheiro
		mov     ah, 1
        int     21h
		;ao premir 1 vola ao menu inicial
		cmp     al,'1'
        je      menu
		jne 	top10
		
cseg	ends
end     Main           

