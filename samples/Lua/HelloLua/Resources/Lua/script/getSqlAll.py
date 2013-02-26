#coding:utf8
import json
import MySQLdb
import os
import re 
key = re.compile('(\["(\d+)"\])')

sqlName = ["GameParam", "building"]

con = MySQLdb.connect(host='localhost', user='root', passwd='badperson3', db='Wan2', charset='utf8')


def hanData(name, f, CostData):
    names = []
    res = {}
    if name == 'GameParam':
        for i in f:
            res[i['key']] = i['value']
    elif name == 'building':
        for i in f:
            i = dict(i)
            if i.get('name') != None and i.get('id') != None:
                i['name'] = name+str(i['id'])
            if i.get('engName') != None:
                i.pop('engName')
            
            if i.get('hasNum') != None:
                if i['hasNum']:
                    i['numCost'] = json.loads(i['numCost'])
                else:
                    i['numCost'] = []
            
            res[i['id']] = i
        
    temp = open('temp.json', 'w')
    temp.write(json.dumps(res))
    temp.close()

    os.system('./json2lua -n < temp.json > out.lua ')
    out = open('out.lua', 'r')
    out = out.read()
    mat = key.findall(out)
    #print mat
    for i in mat:
        out = out.replace(i[0], "["+i[1]+"]")

    print 'local', name, '=', out

    CostData[name] = name

    return names




def main():
    allNames = []
    CostData = {}
    for i in sqlName:
        sql = 'select * from %s' % (i)
        con.query(sql)
        res = con.store_result().fetch_row(0, 1)
        allNames += hanData(i, res, CostData)

    
    temp = open('temp.json', 'w')
    temp.write(json.dumps(CostData))
    temp.close()

    os.system('./json2lua < temp.json > out.lua ')
    out = open('out.lua', 'r')
    out = out.read()
    out = out.replace('"', '')
    print 'CostData', '=', out 


main()

con.commit()
con.close()
