#include "ISXLua5.h"

// A LavishScript Top-Level Object is similar to a global C++ object.  The main difference is that
// a TLO can give ANY data type it wants; it is not limited to a single type.  You may wish to give
// a different type depending on the index (parameters, dimensions, etc) for example.  Usually, though,
// you simply give one specific type.

/*
bool __cdecl TLO_Lua5(int argc, char *argv[], LSTYPEVAR &Dest)
{
	// argc and argv are used if the object access uses an index, such as Lua5[1] or 
	// Lua5[my coat,1,seventeen].  argc is the number of parameters (or dimensions) separated 
	// by commas, and does NOT include the name of the object.

	// LSTYPEVAR, used for Dest, is a VarPtr with a Type.  Type should be set to a pointer to a data type,
	// such as Dest.Type=pIntType for integers.  Do not set the Type or return true if the data retrieval
	// fails (there is no object).  For example, if the requested data is a string, and the string does
	// not exist, return false and do not set the type.

	Dest.DWord=1;
	Dest.Type=pLua5Type;
	return true;
}
/**/