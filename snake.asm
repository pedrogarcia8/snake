;GRUPO: 
;
; BRUNO 
; JADE
; PEDRO 
; THIAGO
; ORGANIZAÇÃO DE COMPUTADORES DIGITAIS - SIMÕES
; 
; SNAKE


SnakePos:  	var #500 ; tamanho MAXIMO da snake
SnakeSize:	var #1
Dir:		var #1 ; 0-direita, 1-baixo, 2-esquerda, 3-cima

FoodPos:	var #1
FoodStatus:	var #1
Score: var #1
Stage: var #1
Speed: var #1
FlagTiro: var #1
posAtualTiro	: var #1
posAntTiro	: var #1


GameOverMessage: 	string " FIM DE JOGO! "
EraseGameOver:		string "           "
RestartMessage:		string " TENTE NOVAMENTE! APERTE 'SPACE' "
EraseRestart:		string "                          "

SuccessMessage: 		string " MUITO BOOOOOOM! "
EraseSuccessMessage: 	string "                 "
NextLevelMessage: 		string " APERTE 'SPACE' E PREPARE-SE "
EraseNextLevelMessage:	string "                               "


; Main
main:
	
	call inicialize_speed
	call inicialize_flag_e_tiro
	call Initialize
	
	
	loadn R1, #tela1Linha0	; Endereco da primeira linha do ambiente do jogo!!
	loadn R2, #0
	call Draw_Stage
	
	
	call inicialize_score	
	call inicialize_stage_number	
	
	loop:
		
		ingame_loop:
			call Draw_Snake
			
			call stage_checker
			
			call Move_Snake
			call Replace_Food
					
			call Delay
				
				
			jmp ingame_loop
		
		GameOver_loop:
			call Restart_Game
		
			jmp GameOver_loop
	
; Funções

stage_checker:
	
	load r3, Stage
	loadn r4, #48
	

	cmp r3,r4
	jeq stage0
	
	inc r4
	
	cmp r3, r4
	jeq stage1
	
	inc r4
	
	cmp r3, r6
	jeq stage2
	
	stage0:
	call Dead_Snake_0	
	jmp fim

	stage1:
	call Dead_Snake_1
	jmp fim
	
	stage2:
	call Dead_Snake_2
	call Torre
	
	fim:
	rts	

inicialize_score:
	
	loadn r0, #48
	store Score, r0
	
	loadn r1, #9
	load r2, Score
	
	outchar r2, r1
	 
	rts
	
inicialize_stage_number:
	
	loadn r0, #48
	store Stage, r0
	
	loadn r1, #49
	load r2, Stage
	
	outchar r2, r1
	 
	rts

inicialize_speed:
	
	loadn r0, #6000
	store Speed, r0
		 
	rts

inicialize_flag_e_tiro:
	
	loadn r0, #0
	store FlagTiro, r0
		
	loadn r1, #1019
	store posAtualTiro, r1
		
	loadn r2, #1059
	store posAntTiro, r2
				
						 
	rts	
	
Initialize:
		push r0
		push r1
		
		loadn r0, #3
		store SnakeSize, r0
		
		; SnakePos[0] = 460
		loadn 	r0, #SnakePos
		loadn 	r1, #460
		storei 	r0, r1
		
		; SnakePos[1] = 459
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[2] = 458
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[3] = 457
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[4] = -1
		inc 	r0
		loadn 	r1, #0
		storei 	r0, r1
				
		call FirstPrintSnake
		
		loadn r0, #0
		store Dir, r0
		
		pop r1
		pop r0
		
		rts

