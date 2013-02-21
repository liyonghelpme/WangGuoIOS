#include "MyExtension.h"
#include "MyHttpClient.h"
static int tolua_liangwei_MyHttpClient_doGet00(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if (
			!tolua_isusertable(tolua_S,1,"MyHttpClient",0,&tolua_err) 
				||	!tolua_isstring(tolua_S,2,0,&tolua_err) 
				||	!toluafix_isfunction(tolua_S,3, "", 0, &tolua_err) 
				||	!tolua_isnoobj(tolua_S,4,&tolua_err)
			)
		goto tolua_lerror;
	else
	{
		const char* url = ((const char*)  tolua_tostring(tolua_S,2,0));
		int funcID = (toluafix_ref_function(tolua_S,3,0));
		{
			MyHttpClient::doGet(url, funcID);
		}
	}
	return 1;
	tolua_lerror:
			tolua_error(tolua_S,"#ferror in function 'node'.",&tolua_err);
	return 0;
}
TOLUA_API int tolua_liangwei_extension_open (lua_State* tolua_S)
{
	tolua_open(tolua_S);
	tolua_usertype(tolua_S,"MyHttpClient");
	tolua_module(tolua_S,NULL,0);
	tolua_beginmodule(tolua_S,NULL);
	//注册函数和类
	tolua_cclass(tolua_S, "MyHttpClient", "MyHttpClient", "CCObject", NULL);
	tolua_beginmodule(tolua_S,"MyHttpClient");
	tolua_function(tolua_S,"doGet",tolua_liangwei_MyHttpClient_doGet00);
	tolua_endmodule(tolua_S);
	tolua_endmodule(tolua_S);
	return 1;
}
#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
TOLUA_API int luaopen_liangwei_extension (lua_State* tolua_S) {
	return tolua_liangwei_extension_open(tolua_S);
};
#endif


