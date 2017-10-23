//
//  Model.m
//  baby
//
//  Created by zhang da on 14-2-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"
#import <objc/runtime.h>
#import "PropertyDescription.h"
#import "Parser.h"

@interface Model ()

@property (nonatomic, retain) NSMutableDictionary *internalData;

+ (NSString *)propertyNameFromSetterSelector:(SEL)aSelector;
+ (NSString *)propertyReflectName:(NSString *)perperty;

+ (BOOL)isClassPropertyName:(NSString *)propertyName;
+ (BOOL)isSelectorAPropertyAccessor:(SEL)aSelector;
+ (BOOL)isSelectorAPropertySetter:(SEL)aSelector;

+ (IMP)getterIMPForProperty:(PropertyDescription *)property;
+ (IMP)setterIMPForProperty:(PropertyDescription *)property;
+ (NSArray *)classProperties;

@end


@implementation Model

- (void)dealloc {
    //    self.internalData = nil;
//    [_internalData release];
    _internalData = nil;
    
//    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        //        self.internalData = [NSMutableDictionary dictionary];
        _internalData = [[NSMutableDictionary alloc] init];
    }
    return self;
}


//- (void)dealloc {
//  self.internalData = nil;
//    [super dealloc];
//}
//
//- (id)init {
//    self = [super init];
//    if (self) {
//        self.internalData = [NSMutableDictionary dictionary];
//    }
//    return self;
//}

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
//       self.internalData = [NSMutableDictionary dictionaryWithDictionary:dict];
        _internalData = [[NSMutableDictionary alloc] initWithDictionary:dict];
    }
    return self;
}

+ (NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = @{@"property_name": DEFAULT_KEY};
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    return nil;
}

+ (NSString *)primaryKey {
    return @"property_name";
}

- (NSMutableDictionary *)internalData {
    if (!_internalData) {
//        self.internalData = [NSMutableDictionary dictionary];
        _internalData = [[NSMutableDictionary alloc] init];
    }
    return _internalData;
}

- (void)updateFromDict:(NSDictionary *)dict updateType:(UpdateType)type {
    if (type == UpdateTypeMerge) {
        for (NSString *key in dict) {
//            if (!self.internalData[key]) {
//                self.internalData[key] = dict[key];
//            }
            if (!_internalData[key]) {
                _internalData[key] = dict[key];
            }
        }
    } else if (type == UpdateTypeReplace) {
//        self.internalData = [NSMutableDictionary dictionaryWithDictionary:dict];
        _internalData = [[NSMutableDictionary alloc] initWithDictionary:dict];
    }
}

- (NSDictionary *)exportData {
//    return self.internalData;
    return _internalData;
}

+ (Model *)instanceFromDict:(NSDictionary *)dict {
    return [[[self class] alloc] initWithDict:dict];
}

+ (NSPredicate *)predicateForProperty:(NSString *)propertyName value:(id)value {
    NSString *reflectName = [self propertyReflectName:propertyName];
    
    PropertyDescription *property = [PropertyDescription
                                     propertyDescriptionForProperty:propertyName
                                     reflectName:reflectName
                                     inClass:[self class]];
    switch (property.type) {
        case INT:
            return [NSPredicate predicateWithFormat:@"%@ = %d", propertyName, [value intValue]];
        case UNINT:
            return [NSPredicate predicateWithFormat:@"%@ = %u", propertyName, [value unsignedIntValue]];
        case FLOAT:
            return [NSPredicate predicateWithFormat:@"%@ = %f", propertyName, [value floatValue]];
        case DOUBLE:
            return [NSPredicate predicateWithFormat:@"%@ = %f", propertyName, [value doubleValue]];
        case CHAR:
            return [NSPredicate predicateWithFormat:@"%@ = %c", propertyName, [value charValue]];
        case UNCHAR:
            return [NSPredicate predicateWithFormat:@"%@ = %c", propertyName, [value unsignedCharValue]];
        case BOOLEAN:
            return [NSPredicate predicateWithFormat:@"%@ = %d", propertyName, [value boolValue]];
        case LONG:
            return [NSPredicate predicateWithFormat:@"%@ = %ld", propertyName, [value longValue]];
        case UNLONG:
            return [NSPredicate predicateWithFormat:@"%@ = %lu", propertyName, [value unsignedLongValue]];
        case SHORT:
            return [NSPredicate predicateWithFormat:@"%@ = %d", propertyName, [value shortValue]];
        case UNSHORT:
            return [NSPredicate predicateWithFormat:@"%@ = %u", propertyName, [value unsignedShortValue]];
        case LONGLONG:
            return [NSPredicate predicateWithFormat:@"%@ = %ld", propertyName, [value longLongValue]];
        case UNLONGLONG:
            return [NSPredicate predicateWithFormat:@"%@ = %lu", propertyName, [value unsignedLongLongValue]];
        case NSNUMBER:
        case NSSTRING:
        case NSDATE:
        case NSOBJECTOTHER:
        case CSTRING:
            return [NSPredicate predicateWithFormat:@"%@ = %@", propertyName, value];
        case SELECTOR:
        case UNKNOWN:
        case VOID:
        case STRUCT:
        default: break;
    }
    return nil;
}


