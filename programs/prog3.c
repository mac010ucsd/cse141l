// PSEUDOCODE
A0;
A1;
B0;
B1;
Y0-3;
// assemblyh normal loop stuff
for (i = 0; i < 15; i++) {
	
	// FF + FF + 1 = 1 FF
	A0 = data[4*i];
	A1 = data[4*i+1];
	B0 = data[4*i+2];
	B1 = data[4*i+3];
	
	// [xx xx AA AA]
	// [BB BB]

	// assembly normal loop stuff
	for (n = 0; n < 8; n++){
		X = (B1 & 1) * A0; // bit mask lsb
		X_t = X;
		X << n;
		Y0 = X;
		X_t >> 8-n;
		Y1 = X;
		/*
		mov i reg0 // load b1 into reg0 begin
		lsl reg0 x2
		inc reg0 x3
		ldr reg0 //load b1 into reg0

		mov reg0 reg1
		clr reg0
		inc reg0 // reg0 = 1
		and reg0 reg1 // bit masked reg0 to lsb
		cmp reg0 1 // if it is == 1 then it's just A0 else 0 (we don't need to do anything)
		jge jmp_target

		mov i reg0
		lsl reg0 x2
		inc reg0 x1 // a1 (lsbyte)
		ldr reg0 // load a1 into reg0

		mov reg0 reg2 // store a1 in reg2
		
		// get Y3 addr
		mov i reg0
		lsl reg0 x2 // i * 4
		inc reg0 x3 // y3 (lsbyte)

		clr reg1
		inc reg1
		lsl reg1 x6 // 64
		add reg0 reg1
		ldr reg0 // y3 loaded into reg0
		
		mov reg2 reg1
		
		lsl reg1 xn
		add reg0 reg1
		
		mov i reg1
		lsl reg1 x2
		inc reg1 x3
		
		str reg1 // y3 stored in mem
		// reg2 still holds a1, reg1 + reg0 free.
		
		// get Y2 addr
		mov i reg0
		lsl reg0 x2 // i * 4
		inc reg0 x2 // y3 (lsbyte)

		clr reg1
		inc reg1
		lsl reg1 x6 // 64
		add reg0 reg1
		ldr reg0 // y3 loaded into reg0
		
		mov reg2 reg3
		
		rol reg3 xn
		// then mask lower n bits
		clr reg1
		not reg1
		lsl reg1 xn
		not reg1 // forms mask for lower n bits
		and reg3 reg1

		add reg0 reg3
		
		mov i reg1
		lsl reg1 x2
		inc reg1 x2
		
		str reg1 // y2 stored in mem
		// jmp_target
		// repeat something like this for the second part too.
		*/
		
		X = (B1 & 1) * A1;
		X_t = x;
		X << n;
		Y2 = X;
		X_t >> 8-n;
		Y3 = X_t;
		
	}

	for (n = 0; n < 8; n++){ // JE command
		X = (B0 & 1) * A0; // bit mask lsb
		X_t = X;
		X << n;
		Y1 = X;
		X_t >> 8-n;
		Y2 = X;
		
		X = (B0 & 1) * A1;
		X_t = x;
		X << n;
		Y3 = X;
	}
	// might've messed up the order of Ys.
	// but who cares just pseudocode.
	mem[64 + 4 * i] = Y0;
	mem[64 + 4 * i + 1] = Y1;
	mem[64 + 4 * i + 2] = Y2;
	mem[64 + 4 * i + 3] = Y3;
}

// i tentantively estimate q3 to be 400 lines long.