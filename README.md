# RLP-iOS
The RLP rule is based on the source code of Ethereum.

# HOW TO USE
```
import "RLP-iOS.h"
```
### First we should change 'int','long' or 'NSString' into NSData,I have provided tools 'DataUtil' to convert.
```
NSData *data = [DataUtil longToData:987654321123456789];
//NSData *data = [DataUtil intToData:123];
//NSData *data = [DataUtil stringToData:@"Hello World"];
```
### Then use 'RLPUtil' to start RLP
```
NSData *element = [RLPUtil encodeElement:data];
NSData *list = [RLPUtil encodeList:@[element]];
```
