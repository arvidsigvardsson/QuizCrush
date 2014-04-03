//
//  QCQuestion.h
//  QuizCrush
//
//  Created by Arvid on 2014-04-03.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCQuestion : NSObject

@property NSNumber *category;
@property NSString *topic;
@property NSString *questionString;
@property NSArray *answers;
@property NSNumber *correctAnswerIndex;

-(id) initWithCategory:(NSNumber *) category
                 topic:(NSString *) topic
        questionString:(NSString *) questionString
               answers:(NSArray *) answers
    correctAnswerIndex:(NSNumber *) corrextAnswerIndex;
@end
