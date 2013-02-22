//
// Created by liangwei on 12-9-10.
//
// To change the template use AppCode | Preferences | File Templates.
//
#include "MyHttpClient.h"
#include "CCLuaEngine.h"
#include "CCLuaStack.h"
#include "cstring"
void MyHttpClient::doPost(const char*url, int handler, const char*postData)
{
    CCLog("doPost %s  %d  %s", url, handler, postData);
    MyHttpClient *myHttpClient = new MyHttpClient();
    CCHttpRequest *request = new CCHttpRequest();
    request->setUrl(url);
    myHttpClient->m_nHandler = handler;
    request->setRequestType(CCHttpRequest::kHttpPost);
    request->setResponseCallback(myHttpClient, callfuncND_selector(MyHttpClient::onHttpRequestCompleted));
    request->setRequestData(postData, strlen(postData));

    CCHttpClient::getInstance()->send(request);
    request->release();
}
void MyHttpClient::doGet(const char* url,int handler)
{
	MyHttpClient *myHttpClient=new MyHttpClient();
	CCHttpRequest* request = new CCHttpRequest();
	request->setUrl(url);
	myHttpClient->m_nHandler=handler;
	request->setRequestType(CCHttpRequest::kHttpGet);
	request->setResponseCallback(myHttpClient, callfuncND_selector(MyHttpClient::onHttpRequestCompleted));
	CCHttpClient::getInstance()->send(request);
	request->release();
}
void MyHttpClient::executeFunction(int responseCode, const char* data)
{
	CCLuaEngine *engine = (CCLuaEngine*)CCScriptEngineManager::sharedManager()->getScriptEngine();
    CCLuaStack *stack = engine->getLuaStack();
	lua_State* m_state= stack->getLuaState();
	lua_pushinteger(m_state, responseCode);
	lua_pushstring(m_state,data);
	stack->executeFunctionByHandler(this->m_nHandler, 2);
}
void MyHttpClient::onHttpRequestCompleted(CCNode *sender, void *resp) {
	CCLog("onHttpRequestCompleted");
	CCHttpResponse *response = (CCHttpResponse*)resp;
	if (!response)
	{
		return;
	}
	int statusCode = response->getResponseCode();
	std::vector<char> *buffer = response->getResponseData();
	char data[buffer->size()+1];
	for (unsigned int i = 0; i < buffer->size(); i++)
	{
		data[i]=(*buffer)[i];
	}
	data[buffer->size()]='\0';
	this->executeFunction(statusCode, data);
}


