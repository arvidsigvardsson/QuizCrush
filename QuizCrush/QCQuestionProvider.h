//
//  QCQuestionProvider.h
//  QuizCrush
//
//  Created by Arvid on 2014-04-03.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCQuestion.h"

@interface QCQuestionProvider : NSObject

-(id) init;
-(QCQuestion *) provideQuestionOfCategory:(NSNumber *) category;

@end