#pragma mark - Private Methods
+ (NSArray *)classProperties {
    NSMutableArray *properties = [NSMutableArray array];
    unsigned int propertyCount, i;
    
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    for (i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];

        NSString *propertyName = [NSString stringWithCString:property_getName(property)
                                                    encoding:NSUTF8StringEncoding];
        NSString *reflectName = [self propertyReflectName:propertyName];
        PropertyDescription *propertyDescription = [[PropertyDescription alloc]
                                                    initWithProperty:property reflectName:reflectName];
        [properties addObject:propertyDescription.name];
//        [propertyDescription release];
    }
    
    free(propertyList);
    return properties;
}

+ (NSString *)propertyNameFromSetterSelector:(SEL)aSelector {
    NSString *selector = NSStringFromSelector(aSelector);
    
    // Make sure this is a setter
    if (selector.length <= 3) return nil;
    if (![[selector substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"set"]) return nil;
    if (![[selector substringWithRange:NSMakeRange(selector.length-1, 1)] isEqualToString:@":"]) return nil;
    
    NSString *potentialPropertyName = [selector substringWithRange:NSMakeRange(3, selector.length - 4)];
    
    // Make sure the first character is lowercase
    return [potentialPropertyName
            stringByReplacingCharactersInRange:NSMakeRange(0, 1)
            withString:[[potentialPropertyName substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
}

+ (NSString *)propertyReflectName:(NSString *)propertyName {
    NSString *reflectName = [[self propertyMapping] objectForKey:propertyName];
    if (!reflectName || [reflectName isEqualToString:DEFAULT_KEY]) {
        reflectName = propertyName;
    }
    return reflectName;
}

+ (BOOL)isClassPropertyName:(NSString *)propertyName {
    
    NSArray *classProperties = [self classProperties];
//    return ([classProperties indexOfObjectPassingTest:^BOOL(NSString *property, NSUInteger idx, BOOL *stop) {
//        BOOL propertyFound = [property isEqualToString:propertyName];
//        if (propertyFound) {
//            *stop = YES;
//            return YES;
//        }
//        return NO;
//    }] != NSNotFound);
    
    for (NSString *property in classProperties) {
        if ([property isEqualToString:propertyName]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isSelectorAPropertySetter:(SEL)aSelector {
    
    NSString *propertyName = [self propertyNameFromSetterSelector:aSelector];
    if (propertyName) {
        return [self isClassPropertyName:propertyName];
    }
    return NO;
    
}

+ (BOOL)isSelectorAPropertyAccessor:(SEL)aSelector {
    NSString *selector = NSStringFromSelector(aSelector);
    return [self isClassPropertyName:selector];
}


#pragma mark - kvo supporting
- (id)valueForKey:(NSString *)key {
    NSString *reflectName = [[self class] propertyReflectName:key];
    id obj = [self.internalData objectForKey:reflectName];
    if (!obj) {
        @try {
//            return [super valueForKey:key];
            return nil;
        }
        @catch (NSException *exception) {
            DLog(@"%@", exception);
        }
        @finally {
            return nil;
        }
    } else {
        return obj;
    }
}


#pragma mark - Generic Method Handling
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([self isSelectorAPropertyAccessor:sel]) {
        NSString *propertyName = NSStringFromSelector(sel);
        NSString *reflectName = [self propertyReflectName:propertyName];

        PropertyDescription *property = [PropertyDescription
                                         propertyDescriptionForProperty:propertyName
                                         reflectName:reflectName
                                         inClass:[self class]];
        
        IMP imp = [self getterIMPForProperty:property];
        if (imp) {
            class_addMethod([self class], sel, imp, property.getterImplementationTypeList);
            return YES;
        }
        return NO;
        
    } else if ([self isSelectorAPropertySetter:sel]) {
        NSString *propertyName = [self propertyNameFromSetterSelector:sel];
        NSString *reflectName = [self propertyReflectName:propertyName];

        PropertyDescription *property = [PropertyDescription
                                         propertyDescriptionForProperty:propertyName
                                         reflectName:reflectName
                                         inClass:[self class]];

        if (!property.isReadonly) {
            IMP imp = [self setterIMPForProperty:property];
            if (imp) {
                class_addMethod([self class], sel, imp, property.setterImplementationTypeList);
                return YES;
            }
            return NO;
        } else {
            return [super resolveInstanceMethod:sel];
        }
    }
    return [super resolveInstanceMethod:sel];
}

+ (IMP)setterIMPForProperty:(PropertyDescription *)property {
    IMP setter = NULL;
    switch (property.type) {
        case BOOLEAN:
        case INT:
        case UNINT: {
            setter = imp_implementationWithBlock(^(Model *me, int value) {
                if (value) {
                    me.internalData[property.reflectName] = @(value);
                }
            });
            break;
        }
        case FLOAT: {
            setter = imp_implementationWithBlock(^(Model *me, float value) {
                if (value) {
                    me.internalData[property.reflectName] = @(value);
                }
            });
            break;
        }
        case DOUBLE: {
            setter = imp_implementationWithBlock(^(Model *me, double value) {
                if (value) {
                    me.internalData[property.reflectName] = @(value);
                }
            });
            break;
        }
        case LONG:
        case UNLONG: {
            setter = imp_implementationWithBlock(^(Model *me, long value) {
                if (value) {
                    me.internalData[property.reflectName] = @(value);
                }
            });
            break;
        }
        case LONGLONG:
        case UNLONGLONG: {
            setter = imp_implementationWithBlock(^(Model *me, long long value) {
                if (value) {
                    me.internalData[property.reflectName] = @(value);
                }
            });
            break;
        }
        case SHORT:
        case UNSHORT: {
            setter = imp_implementationWithBlock(^(Model *me, short value) {
                if (value) {
                    me.internalData[property.reflectName] = @(value);
                }
            });
            break;
        }
        case CHAR:
        case UNCHAR: {
            setter = imp_implementationWithBlock(^(Model *me, char value) {
                if (value) {
                    me.internalData[property.reflectName] = @(value);
                }
            });
            break;
        }
        case SELECTOR: {
            setter = imp_implementationWithBlock(^(Model *me, SEL value) {
                if (value) {
                    me.internalData[property.reflectName] = NSStringFromSelector(value);
                }
            });
            break;
        }
        case CSTRING: {
            setter = imp_implementationWithBlock(^(Model *me, const char * value) {
                if (value) {
                    me.internalData[property.reflectName] =
                    [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
                }
            });
            break;
        }
        case NSNUMBER:
        case NSSTRING:
        case NSDATE:
        case NSOBJECTOTHER:
        case ARRAY: {
            setter = imp_implementationWithBlock(^(Model *me, id value) {
                if (value) {
                    me.internalData[property.reflectName] = value;
                }
            });
            break;
        }
        case UNKNOWN:
        case STRUCT:
        case VOID:
        default:
            break;
    }
    
    return setter;
}

+ (IMP)getterIMPForProperty:(PropertyDescription *)property {
    IMP getter = NULL;
    
    
    switch (property.type) {
        case INT: {
            getter = imp_implementationWithBlock(^(Model *me) {
                
                if (me.internalData[property.reflectName] == [NSNull null]) {
                    
                    return 0;
                }
                return [me.internalData[property.reflectName] intValue]; });
            break;
        }
        case UNINT: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] unsignedIntValue]; });
            break;
        }
        case FLOAT: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] floatValue]; });
            break;
        }
        case DOUBLE: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] doubleValue]; });
            break;
        }
        case CHAR: {
            getter = imp_implementationWithBlock(^(Model *me) {
                
                if (me.internalData[property.reflectName] == [NSNull null]) {
                    
                    return (char)0;
                }
                
                return [me.internalData[property.reflectName] charValue]; });
            
            break;
        }
        case UNCHAR: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] unsignedCharValue]; });
            break;
        }
        case BOOLEAN: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] boolValue]; });
            break;
        }
        case LONG: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] longValue]; });
            break;
        }
        case UNLONG: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] unsignedLongValue]; });
            break;
        }
        case SHORT: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] shortValue]; });
            break;
        }
        case UNSHORT: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] unsignedShortValue]; });
            break;
        }
        case LONGLONG: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] longLongValue]; });
            break;
        }
        case UNLONGLONG: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] unsignedLongLongValue]; });
            break;
        }
        case SELECTOR: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return NSSelectorFromString(me.internalData[property.reflectName]); });
            break;
        }
        case CSTRING: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return [me.internalData[property.reflectName] cStringUsingEncoding:NSUTF8StringEncoding]; });
            break;
        }
        case NSNUMBER: {
            getter = imp_implementationWithBlock(^(Model *me) {
                id value = me.internalData[property.reflectName];
                return [Parser parseNumber:value];
            });
            break;
        }
        case NSSTRING: {
            getter = imp_implementationWithBlock(^(Model *me) {
                id value = me.internalData[property.reflectName];
                return [Parser parseString:value];
            });
            break;
        }
        case NSDATE: {
            getter = imp_implementationWithBlock(^(Model *me) {
                id value = me.internalData[property.reflectName];
                NSString *format = [[self formatMapping] objectForKey:property.name];
                return [Parser parseDate:value format:format];
            });
            break;
        }
        case NSOBJECTOTHER: {
            getter = imp_implementationWithBlock(^(Model *me) {
                return me.internalData[property.reflectName]; });
            break;
        }
        case UNKNOWN:
        case VOID:
        case STRUCT:
        default: break;
    }
    
    return getter;
}

@end
