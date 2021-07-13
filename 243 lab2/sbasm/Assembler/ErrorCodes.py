
class ErrorCodes(object):
	'''
	Static class for error codes.
	'''
	
	# Error code objects.
	NO_ERROR 			= 0
	BAD_FILE 			= 1
	BAD_INSTR			= 2
	BAD_REG				= 3
	BAD_IMMED			= 4
	BIG_IMMED			= 5
	NEG_IMMED			= 6
	DEFINE_BAD			= 7
	DEFINE_REDEF		= 8
	LABEL_BAD			= 9
	LABEL_REDEF			= 10
	IMMED_LABEL_NF		= 11
	WIDTH_DEPTH_ERROR	= 12
	TOO_MUCH_FOR_DEPTH	= 13
	WIDTH_ERROR			= 14
	DEPTH_ERROR			= 15
	WIDTH_DEPTH_DEFINE	= 16
	ONLY_LABEL			= 17
	UNKNOWN				= 18		# Always the last error
	
	
	@staticmethod
	def get_error_message(error_code, line, depth, instruction_count):
		'''
		Converts the given error code and info into a string message.
		Args:
			error_code: int [NO_ERROR, UNKNOWN].
			line: The line number the error is on.
			depth: The depth of the max MIF file.
			instruction_count: The current instruction count.
		Returns:
			A detailed string for the error.
		'''
		error_code = min(error_code, ErrorCodes.UNKNOWN)
		line_str = str(line)
		
		return {
			ErrorCodes.NO_ERROR				: '',
			ErrorCodes.BAD_FILE				: 'ERROR BAD INPUT FILE: could not locate the input file',
			ErrorCodes.BAD_INSTR			: 'ERROR: line ' + line_str + ': unknown instruction',
			ErrorCodes.BAD_REG				: 'ERROR: line ' + line_str + ': unknown register',
			ErrorCodes.BAD_IMMED			: 'ERROR: line ' + line_str + ': the immediate value could not be interpreted as an integer',
			ErrorCodes.BIG_IMMED			: 'ERROR: line ' + line_str + ': the immediate value is too large',
			ErrorCodes.NEG_IMMED			: 'ERROR: line ' + line_str + ': the immediate value is negative',
			ErrorCodes.DEFINE_BAD			: 'ERROR: line ' + line_str + ': bad define statement',
			ErrorCodes.DEFINE_REDEF			: 'ERROR: line ' + line_str + ': define is being redefined',
			ErrorCodes.LABEL_BAD			: 'ERROR: line ' + line_str + ': bad label',
			ErrorCodes.LABEL_REDEF			: 'ERROR: line ' + line_str + ': label redefinition',
			ErrorCodes.IMMED_LABEL_NF		: 'ERROR: line ' + line_str + ': undeclared identifier (label or define)',
			ErrorCodes.WIDTH_DEPTH_ERROR	: 'ERROR: line ' + line_str + ': bad declaration of width or depth flag',
			ErrorCodes.TOO_MUCH_FOR_DEPTH	: 'ERROR MEMORY OVERFLOW: there are too many instructions for the depth of the memory: memory depth = ' + str(depth) + ', instruction count = ' + str(instruction_count),
			ErrorCodes.WIDTH_ERROR			: 'ERROR: Only 32 and 16 bit data widths are supported',
			ErrorCodes.DEPTH_ERROR			: 'ERROR: Memory depth must be an integer multiple of 2',
			ErrorCodes.WIDTH_DEPTH_DEFINE	: 'ERROR: line ' + line_str + ': symbols WIDTH and DEPTH are reserved, they cannot be defined using .define',
			ErrorCodes.ONLY_LABEL			: 'ERROR: UNKNOWN',
			ErrorCodes.UNKNOWN				: 'ERROR: UNKNOWN'
		}[error_code]
