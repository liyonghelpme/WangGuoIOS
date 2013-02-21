#ifndef __LIANGWEI_EXTENSION_H_
#define __LIANGWEI_EXTENSION_H_
 
extern "C" {
#include "tolua++.h"
#include "tolua_fix.h"
}
#include "cocos2d.h"
 
using namespace cocos2d;
 
TOLUA_API int tolua_liangwei_extension_open(lua_State* tolua_S);
 
#endif // __COCOS2DX_EXTENSION_NETWORK_H_
