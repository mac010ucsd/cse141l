int min = 16;
int max = 0;
int sum = 0;
int val = 0;

for (int i = 0; i < 31; i++) {
    for (int j = i+1; j < 32; j++) {
        //clear sum
        val = data[2 * i] ^ data[2 * j];
        for (k = 0; k < 8; k++){ // count number of 1s
			sum += val & 1; // check smallest bit to see if it's 1
			val >> 1; // right shift tmp
		}
        val = data[2* i +1], data[2 * j+1];
        for (k = 0; k < 8; k++){ // count number of 1s
			sum += val & 1; // check smallest bit to see if it's 1
			val >> 1; // right shift tmp
		}
        if (sum > max) { max = sum;}
        if (sum < min) { min = sum;}
    }
}