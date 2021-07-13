.define LED_ADDRESS 0x1000
.define HEX_ADDRESS 0x2000

// This code prints on the HEX displays either PASSEd or FAILEd based conditional branches
 			mvi	r0, #0
 			mvi	r1, #1
			mvi	r2, #0					// used to count number of successful tests
			mvi	r5, #FAIL

			mvi	r6, #T1					// save address of next instruction
			add	r0, r0					// set the z flag
// test mvnz
T1:		mvnz	r7, r5					// should not take the branch!

			add	r2, r1					// incr success count
			mvi	r4, #S1
			mvi	r6, #T2					// save address of next instruction
// test mv's effect on z flag
			mv		r3, r1					// reset the z flag
			mvnz	r7, r4					// should take the branch!
T2:		mvi	r7, #FAIL

S1:		add	r2, r1					// incr success count
			mvi	r4, #S2
			mvi	r6, #T3					// save address of next instruction
			add	r3, r1					// reset the z flag
// test mvnz
			mvnz	r7, r4					// should take the branch!
T3:		mvi	r7, #FAIL

S2:		add	r2, r1					// incr success count
			mvi	r6, #T4
			mv		r0, r0					// set the z flag
// test mv's effect on z flag
T4:		mvnz	r7, r5					// should not take the branch!

			add	r2, r1					// incr success count
			mvi	r6, #T5					// save address of next instruction
			mvi	r3, #0xffff
			add	r3, r1					// set the c flag
// test mvnc
T5:		mvnc	r7, r5					// should not take the branch!

			add	r2, r1					// incr success count
			mvi	r4, #S3
			mvi	r6, #T6
			add	r3, r0					// clear carry flag
// test mvnc
			mvnc	r7, r4					// should take the branch!
T6:		mvi	r7, #FAIL
			
S3:		add	r2, r1					// count the success
// finally, test ld and st from/to memory
			mvi	r6, #T7					// save address of next instruction
			mvi	r4, #_LDTEST
			ld		r4, [r4]
			mvi	r3, #0xA5A5
			sub	r3, r4
T7:		mvnz	r7, r5					// should not take the branch!

			add	r2, r1					// incr success count
			mvi	r6, #T8					// save address of next instruction
			mvi	r3, #0xA5A5
			mvi	r4, #_STTEST
			st		r3, [r4]		
			ld		r4, [r4]
			sub	r3, r4
T8:		mvnz	r7, r5					// should not take the branch!

			add	r2, r1					// incr success count
			mvi	r7, #PASS

// Loop over the six HEX displays
FAIL:		mvi	r3, #LED_ADDRESS
			st		r6, [r3]					// show address of failed test on LEDs
			mvi	r5, #_FAIL
			mvi	r7, #PRINT
PASS:		mvi	r3, #LED_ADDRESS
			st		r2, [r3]					// show success count on LEDs
			mvi	r5, #_PASS

PRINT:	mvi	r1, #1
			mvi	r4, #HEX_ADDRESS		// address of HEX0 
			// We would normally use a loop counting down from 6 with mvnz to display the
			// six letters. But in this testing code we can't assume that mvnz even works!
			ld		r3, [r5]					// get letter 
 			st		r3, [r4]					// send to HEX display
 			add	r5, r1					// ++increment character pointer 
 			add	r4, r1					// point to next HEX display
			ld		r3, [r5]					// get letter 
 			st		r3, [r4]					// send to HEX display
 			add	r5, r1					// ++increment character pointer 
 			add	r4, r1					// point to next HEX display
			ld		r3, [r5]					// get letter 
 			st		r3, [r4]					// send to HEX display
 			add	r5, r1					// ++increment character pointer 
 			add	r4, r1					// point to next HEX display
			ld		r3, [r5]					// get letter 
 			st		r3, [r4]					// send to HEX display
 			add	r5, r1					// ++increment character pointer 
 			add	r4, r1					// point to next HEX display
			ld		r3, [r5]					// get letter 
 			st		r3, [r4]					// send to HEX display
 			add	r5, r1					// ++increment character pointer 
 			add	r4, r1					// point to next HEX display
			ld		r3, [r5]					// get letter 
 			st		r3, [r4]					// send to HEX display
 			add	r5, r1					// ++increment character pointer 
 			add	r4, r1					// point to next HEX display
			
HERE:		mvi	r7, #HERE

_PASS:	.word	0b0000000001011110	// d
			.word	0b0000000001111001	// E
			.word	0b0000000001101101	// S
			.word	0b0000000001101101	// S
			.word	0b0000000001110111	// A
			.word 0b0000000001110011	// P

_FAIL:	.word	0b0000000001011110	// d
			.word	0b0000000001111001	// E
			.word	0b0000000000111000	// L
			.word	0b0000000000110000	// I
			.word	0b0000000001110111	// A
			.word 0b0000000001110001	// F

_LDTEST:	.word 0xA5A5
_STTEST:	.word 0x5A5A
