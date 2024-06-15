// PSEUDOCODE
max = 0;
max2 = 0;
min = 0xFF;
min2 = 0xFF;
val = 0
val2 = 0

// do some bogey with memory to assign values to those addresses.
// not really that hard.
// val, val2 don't need to be initialized.


// normal loop assembly
for (i = 0; i < 31; i++) {
	// normal loop assembly
	for (j = i+1; j < 32; j++) {
		// FF + FF + 1 = 1 FF

		/*
		clr reg0
		mov i reg0
		lsl reg0
		inc reg0
		ldr // r0 stores data[2 * i + 1]
		mov reg0 reg1 
		clr reg0
		mov j reg0
		lsl reg0
		inc reg0
		ldr // reg0 stores data[2 * j + 1]
		not reg0
		mov reg0 reg2
		add reg1 reg2 // carry bit mighjt be set off here.
		mov reg3 flags
		// do stuff to isolate carry flag to bit 0 (least sig bit)
		clr reg2
		inc reg2 
		add reg1 reg2
		mov reg2 flags
		// do stuff to isolatre carry flag to bit 0
		or reg2 reg3
		// this will be the add for the next addition.
		// reg1 reg2 has useful data (sum, CF).
		// actually can we store sum anywhere?
		mov reg1 reg0
		// we can store val0 in 70 or 71 mem
		clr reg1
		// 71 = 01000111
		inc reg1
		lsl reg1 x4
		inc reg1
		lsl reg1
		inc reg1
		lsl reg1
		inc reg1
		str reg1 // store reg0 at location speified in reg1 (70)
		// only reg2 has useful data now (CF)

		clr reg0
		mov i reg0
		lsl reg0 
		ldr
		mov reg0 reg3 // data[2i]

		add reg3 reg2 // data[2i] + CF
		mov flag reg2
		// do shifts to isolate carry flag, assume it is stored in reg2.

		mov j reg0
		lsl j
		ldr
		not reg0 // ! data[2j]
		add reg3 reg0
		// reg3 has total sum. reg2 has prev cf
		mov flag reg1
		// do shiufts to isolate carry flag
		or reg2 reg1 // new cf stored in reg2
		// reg2 has cf, reg3 has total sum of msb.
		// 71 holds sum0
		// 70 reserved to hold sum1
		// 70 = 01000110
		clr reg1
		inc reg1
		lsl reg1 x4
		inc reg1
		lsl reg1
		inc reg1
		lsl reg1
		ldr
		mov reg3 reg0

		// reg2 has cf, reg3 has msb sum

		clr reg0
		inc reg0
		cmp reg2 reg0
		je target_1 // if carry flag is ON:
		// if carry flag is off...
		mov reg3 reg2
		rol reg3 x1
		clr reg0
		inc reg0
		and reg3 reg0 // just to get the top bit.
		cmp reg3 reg0 
		jne target_1_end

		// target_1 assumes reg3 has msb sum
		inc reg0		// ldr from addr 71 (lsb)
		lsl reg0 x4
		inc reg0
		lsl reg0
		inc reg0
		lsl reg0
		inc reg0
		ldr
		not reg0
		// reg2 has cf, reg3 has msb sum, reg0 has lsb sum
		clr reg1
		inc reg1
		add reg0 reg1
		// reg2 has cf (is it still needed????), reg3 has msb sum, reg0 has lsb sum
		mov flags reg1
		// do shifts to isolate cf 
		not reg3
		add reg3 reg1
		// reg3 has msb sum reg0 has lsb sum, other regs clearable
		// target_1 end

		// 71 = 01000111
		clr reg1
		inc reg1
		lsl reg1 x4
		inc reg1
		lsl reg1
		inc reg1
		lsl reg1
		inc reg1
		str reg1 // store reg0 at location speified in reg1 (71)
		mov reg0 reg2

		// 70 = 01000110
		clr reg1
		inc reg1
		lsl reg1 x4
		inc reg1
		lsl reg1
		inc reg1
		lsl reg1
		mov reg3 reg0
		str reg1 // store reg0 at location speified in reg1 (70)

		// reg3 has msb sum reg2 has lsb sum, other regs clearable
		*/
		val2 = data[2 * i+1] + !data[2 * j+1] + 1
		val = data[2 * i] + !data[2 * j] + CF // assume we have carry reg (CF) in ALU

		// FF + FF + 01 = 1 FF FF
		if (!cf) {
			if (val >> 7 == 1) {
				val2 = !val2 + 1;
				val = !val + CF;
			}
			.
		}

		if carry flag is set, flip and add 1 to get value.
		if carry flag is not set, val MS bit will determine sign.
			if val MS bit == 1, flip and add 1 to get value
			if val MS bit == 0, do nothing.
		
		// 66		67		68		69
		// min1		min0	max1	max0
		if (val > max | val == max & val2 > max2) {
			max = val;
			max2 = val2;
		}

		if (val < min | val == min & val2 > min2) {
			min = val;
			min2 = val2;
		}
		/*
		
		// reg3 has msb sum reg2 has lsb sum, other regs clearable

		// want to load msb max (68)
		// 01001000
		clr reg1
		inc reg1
		lsl reg1 x3
		inc reg1
		lsl reg1 x3
		mov reg1 reg0
		ldr
		// msb max in reg0
		cmp reg0 reg3 
		je jump_target_equal
		jge jump_target_nothing
		
		// jump target (equal) 
		// want to load msb max (69) (68+1)
		// 01001001
		inc reg1
		mov reg1 reg0
		ldr
		cmp reg2 reg0
		jle jump_target_nothing // if lsb sum lt lsb max go to jump target nothing else continue

		// max < val
		// time to store the values.

		// want to get addr of msb max (68)
		// 01001000
		clr reg1
		inc reg1
		lsl reg1 x3
		inc reg1
		lsl reg1 x3
		mov reg3 reg0
		str reg1
		
		// 01001001
		inc reg1
		mov reg2 reg0
		str reg1
		// stored into max_value

		// dude.. just repeat this for the min.
		*/
		
	} 
}
mem[66] = min;
mem[67] = min2;
mem[68] = max;
mem[69] = max2;