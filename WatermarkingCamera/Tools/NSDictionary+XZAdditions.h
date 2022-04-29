//
//  NSDictionary+XZAdditions.h
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (XZAdditions)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
- (id)xz_objectForAnyKeys:(NSArray*)keys;
- (NSString *)xz_stringForAnyKeys:(NSArray*)keys;
- (NSString *)xz_stringForKey:(NSString *)key;
- (NSDictionary *)xz_dicForKey:(NSString *)key;
- (NSArray *)xz_arrayForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
