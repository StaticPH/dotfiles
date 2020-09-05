define cls
	shell clear
	dont-repeat
end
document cls
	Clears the screen with a simple command
end

define argv
	show args
end
document argv
	Print program arguments
end

define functions
	info functions
end
document functions
	Print functions in target
end

define vars
	info variables
end
document vars
	Print variables (symbols) in target
end

define libs
	info sharedlibrary
end
document libs
	Print a list of the shared libraries linked to target
end

define locals
	info locals
end
document locals
	Print the names and values of all variables in the local scope. #Local variables of current stack frame.
end

set max-completions 100
set history remove-duplicates 1
# set history save
# set history filename ~/.gdb_history

#set exec-done-display
#set debug overload
#set debug timestamp
#set debug varobj	????
