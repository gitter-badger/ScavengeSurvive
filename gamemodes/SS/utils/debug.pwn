#define MAX_DEBUG_HANDLER		(128)
#define MAX_DEBUG_HANDLER_NAME	(32)

#define IS_VALID_HANDLER(%0)	(0 <= %0 < dbg_Total)
#define d:%0:%1(%2)				debug_printf(%1,%0,%2)
//#define d:%0(%1,%2)			d3:%0(DEBUG_HANDLER,%1,%2)
//#define d(%0,%1)				d2:1(DEBUG_HANDLER,%0,%1)


static const DEBUG_PREFIX[32] = "$ ";


static
		dbg_Name[MAX_DEBUG_HANDLER][MAX_DEBUG_HANDLER_NAME],
		dbg_Level[MAX_DEBUG_HANDLER] = {255, 0, 0, ...}, // set handler 0 to 255
		dbg_Total = 1; // handler 0 is global


stock debug_register_handler(name[], initstate = 0)
{
	strcat(dbg_Name[dbg_Total], name);
	dbg_Level[dbg_Total] = initstate;

	printf("Registered debug handler: '%s' initial state: %d", dbg_Name[dbg_Total], dbg_Level[dbg_Total]);

	return dbg_Total++;
}

stock debug_print(handler, level, string[])
{
	if(!IS_VALID_HANDLER(handler))
		return 0;

	if(dbg_Level[handler] < level)
		return 0;

	printf("%s[%s]: %s", DEBUG_PREFIX, dbg_Name[handler], string);

	return 0;
}

stock debug_printf(handler, level, string[], va_args<>)
{
	if(!IS_VALID_HANDLER(handler))
		return 0;

	if(dbg_Level[handler] < level)
		return 0;

	new str[256];
	va_formatex(str, sizeof(str), string, va_start<3>);
	debug_print(handler, level, str);

	return 0;
}

stock debug_set_level(handler, level)
{
	if(!IS_VALID_HANDLER(handler))
		return 0;

	dbg_Level[handler] = level;

	return 1;
}

stock debug_conditional(handler, level)
{
	if(!IS_VALID_HANDLER(handler))
		return 0;

	return (dbg_Level[handler] >= level);
}

stock debug_handler_search(name[])
{
	new bestmatch = -1;

	// Needs a better search algorithm...
	for(new i; i < dbg_Total; i++)
	{
		if(strfind(dbg_Name[i], name, true) != -1)
		{
			bestmatch = i;
			break;
		}
	}

	return bestmatch;
}

stock debug_get_handler_name(handler, output[])
{
	if(!IS_VALID_HANDLER(handler))
		return 0;

	output[0] = EOS;
	strcat(output, dbg_Name[handler], MAX_DEBUG_HANDLER_NAME);

	return 1;
}
