.define LEDR_ADDRESS 0x1000
.define SW_ADDRESS 0x3000

// Read SW switches and display on LEDs
			mvi	r3, #LEDR_ADDRESS		// point to LED port
			mvi	r4, #SW_ADDRESS		// point to SW port
MAIN:		ld		r0, [r4]					// read SW values
			st		r0, [r3]					// light up LEDs
			mvi	r7, #MAIN
