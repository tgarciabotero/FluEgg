from hec.script import *
from hec.io import *
from hec.heclib.util import *
from hec.heclib.dss import *
import java

f = open("D:/Sandusky/FluEgg_USGS/TempResults.txt","w")
myDss = HecDss.open("BallvilleDam_Updated.dss")
ts = myDss.get("D:\SANDUSKY\FLUEGG_USGS",1)
try:
 xval =  ts.numberValues
 x = ts.times
 y = ts.values
 hStr = '%d' % xval + '\t' + 'D:\SANDUSKY\FLUEGG_USGS' + '\t' + ts.units + '\t' + ts.type + '\n'

except:
 y = ts.yOrdinates
 y = y[0]
 x = ts.xOrdinates
 xval = ts.numberOrdinates
 hStr = '%d' % xval + '\t' + 'D:\SANDUSKY\FLUEGG_USGS' + '\t' + ts.xunits + '\t' + ts.yunits + '\n'

f.write(hStr)

i = 0

while i < xval:
 str = '%d' % x[i] + "," + '%.5f' % y[i] + "\n"
 f.write(str)
 i = i+1

myDss.done()
f.close()
