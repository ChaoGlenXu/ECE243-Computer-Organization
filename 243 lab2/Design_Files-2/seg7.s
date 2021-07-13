.define LED_ADDRESS 0x1000
.define HEX_ADDRESS 0x2000
.define SW_ADDRESS 0x3000

// This program shows a decimal digit on the HEX displays
			mv		r5, r7				// return address for subroutine
			mvi	r7, #BLANK			// call subroutine to blank the HEX displays
MAIN:		mvi	r2, #HEX_ADDRESS	// point to HEX port
			mvi	r3, #DATA			// used to get 7-segment display pattern

			mvi	r4, #SW_ADDRESS	// point to SW port
			ld		r0, [r4]				// read switches
			mvi	r4, #LED_ADDRESS	// point to LED port
			st		r0, [r4]				// light up LEDs
			add	r2, r0				// point to correct HEX display
			add	r3, r0				// point to correct 7-segment pattern

			ld		r0, [r3]				// load the 7-segment pattern
			st		r0, [r2]				// light up HEX display

			mvi	r7, #MAIN

// subroutine BLANK
// 	This subroutine clears all of the HEX displays
//	input: none
//	returns: nothing
BLANK:
			mvi	r0, #0				// used for clearing
			mvi	r1, #1				// used to add/sub 1
			mvi	r2, #HEX_ADDRESS	// point to HEX displays
			st		r0, [r2]				// clear HEX0
			add	r2, r1
			st		r0, [r2]				// clear HEX1
			add	r2, r1
			st		r0, [r2]				// clear HEX2
			add	r2, r1
			st		r0, [r2]				// clear HEX3
			add	r2, r1
			st		r0, [r2]				// clear HEX4
			add	r2, r1
			st		r0, [r2]				// clear HEX5

			add	r5, r1
			add	r5, r1
			mv		r7, r5				// return from subroutine

DATA:		.word 0b00111111			// '0'
			.word 0b00000110			// '1'
			.word 0b01011011			// '2'
			.word 0b01001111			// '3'
			.word 0b01100110			// '4'
			.word 0b01101101			// '5'
