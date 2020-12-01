	AREA ARMex, CODE, READONLY
		ENTRY
start
	;reg   ; 	conv					|	maxpool				| 곱셈

	;r0    ; matrix size				| matrix size
	;r1    ; stride						| stride
	;r2    ; convolution size			| max pool
	;r3    ; convolution result size	| max pool result size
	;r4    ; db's first element address
	;r5    ; | target data
	;r6    ; | largest data
	;r7    ; | 
	;r8    ; 
	;r9    ; external loop count
	;r10   ; internal loop count
	;r11   ; conv row count
	;r12   ; conv column count

	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 두 수의 곱셈 입니다
	
	MOV r0, #5		; 곱셈 당하는 수
	MOV r1, #-7		; 곱하는 수
	MOV r5, #31		; 곱셈 시프트 횟수 계산
	
FirTest
	; 첫번째 숫자 음수인지 검사
	MOV r2, r0;
	LSR r2, #31;
	ADD r3, r2, #0;
	CMP r2, #1;
	BMI SecTest
	; 음수이면, 첫번째 숫자를 양수로 변환
	NEG r0, r0
	
SecTest
	; 두번째 숫자 음수인지 검사
	MOV r2, r1;
	LSR r2, #31;
	ADD r3, r2, #0;
	CMP r2, #1;
	BMI MulStart
	; 음수이면, 두번째 숫자를 양수로 변환
	NEG r1, r1
	
MulStart
	; 끝 비트만 남겨보고
	MOV r2, r1
	LSL r2, r5
	LSR r2, #31
	
	; 0이면 그냥 바로 0을, 1이면 11..1을 
	CMP r2, #0
	BEQ Count
	RSB r6, r5, #31
	ADD r4, r4, r0, LSL r6
	; 31-현재 카운트 숫자 만큼을 시프트 해서 r4에 더하기
	
	
Count	; 반복 횟수를 카운트
	SUB r5, r5, #1
	CMP r5, #19
	BEQ ResultProcessing
	B MulStart
	
ResultProcessing
	CMP r3, #1
	NEGEQ r4, r4
	; 여기까지가 두 수의 곱셈입니다
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ST
		  ;;;;    preprocessing    ;;;;
	LDR r4, =db;

	;    convolution result size calculate
	LDR r2, [r4];    load convolution size
	LDR r1, [r4, #4];  load stride size
	LDR r0, [r4, #12];  load matrix size
	SUB r0, r0, r2;
	BL Div
	
          ;;;;    Convolution    ;;;;
	LDR r0, [r4, #12];  load matrix size
ConLoop1		; loop for result row


ConLoop2		; loop for result column


ConLoop3		; loop for kernel row


ConLoop4		; loop for kernel column


	BPL MaxLoop4
	
	
	BPL MaxLoop3
	
	
	BPL MaxLoop2
	
	
	BPL MaxLoop1







		;;;;    preprocessing    ;;;;
	;    max pooling result size calculate
	LDR r2, [r4, #8];  load max pool size
	LDR r1, [r4, #4];  load stride size
	LDR r0, [r4, #12];  load matrix size
	SUB r0, r0, r2;
	BL Div

          ;;;;    Max Pooling    ;;;;
	LDR r0, [r4, #12];  load matrix size
MaxLoop1		; loop for result row


MaxLoop2		; loop for result column


MaxLoop3		; loop for window row


MaxLoop4		; loop for window column


	
	
	
	BPL MaxLoop4
	
	
	BPL MaxLoop3
	
	
	BPL MaxLoop2
	
	
	BPL MaxLoop1







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

        ;;;;    data area    ;;;;    DCD = 4byte = word
		; 59995000 ~ 60005000
addr0 & &60000000

addr1 & &59995000




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
