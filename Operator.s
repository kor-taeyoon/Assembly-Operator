	AREA ARMex, CODE, READONLY
		ENTRY
start
	;reg   ; 	conv					|	maxpool				| 곱셈

	;r0    ; matrix size				| matrix size
	;r1    ; stride						| stride
	;r2    ; convolution size			| max pool
	;r3    ; convolution result size	| max pool result size
	;r4    ; db's first element address
	;r5    ; 			| target data
	;r6    ; 			| largest data
	;r7    ; 			| 
	;r8    ; target store address
	;r9    ; external loop count
	;r10   ; internal loop count
	;r11   ; conv row count
	;r12   ; conv column count

MainStart
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 레지스터 선언
	LDR r4, =db;
	LDR r8, addr0;
	
	LDR r5, [r4, #16]
	LDR r6, [r4, #24]
	
	BL myMul
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 컨볼루션에 필요한 기타 등등의 스펙 로딩
	LDR r2, [r4];    load convolution size
	LDR r1, [r4, #4];  load stride size
	LDR r0, [r4, #12];  load matrix size
	SUB r0, r0, r2;
	BL Div
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; 컨볼루션
	LDR r0, [r4, #12];  load matrix size
ConLoop1		; loop for result row


ConLoop2		; loop for result column


ConLoop3		; loop for kernel row


ConLoop4		; loop for kernel column


	BPL MaxLoop4
	
	
	BPL MaxLoop3
	
	
	BPL MaxLoop2
	
	
	BPL MaxLoop1
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 맥스풀링에 필요한 기타 등등의 스펙 로딩
	LDR r2, [r4, #8];  load max pool size
	LDR r1, [r4, #4];  load stride size
	LDR r0, [r4, #12];  load matrix size
	SUB r0, r0, r2;
	BL Div
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; 맥스 풀링
	LDR r0, [r4, #12];  load matrix size
	
MaxLoop1		; loop for result row


MaxLoop2		; loop for result column


MaxLoop3		; loop for window row


MaxLoop4		; loop for window column


	
	
	BPL MaxLoop4
	
	
	BPL MaxLoop3
	
	
	BPL MaxLoop2
	
	
	BPL MaxLoop1
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 끝!
	B Ending
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 두 수의 곱셈 입니다
myMul
	;스택에 잠시 레지스터를 빼두고
	LDR sp, addr1
	STMIA sp!, {r0-r12}
	
	;부가 레지스터들의 정보
	MOV r3, #0		; 음수인 숫자의 갯수를 담는 곳
	MOV r12, #0		; 더하기 직전 시프트 칸 수 세기
	MOV r9, #0		; 최종 결과물 담을 곳
	MOV r7, #31		; 곱셈 시프트 횟수 계산
	
FirTest
	; 첫번째 숫자 음수인지 검사
	MOV r2, r5;
	LSR r2, #31;
	ADD r3, r2, #0;
	CMP r2, #1;
	BMI SecTest
	; 음수이면, 첫번째 숫자를 양수로 변환
	NEG r5, r5
	
SecTest
	; 두번째 숫자 음수인지 검사
	MOV r2, r6;
	LSR r2, #31;
	ADD r3, r2, #0;
	CMP r2, #1;
	BMI MulStart
	; 음수이면, 두번째 숫자를 양수로 변환
	NEG r6, r6
	
MulStart
	; 끝 비트만 남겨보고
	MOV r2, r6
	LSL r2, r7
	LSR r2, #31
	
	; 0이면 그냥 바로 0을, 1이면 11..1을 
	CMP r2, #0
	BEQ Count
	; 31-현재 카운트 숫자 만큼을 시프트 해서 r4에 더하기
	RSB r12, r7, #31
	ADD r9, r9, r5, LSL r12
	
Count	; 반복 횟수를 카운트
	SUB r7, r7, #1
	CMP r7, #19
	BEQ ResultProcessing
	B MulStart
	
ResultProcessing
	CMP r3, #1
	NEGEQ r9, r9
	
	; 메모리에 저장
	STR r9, [r8]
	
	; 레지스터 값을 원상복구 해두고
	LDR sp, addr1
	LDMIA sp, {r0-r12}
	ADD r8, #4;
	
	; 점프된 영역으로 돌아갑니다.
	MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
    
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 끝 입니다.
Ending
	MOV pc, #0    ;Program end
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 결과 행렬의 크기를 구하기 위한 임시 가우스 입니다.
Div
	ADD r3, r3, #1
	SUB r0, r0, r1
	CMP r0, #0
	BPL Div
	MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; data area
	; DCD = 4byte = word
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
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





	END
