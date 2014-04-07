//
//  QCQuestionProvider.m
//  QuizCrush
//
//  Created by Arvid on 2014-04-03.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCQuestionProvider.h"

@implementation QCQuestionProvider

-(QCQuestion *) provideQuestionOfCategory:(NSNumber *) category{
    // TODO placeholder implementation
    
    QCQuestion *q = [[QCQuestion alloc] initWithCategory:@5
                                                    topic:@"Golf"
                                           questionString:@"Vilket folkslag uppfann en stamform till golf?"
                                                  answers:@[@"Romarna", @"Grekerna", @"Mayafolket", @"Aztekerna"]
                                       correctAnswerIndex:@0];

    NSLog(@"Kategori: %@", category);
    
    return q;
}

@end
