#ifndef __MyHttpClient_H_
#define __MyHttpClient_H_
 
#include "cocos2d.h"
#include "network/HttpClient.h"
 
using namespace cocos2d;
using namespace extension;
 
class MyHttpClient : public cocos2d::CCObject
{
public:
    static void doGet(const char* url,int handler);
    virtual void onHttpRequestCompleted(cocos2d::CCNode *sender, void *data);
    virtual void executeFunction(int responseCode, const char* resp);
 
private:
    int m_nHandler;
};
 
#endif //__MyHttpClient_H_
