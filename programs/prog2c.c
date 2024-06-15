// PSEUDOCODE
max = 0;
max2 = 0;
min = 0xFF;
min2 = 0xFF;
val = 0
val2 = 0


for (i = 0; i < 31; i++) {
	for (j = i+1; j < 32; j++) {
		val2 = data[2 * i+1] + !data[2 * j+1] + 1
		val = data[2 * i] + !data[2 * j] + CF // assume we have carry reg (CF) in ALU

		if (!cf) {
			if (val >> 7 == 1) {
				val2 = !val2 + 1;
				val = !val + CF;
			}
		}

		// if carry flag is set, flip and add 1 to get value.
		// if carry flag is not set, val MS bit will determine sign.
		// 	if val MS bit == 1, flip and add 1 to get value
		// 	if val MS bit == 0, do nothing.
		
		if (val > max | val == max & val2 > max2) {
			max = val;
			max2 = val2;
		}

		if (val < min | val == min & val2 > min2) {
			min = val;
			min2 = val2;
		}
		
	} 
}
mem[66] = min;
mem[67] = min2;
mem[68] = max;
mem[69] = max2;