//
//  NSDictionary+XZAdditions.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/4.
//

#import "NSDictionary+XZAdditions.h"

BOOL xz_isNull(id obj){
    return !obj || obj == [NSNull null];
}
BOOL xz_isEmptyString(NSString *string){
    return xz_isNull(string) || [string length] == 0;
}

NSString * xz_makeSureString(NSString *str){
    if([str isKindOfClass:[NSString class]]) return str;
    if([str isKindOfClass:[NSNumber class]]) return [(NSNumber*)str stringValue];
    return @"";
}
NSDictionary * xz_makeSureDictionary(NSDictionary *dic ){
    return [dic isKindOfClass:[NSDictionary class]]?dic:@{};
}
NSArray * xz_makeSureArray(NSArray *array ){
    return [array isKindOfClass:[NSArray class]]?array:@[];
}

@implementation NSDictionary (XZAdditions)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (id)xz_objectForAnyKeys:(NSArray*)keys{
    for (NSString * key in keys) {
        NSString * val = [self objectForKey:key];
        if(val) return val;
    }
    return nil;
}
- (NSString *)xz_stringForAnyKeys:(NSArray*)keys{
    for (NSString * key in keys) {
        NSString * val = [self xz_stringForKey:key];
        if(!xz_isEmptyString(val)) return val;
    }
    return @"";
}
- (NSString *)xz_stringForKey:(NSString *)key{
    return xz_makeSureString([self objectForKey:key]);
}

- (NSDictionary *)xz_dicForKey:(NSString *)key{
    return xz_makeSureDictionary([self objectForKey:key]);
}

- (NSArray *)xz_arrayForKey:(NSString *)key{
    return xz_makeSureArray([self objectForKey:key]);
}

@end