FirstPrintSnake:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #SnakePos		; r0 = & SnakePos
	loadn r1, #'}'			; r1 = '}'
	loadi r2, r0			; r2 = SnakePos[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop
	
	
	loadn 	r0, #820
	loadn 	r1, #'.'
	outchar r1, r0
	store 	FoodPos, r0
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts
	
EraseSnake:
	push r0
	push r1
	push r2
	push r3
	
	loadn 	r0, #SnakePos		; r0 = & SnakePos
	inc 	r0
	loadn 	r1, #' '			; r1 = ' '
	loadi 	r2, r0			; r2 = SnakePos[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts



Draw_Stage:
	
	push r0	; protege o r0 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para ser usado na subrotina
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina

	loadn R0, #0  	; define a posicao inicial no comeco da tela!
	loadn R3, #40  	; incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor com mudanca de fase
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	

Move_Snake:
	push r0	; Dir / SnakePos
	push r1	; inchar
	push r2 ; local helper
	push r3
	push r4
	
	; Sincronização
	loadn 	r0, #5000
	loadn 	r1, #0
	mod 	r0, r6, r0		; r1 = r0 % r1 (Teste condições de contorno)
	cmp 	r0, r1
	jne Move_End
	; =============
	
	Check_Food:
	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!
	loadn r1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	add r2, r1, r0	; R2 = Tela1Linha0 + posAnt
	loadn r4, #40
	div r3, r0, r4	; R3 = posAnt/40
	add r2, r2, r3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
		load 	r0, FoodPos ; posição da comida
		loadn 	r1, #SnakePos ; posição da snake
		loadi 	r2, r1
		
		cmp r0, r2 ; verificando se a posição da comida é igual a da snake
		jne Spread_Move	
		
		call Increment_score ; chamando função que incrementa a pontuação
		
		load 	r0, SnakeSize
		inc 	r0
		store 	SnakeSize, r0
		
		loadn 	r0, #0
		dec 	r0
		store 	FoodStatus, r0
		
	Spread_Move:
		loadn 	r0, #SnakePos
		loadn 	r1, #SnakePos
		load 	r2, SnakeSize
		
		add 	r0, r0, r2		; r0 = SnakePos[Size]
		
		dec 	r2				; r1 = SnakePos[Size-1]
		add 	r1, r1, r2
		
		loadn 	r4, #0
		
		Spread_Loop:
			loadi 	r3, r1
			storei 	r0, r3
			
			dec r0
			dec r1
			
			cmp r2, r4
			dec r2
			
			jne Spread_Loop	
	
	Change_Dir:
		inchar 	r1
		
		loadn r2, #100	; char r4 = 'd'
		cmp r1, r2
		jeq Move_D
		
		loadn r2, #115	; char r4 = 's'
		cmp r1, r2
		jeq Move_S
		
		loadn r2, #97	; char r4 = 'a'
		cmp r1, r2
		jeq Move_A
		
		loadn r2, #119	; char r4 = 'w'
		cmp r1, r2
		jeq Move_W		
		
		jmp Update_Move
	
		Move_D:
			loadn 	r0, #0
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #2
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Left
			
			store 	Dir, r0
			jmp 	Move_Right
		Move_S:
			loadn 	r0, #1
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #3
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Up
			
			store 	Dir, r0
			jmp 	Move_Down
		Move_A:
			loadn 	r0, #2
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #0
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Right
			
			store 	Dir, r0
			jmp 	Move_Left
		Move_W:
			loadn 	r0, #3
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #1
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Down
			
			store 	Dir, r0
			jmp 	Move_Up
	
	Update_Move:
		load 	r0, Dir
				
		loadn 	r2, #0
		cmp 	r0, r2
		jeq 	Move_Right
		
		loadn 	r2, #1
		cmp 	r0, r2
		jeq 	Move_Down
		
		loadn 	r2, #2
		cmp 	r0, r2
		jeq 	Move_Left
		
		loadn 	r2, #3
		cmp 	r0, r2
		jeq 	Move_Up
		
		jmp Move_End
		
		Move_Right:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			inc 	r1				; r1++
			storei 	r0, r1
			
			jmp Move_End
				
		Move_Down:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			loadn 	r2, #40
			add 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
		
		Move_Left:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			dec 	r1				; r1--
			storei 	r0, r1
			
			jmp Move_End
		Move_Up:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			loadn 	r2, #40
			sub 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
	
	Move_End:
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0

	rts

Torre:
	
	push r1
	push r2
	
	loadn r1, #0
	loadn r2, #1
		
	tiro:		
		
		call MoveTiro
		inc r1
		
		cmp r1, r2
		jne tiro
		
	fim_tiro:
		pop r2
		pop r1
		
	rts


	
;--------------------------------------------------------------------------------------------------------
; espaço para movimentação  do tiro
MoveTiro:
	
	call MoveTiro_RecalculaPos
	call Shot_snake ; para cada vez que o tiro for processado, são feitas verificações para analisar se a snake foi atingida
	call MoveTiro_Apaga
	call Shot_snake
	call MoveTiro_Desenha		
	call Shot_snake
	  
	rts

;--------------------------------------------------------------------------------------------------------
MoveTiro_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4

	load R1, posAtualTiro	
	loadn R2, #40
	sub R1, R1, R2	
	
	load R3, posAtualTiro
	store posAntTiro, R3
	store posAtualTiro, R1 
	
	loadn R4, #' '
	
  MoveTiro_Apaga_Fim:	
	outchar R4, R3	
	
	
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;--------------------------------------------------------------------------------------------------------
	
	
MoveTiro_RecalculaPos:
	push R0
	push R1
	push R2
	
	load R0, posAtualTiro	
	
	loadn R1, #139		
	cmp R0, R1
	jeq MoveTiro_RecalculaPos_Fim
	
	loadn R1, #SnakePos
	loadn R0, #posAtualTiro	
	
	cmp R0, R1	
	jeq MoveTiro_RecalculaPos_Boom
	
	call MoveTiro_Apaga
	
	jmp MoveTiro_RecalculaPos_Fim2
	
  MoveTiro_RecalculaPos_Fim:
  	loadn R1, #'_'
  	loadn R2, #256
  	add R1, R1, R2
  	outchar R1, R0
  	call inicialize_flag_e_tiro
  	call MoveTiro_Apaga
  	
  MoveTiro_RecalculaPos_Fim2:	
	pop R2
	pop R1
	pop R0
	rts
	
  MoveTiro_RecalculaPos_Boom:	
  	
  	pop R2
	pop R1
	pop R0
  	jmp GameOver_Activate
  

  
MoveTiro_Desenha:
	push R0
	push R1
	
	loadn R1, #'|'	; Forma do Tiro
	load R0, posAtualTiro
	outchar R1, R0
	store posAntTiro, R0
	
	pop R1
	pop R0
	rts


Shot_snake:

	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	
	loadn 	r0, #SnakePos
	loadn 	r1, #SnakePos
	load 	r2, SnakeSize
	load 	r5, posAtualTiro
	
	add 	r0, r0, r2		; r0 = SnakePos[Size]

	loadn 	r4, #0
	
	Shot_Loop:
		loadi 	r3, r0
				
		dec r0
		
		cmp r3, r5
		jeq GameOver_Activate
		
		cmp r2, r4
		dec r2
		
		jne Shot_Loop	

	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	rts

	

Increment_score:
	push r0
	push r1
	push r2
	
	loadn r1, #1 ; colocando numero 1 no registrador r1 para somar com a pontuação atual
	
	load r0 , Score ; carregando pontuação atual em r0 
	add r0, r0 , r1

	store Score, r0
	
	loadn r2, #9
	
	outchar r0, r2
	
	loadn r3, #50
	cmp r0, r3	;checa se o score chegou a 7 (55 em ASCII)
	jeq NextLevel
	
	
	pop r2	
	pop r1	
	pop r0	
	 
	rts

Replace_Food:
	push r0
	push r1

	loadn 	r0, #0
	dec 	r0
	load 	r1, FoodStatus
	cmp 	r0, r1
	
	jne Replace_End
	
	loadn r1, #0
	store FoodStatus, r1
	load  r1, FoodPos
	
	load r0, Dir
	
	loadn r2, #0
	cmp r0, r2
	jeq Replace_Right
	
	loadn r2, #1
	cmp r0, r2
	jeq Replace_Down
	
	loadn r2, #2
	cmp r0, r2
	jeq Replace_Left
	
	loadn r2, #3
	cmp r0, r2
	jeq Replace_Up
	
	Replace_Right:
		loadn r3, #355
		add r1, r1, r3
		jmp Replace_Boundaries
	Replace_Down:
		loadn r3, #445
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Left:
		loadn r3, #395
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Up:
		loadn r3, #485
		add r1, r1, r3
		jmp Replace_Boundaries
	
	;caso a comida seja inicialmente calculada para aparecer em uma posicao ja ocupada por uma barreira,
	;a posicao sera recalculada para outra posicao, definida por:
	;Replace_Upper, Replace_Lower, Replace_East ou Replace_West
	;A escolha do Replace sera "aleatoria"
	Replace_Boundaries:
		loadn r2, #160
		cmp r1, r2
		jle Replace_Lower
		
		loadn r2, #1160
		cmp r1, r2
		jgr Replace_Upper
		
		loadn r0, #40
		loadn r3, #1
		mod r2, r1, r0
		cmp r2, r3
		jel Replace_West
		
		loadn r0, #40
		loadn r3, #39
		mod r2, r1, r0
		cmp r2, r3
		jeg Replace_East
		
		loadn r2, #391
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #407
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #408
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #409
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #410
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #411
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #412
		cmp r1, r2
		jeq Replace_Upper

		loadn r2, #432
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #447
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #448
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #449
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #450
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #451
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #452
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #472
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #487
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #488
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #489
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #490
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #491
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #492
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #891
		cmp r1, r2
		jeq Replace_Upper

		loadn r2, #942
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #902
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #903
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #904
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #905
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #906
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #907
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #931
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #942
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #943
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #944
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #945
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #946
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #947
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #971
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #972
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #982
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #983
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #984
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #985
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #986
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #987
		cmp r1, r2
		jeq Replace_Upper

		loadn r2, #1059
		cmp r1, r2
		jeq Replace_East

		loadn r2, #1098
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #1099
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #1100
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #1137
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #1138
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #1139
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #1140
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #1141
		cmp r1, r2
		jeq Replace_Upper
				
		jmp Replace_Update
		
		Replace_Upper:
			loadn r1, #215
			jmp Replace_Update
		Replace_Lower:
			loadn r1, #1035
			jmp Replace_Update
		Replace_East:
			loadn r1, #835
			jmp Replace_Update
		Replace_West:
			loadn r1, #205
			jmp Replace_Update
			
		Replace_Update:
			store FoodPos, r1
			loadn r0, #'.'
			outchar r0, r1
	
	Replace_End:
		pop r1
		pop r0
	
	rts

Dead_Snake_0: ; função para a fase 1
	loadn r0, #SnakePos
	loadi r1, r0
	
	; colidiu na parede direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede de cima
	loadn r2, #160
	cmp r1, r2
	jle GameOver_Activate
	
	; colidiu na parede de baixo
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	call wall_1_check
	call wall_2_check
	
	; colidiu na própria cobra
	Collision_Check:
		load 	r2, SnakeSize
		loadn 	r3, #1
		loadi 	r4, r0			
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Dead_Snake_0_End
	
	GameOver_Activate:
		load 	r0, FoodPos
		loadn 	r1, #' '
		outchar r1, r0
	
		loadn r0, #615
		loadn r1, #GameOverMessage
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #RestartMessage
		loadn r2, #0
		call Imprime
		
		jmp GameOver_loop
	
	Dead_Snake_0_End:
	
	rts

Dead_Snake_1: ; função para a fase 2
	loadn r0, #SnakePos
	loadi r1, r0
	
	; colidiu na parede direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede de cima
	loadn r2, #160
	cmp r1, r2
	jle GameOver_Activate
	
	; colidiu na parede de baixo
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	call box_1_check
	call box_2_check
	call wall_1_check
	
	
	; colidiu na própria cobra
	Collision_Check:
		load 	r2, SnakeSize
		loadn 	r3, #1
		loadi 	r4, r0			; Posição da cabeça
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Dead_Snake_1_End
	
	GameOver_Activate:
		load 	r0, FoodPos
		loadn 	r1, #' '
		outchar r1, r0
	
		loadn r0, #615
		loadn r1, #GameOverMessage
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #RestartMessage
		loadn r2, #0
		call Imprime
		
		jmp GameOver_loop
	
	Dead_Snake_1_End:
	
	rts

Dead_Snake_2: ; função para a fase 3
	loadn r0, #SnakePos
	loadi r1, r0
	
	; colidiu na parede direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Testa condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Testa condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede de cima
	loadn r2, #160
	cmp r1, r2
	jle GameOver_Activate
	
	; colidiu na parede de baixo
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	call turret_check ;verifica se a snake colidiu com a torreta que atira
	call wall_1_check
	call wall_2_check
	
	; colidiu na própria cobra
	Collision_Check:
		load 	r2, SnakeSize
		loadn 	r3, #1
		loadi 	r4, r0			; Posição da cabeça
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Dead_Snake_2_End
	
	
	
	
	
	GameOver_Activate:
		load 	r0, FoodPos
		loadn 	r1, #' '
		outchar r1, r0
	
		loadn r0, #615
		loadn r1, #GameOverMessage
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #RestartMessage
		loadn r2, #0
		call Imprime
		
		jmp GameOver_loop
	
	Dead_Snake_2_End:
	
	rts


box_1_check: ; checa se a snake colidiu com uma das caixas do cenario 1. 
	
	loadn r2, #407
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #408
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #409
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #410
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #411
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #412
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #447
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #452
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #487
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #488
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #489
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #490
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #491
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #492
	cmp r1, r2
	jeq GameOver_Activate
	
	
	rts

box_2_check:
	
	loadn r2, #902
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #903
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #904
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #905
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #906
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #907
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #942
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #947
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #982
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #983
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #984
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #985
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #986
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #987
	cmp r1, r2
	jeq GameOver_Activate
	
	
	rts
	
wall_1_check:

	
	loadn r2, #391
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #432
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #472
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	rts
	
wall_2_check:

	
	loadn r2, #891
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #931
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #971
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #972
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	rts

turret_check:
	
	loadn r2, #1059
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1098
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1099
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1100
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	loadn r2, #1137
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1138
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1139
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1140
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1141
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	rts





Draw_Snake:
	push r0
	push r1
	push r2
	push r3 
	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!
	loadn R1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
  

	
	; Sincronização
	loadn 	r0, #1000
	loadn 	r1, #0
	mod 	r0, r6, r0		; r1 = r0 % r1 (Testa condições de contorno)
	cmp 	r0, r1
	jne Draw_End
	
	load 	r0, FoodPos
	loadn 	r1, #'.'
	outchar r1, r0
	
	loadn 	r0, #SnakePos	; r0 = & SnakePos
	loadn 	r1, #'}'		; r1 = '}'
	loadi 	r2, r0			; r2 = SnakePos[0]
	outchar r1, r2			
	
	loadn 	r0, #SnakePos	; r0 = & SnakePos
	loadn 	r1, #' '		; r1 = ' '
	load 	r3, SnakeSize	; r3 = SnakeSize
	add 	r0, r0, r3		; r0 += SnakeSize
	loadi 	r2, r0			; r2 = SnakePos[SnakeSize]
	outchar r1, r2
	
	Draw_End:
		pop	r3
		pop r2
		pop r1
		pop r0
	
	rts
;--------------------------------------------------------------------------------------------------------
Delay:
	push r0
	
	inc r6
	load r0, Speed
	cmp r6, r0
	jgr Reset_Timer
	
	jmp Timer_End
	
	Reset_Timer:
		loadn r6, #0
	Timer_End:		
		pop r0
	
	rts
	
Delay2: ; Delay para desenhar o cenário sem bugar
	push r0
	
	inc r6
	loadn r0, #1
	cmp r6, r0
	jgr Reset_Timer
	
	jmp Timer_End
	
	Reset_Timer:
		loadn r6, #0
	Timer_End:		
		pop r0
	
	rts

Shot_Delay: 
	push r0
	push r1
	
	loadn r1, #5  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #4000	; b
   Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts


NextLevel:
	
	push r0
	push r1
	push r2
	push r3
	
	
	loadn r0, #615
	loadn r1, #SuccessMessage
	loadn r2, #0
	call Imprime
		
	loadn r0, #687
	loadn r1, #NextLevelMessage
	loadn r2, #0
	call Imprime
	
	in_loop:
		inchar 	r3
		loadn 	r4, #' '
		
		cmp r3, r4
		jeq Next_level_activate
		
	jmp in_loop

	Next_level_activate:
		loadn r0, #615
		loadn r1, #EraseSuccessMessage
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #EraseNextLevelMessage
		loadn r2, #0
		call Imprime
	
	load r0, Stage 
	loadn r1, #50
	
	cmp r0, r1 ; checa se concluiu o ultimo nivel. Em caso positivo, o jogo dá game over e recomeça
	jeq GameOver_Activate
	
	call Draw_new_stage	
	call EraseSnake
	call Initialize
	call inicialize_score	
	call increase_speed
	
	pop r3
	pop r2
	pop r1
	pop r0
	
	jmp ingame_loop
		
increase_speed:
	push r0
	push r1
	
	loadn r0, #300 
	load r1, Speed
	sub r1, r1, r0 ; reduzirá em 300 unidades o valor de Speed. Na função delay isso fará com que a snake se movimente mais rapido
	store Speed, r1 
	
	pop r1
	pop r0
	
	rts
	
Draw_new_stage:
	push r0
	push r1
	push r2
	
	load r3, Stage ; salva o valor ASCII da fase atual (0 == 48, 1 == 49 , 2 == 50)
	inc r3
	store Stage, r3
		
	loadn r4, #49 
	loadn r5, #50
	
	cmp r3, r4
	jeq draw_stage2
	
	jmp draw_stage3
	
	draw_stage2:
		loadn R1, #tela2Linha0	; Endereco de inicio da primeira linha do cenario!!
		loadn R2, #1024
		call Draw_Stage
		
		outchar r3, r4 ; imprime o 1 em ascII  na posição 49 da tela
				
		jmp fim_draw_stage
		
	;Desenhar a fase 3 
	draw_stage3:
		loadn R1, #tela3Linha0	; Endereco de inicio da primeira linha do cenario!!
		loadn R2, #256
		call increase_speed
		call Draw_Stage
		
		outchar r3, r4 
		

	fim_draw_stage:

	pop r2
	pop r1
	pop r0
	
	
	rts
	

Restart_Game:
	inchar 	r0
	loadn 	r1, #' '
	
	cmp r0, r1
	jeq Restart_Activate
	
	jmp Restart_End
	
	Restart_Activate:
		loadn r0, #615
		loadn r1, #EraseGameOver
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #EraseRestart
		loadn r2, #0
		call Imprime
		
		call EraseSnake		
		
		jmp main
		
		
	Restart_End:
	
	rts


Imprime:
	push r0		; Posição na tela para imprimir a string
	push r1		; Endereço da string a ser impressa
	push r2		; Cor da mensagem
	push r3
	push r4

	
	loadn r3, #'\0'

	LoopImprime:	
		loadi r4, r1
		cmp r4, r3
		jeq SaiImprime
		add r4, r2, r4
		outchar r4, r0
		inc r0
		inc r1
		jmp LoopImprime
		
	SaiImprime:	
		pop r4	
		pop r3
		pop r2
		pop r1
		pop r0
		
	rts

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "	
	
tela1Linha0  : string "PONTOS ==                               "
tela1Linha1  : string "LEVEL ==                                "
tela1Linha2  : string "                                        "
tela1Linha3  : string " ______________________________________ "
tela1Linha4  : string "|                                      |"
tela1Linha5  : string "|                                      |"
tela1Linha6  : string "|                                      |"
tela1Linha7  : string "|                                      |"
tela1Linha8  : string "|                                      |"
tela1Linha9  : string "|                              _       |"
tela1Linha10 : string "|                               |      |"
tela1Linha11 : string "|                               |      |"
tela1Linha12 : string "|                                      |"
tela1Linha13 : string "|                                      |"
tela1Linha14 : string "|                                      |"
tela1Linha15 : string "|                                      |"
tela1Linha16 : string "|                                      |"
tela1Linha17 : string "|                                      |"
tela1Linha18 : string "|                                      |"
tela1Linha19 : string "|                                      |"
tela1Linha20 : string "|                                      |"
tela1Linha21 : string "|                                      |"
tela1Linha22 : string "|          |                           |"
tela1Linha23 : string "|          |                           |"
tela1Linha24 : string "|          |_                          |"
tela1Linha25 : string "|                                      |"
tela1Linha26 : string "|                                      |"
tela1Linha27 : string "|                                      |"
tela1Linha28 : string "|                                      |"
tela1Linha29 : string "|______________________________________|"	



tela2Linha0  : string "PONTOS ==                               "
tela2Linha1  : string "LEVEL ==                                "
tela2Linha2  : string "                                        "
tela2Linha3  : string " ______________________________________ "
tela2Linha4  : string "|                                      |"
tela2Linha5  : string "|                                      |"
tela2Linha6  : string "|                                      |"
tela2Linha7  : string "|                                      |"
tela2Linha8  : string "|                                      |"
tela2Linha9  : string "|                              _       |"
tela2Linha10 : string "|      ______                   |      |"
tela2Linha11 : string "|      |    |                   |      |"
tela2Linha12 : string "|      |____|                          |"
tela2Linha13 : string "|                                      |"
tela2Linha14 : string "|                                      |"
tela2Linha15 : string "|                                      |"
tela2Linha16 : string "|                                      |"
tela2Linha17 : string "|                                      |"
tela2Linha18 : string "|                                      |"
tela2Linha19 : string "|                                      |"
tela2Linha20 : string "|                                      |"
tela2Linha21 : string "|                                      |"
tela2Linha22 : string "|                     ______           |"
tela2Linha23 : string "|                     |    |           |"
tela2Linha24 : string "|                     |____|           |"
tela2Linha25 : string "|                                      |"
tela2Linha26 : string "|                                      |"
tela2Linha27 : string "|                                      |"
tela2Linha28 : string "|                                      |"
tela2Linha29 : string "|______________________________________|"	

tela3Linha0  : string "PONTOS ==                               "
tela3Linha1  : string "LEVEL ==                                "
tela3Linha2  : string "                                        "
tela3Linha3  : string " ______________________________________ "
tela3Linha4  : string "|                                      |"
tela3Linha5  : string "|                                      |"
tela3Linha6  : string "|                                      |"
tela3Linha7  : string "|                                      |"
tela3Linha8  : string "|                                      |"
tela3Linha9  : string "|                              _       |"
tela3Linha10 : string "|                               |      |"
tela3Linha11 : string "|                               |      |"
tela3Linha12 : string "|                                      |"
tela3Linha13 : string "|                                      |"
tela3Linha14 : string "|                                      |"
tela3Linha15 : string "|                                      |"
tela3Linha16 : string "|                                      |"
tela3Linha17 : string "|                                      |"
tela3Linha18 : string "|                                      |"
tela3Linha19 : string "|                                      |"
tela3Linha20 : string "|                                      |"
tela3Linha21 : string "|                                      |"
tela3Linha22 : string "|          |                           |"
tela3Linha23 : string "|          |                           |"
tela3Linha24 : string "|          |_                          |"
tela3Linha25 : string "|                                      |"
tela3Linha26 : string "|                  !                   |"
tela3Linha27 : string "|                 <|>                  |"
tela3Linha28 : string "|                &&&&&                 |"
tela3Linha29 : string "|______________________________________|"	

	