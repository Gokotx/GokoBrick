
//
//  DefineTools.h
//  RouterTest
//
//  Created by Goko on 28/07/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#ifndef DefineTools_h
#define DefineTools_h


#define TotalParams(firstParam) ({\
    NSMutableArray * paramArray = [[NSMutableArray alloc]init];\
    va_list argList;\
    if (firstParam) {\
        [paramArray addObject:firstParam];\
        va_start(argList, firstParam);\
        id tempObject;\
        while ((tempObject = va_arg(argList, id))) {\
            [paramArray addObject:tempObject];\
        }\
        va_end(argList);\
    }\
    paramArray;\
});


#endif /* DefineTools_h */
