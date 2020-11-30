	AREA ARMex, CODE, READONLY
		ENTRY
start
	;reg   ; 	conv					|	maxpool

	;r0    ; matrix size				| matrix size
	;r1    ; stride						| stride
	;r2    ; convolution size			| max pool
	;r3    ; convolution result size	| max pool result size
	;r4    ; db's first element address
	;r5    ;
	;r6    ;
	;r7    ;
	;r8    ;
	;r9    ; external loop count
	;r10   ; internal loop count
	;r11   ; 
	;r12   ; 


		  ;;;;    preprocessing    ;;;;
	LDR r4, =db;

	;    convolution result size calculate
	LDR r2, [r4];    load convolution size
	LDR r1, [r4, #4];  load stride size
	LDR r0, [r4, #12];  load matrix size
	SUB r0, r0, r2;
	BL Div

          ;;;;    Convolution    ;;;;
ConLoop1		; loop for result row


ConLoop2		; loop for result column


ConLoop3		; loop for kernel row


ConLoop4		; loop for kernel column


		;;;;    preprocessing    ;;;;
	;    max pooling result size calculate
	LDR r2, [r4, #8];  load max pool size
	LDR r1, [r4, #4];  load stride size
	LDR r0, [r4, #12];  load matrix size
	SUB r0, r0, r2;
	BL Div

          ;;;;    Max Pooling    ;;;;
MaxLoop1		; loop for result row


MaxLoop2		; loop for result column


MaxLoop3		; loop for window row


MaxLoop4		; loop for window column
  


		;;;;    ending    ;;;;

	B Ending

        ;;;;    function area    ;;;;
Ending
	MOV pc, #0    ;Program end

Div
	ADD r3, r3, #1
	SUB r0, r0, r1
	CMP r0, #0
	BPL Div
	MOV pc, lr

        ;;;;    data area    ;;;;    DCD=4byte=word
addr & &60000000




db	DCD 3
    DCD 1
    DCD 2
    DCD 4
    DCD 2_00000000000000000000000010110010; 178
    DCD 2_00000000000000000000000010101111; 175
    DCD 2_00000000000000000000000001100101; 101
    DCD 2_00000000000000000000000001111101; 125
    DCD 2_00000000000000000000000001111101; 125
    DCD 2_00000000000000000000000001111101; 125
    DCD 2_00000000000000000000000001100111; 103
    DCD 2_00000000000000000000000010010001; 145
    DCD 2_00000000000000000000000010101100; 172

    DCD 2_00000000000000000000001010001011; 651
    DCD 2_11111111111111111111111001110101; -395
    DCD 2_00000000000000000000001110010101; 917
    DCD 2_00000000000000000000001001111011; 635
    DCD 2_00000000000000000000000000011010; 26
    DCD 2_11111111111111111111110101011111; -673
    DCD 2_11111111111111111111111100111101; -195
    DCD 2_00000000000000000000001111010011; 979
    DCD 2_00000000000000000000011110010010; 1938
    DCD 2_00000000000000000000001100000011; 771
    DCD 2_11111111111111111111101010000010; -1406
    DCD 2_11111111111111111111101001000001; -1471
    DCD 2_00000000000000000000011001100011; 1635
    DCD 2_11111111111111111111110000110101; -971
    DCD 2_00000000000000000000011110101110; 1966
    DCD 2_11111111111111111111110001100011; -925
    ;99

	END
