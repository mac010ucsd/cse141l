// PSEUDOCODE
min = 16
/*
clr reg0 
inc reg0 // reg0 = 1
lsl reg0 // repeat x4 -> reg0 = 16
str reg0 mem[64]
*/
max = 0
/*
clr reg0 
str reg0 mem[65]
*/
sum = 0
/*
clr reg0 
str reg0 mem[66]
*/
val = 0
/*
clr reg0 
str reg0 mem[67]
*/

/*
clr i
clr reg_0 // i_start
not reg_0 // fill 1s
lsr reg_0 x3 // 00011111 = 31
cmp i reg_0 
jge i_end
// 1 main reg [reg_0]
// 1 loop reg [i]
*/
for (i = 0; i < 31; i++) {
	/*
	mov i j
	inc j
	clr reg_0 // j_startr
	inc reg_0
	lsl reg_0 x5 
	cmp j reg_0
	jge j_end
	// 1 main reg [reg_0]
	// 1 loop reg [j]
	*/
	for (j = i+1; j < 32; j++) {
		val = data[2 * i] ^ data[2 * j] 
		/*
		mov i reg0 // i
		lsl reg0 // 2i
		ldr reg0 // loads mem[reg0] into reg0
		mov reg0 reg1
		mov j reg0
		lsl reg0
		ldr reg0
		xor reg0 reg1 
		str reg0 mem[67] // storage location for val
		// 2 regs overwritten [reg0, reg1]
		// 2 regs referenced [i, j]
		*/
		for (k = 0; k < 8; k++){ // count number of 1s
			sum += val & 1; // check smallest bit to see if it's 1
			val >> 1; // right shift tmp
		}
		/*
		clr k
		cmp k 8 // loop_start_addr
		jge loop_end_addr
		clr reg1
		inc reg1
		ldr mem[67]
		add reg1 reg0
		ldr mem[66]
		add reg0 reg1
		inc k
		jmp loop_start_addr
		// loop_end_addr
		// 2 regs overwritten [reg0, reg1]
		// 1 reg referenced [k]
		// 1 reg possible for loop [reg0]
		*/
		val = data[2* i +1], data[2 * j+1]
		/*
		mov i reg0 // i
		lsl reg0 // 2i
		inc reg0
		ldr reg0 // loads mem[reg0] into reg0
		mov reg0 reg1
		mov j reg0
		lsl reg0
		inc reg0
		ldr reg0
		xor reg0 reg1 
		str reg0 mem[67] // storage location for val
		// 2 regs overwritten [reg0, reg1]
		// 2 regs referenced [i, j]
		*/
		// repeat for 2nd byte pair
		for (k = 0; k < 8; k++){ // count number of 1s
			sum += val & 1; // check smallest bit to see if it's 1
			val >> 1; // right shift tmp
		}
		/*
		clr k
		cmp k 8 // loop_start_addr
		jge loop_end_addr
		clr reg1
		inc reg1
		ldr mem[67]
		add reg1 reg0
		ldr mem[66]
		add reg0 reg1
		inc k
		jmp loop_start_addr
		// loop_end_addr
		// 2 regs overwritten [reg0, reg1]
		// 1 reg referenced [k]
		// 1 reg possible for loop [reg0]
		*/
		// sum 66 max 65 min 64
		if (sum > max) { max = sum; }
		/*
		ldr mem[66]
		mov reg0 reg1
		ldr mem[65]
		cmp reg0 reg1
		jle if_end // jump if reg0 <= reg1 -> max <= sum
		// if_start
		str mem[66] 
		// if_end
		// 2 regs overwritten [reg0, reg1]
		*/
		if (sum < min) { min = sum; }
		/*
		ldr mem[66]
		mov reg0 reg1
		ldr mem[64] // min is reg0
		cmp reg0 reg1
		jle if_end // jump if reg1 <= reg0 -> sum <= min
		// if_start
		str mem[66] 
		// if_end
		// 2 regs overwritten [reg0, reg1]
		*/
	} 
	/*
	jmp j_start
	j_end
	*/
} 
/*
jmp i_start 
i_end
*/

mem[64] = min;
mem[65] = max;

/*
inc // loopreg x1
lsl // x1
lsr // x1
add // x2

xor // x2
not // x1

cmp  // loopreg x2

jge 
jle 
jmp 

ldr 
str 
mov // x2
*/