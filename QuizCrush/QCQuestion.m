//
//  QCQuestion.m
//  QuizCrush
//
//  Created by Arvid on 2014-04-03.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCQuestion.h"

@implementation QCQuestion

-(id) initWithCategory:(NSNumber *) category
                 topic:(NSString *) topic
        questionString:(NSString *) questionString
               answers:(NSArray *) answers
    correctAnswerIndex:(NSNumber *) corrextAnswerIndex {
    
    if (!(self = [super init])) {
        return self;
    }
    
    _category = category;
    _topic = topic;
    _questionString = questionString;
    _answers = answers;
    _correctAnswerIndex = corrextAnswerIndex;
    
    return self;
}

-(NSString *) description {
    
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"Topic: %@\nQuestion: %@\nChoices:\n", _topic, _questionString];
    for (int i = 0; i < [_answers count]; i++) {
        [string appendFormat:@"%d - %@\n", i, _answers[i]];
    }
    
    [string appendFormat:@"Correct answer: %@", _correctAnswerIndex];
    
    return string;
}


@end
