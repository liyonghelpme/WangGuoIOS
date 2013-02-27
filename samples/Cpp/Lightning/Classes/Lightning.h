#ifndef __LIGHTNING_H__
#define __LIGHTNING_H__
#include "cocos2d.h"
#include "kazmath/vec3.h"
#include "string"
using namespace std;
using namespace cocos2d;

class Line : public CCSprite
{
public:
    kmVec3 a, b;
    static Line *create(const char *fileName, kmVec3 &a, kmVec3 &b, float thickness);
};

class Lightning : public CCSpriteBatchNode
{
public:
    static Lightning *create(const char *fileImage, unsigned int capacity, float detail, float thickness, float displace);
    ~Lightning();
    void midDisplacement(float x1, float y1, float x2, float y2, float displace);
    void testLine(float x1, float y1, float x2, float y2);

private:

    CCArray *lines;

    float detail; //闪电的分段长度
    float thickness; //闪电的粗细
    float displace; //闪电的随机性
    string fileName;
};
#endif
