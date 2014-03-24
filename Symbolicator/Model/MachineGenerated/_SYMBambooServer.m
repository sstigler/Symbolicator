// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooServer.m instead.

#import "_SYMBambooServer.h"

const struct SYMBambooServerAttributes SYMBambooServerAttributes = {
	.url = @"url",
	.urlProtectionSpace = @"urlProtectionSpace",
	.version = @"version",
};

const struct SYMBambooServerRelationships SYMBambooServerRelationships = {
	.projects = @"projects",
};

const struct SYMBambooServerFetchedProperties SYMBambooServerFetchedProperties = {
};

@implementation SYMBambooServerID
@end

@implementation _SYMBambooServer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BambooServer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BambooServer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BambooServer" inManagedObjectContext:moc_];
}

- (SYMBambooServerID*)objectID {
	return (SYMBambooServerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"versionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"version"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic url;






@dynamic urlProtectionSpace;






@dynamic version;



- (int32_t)versionValue {
	NSNumber *result = [self version];
	return [result intValue];
}

- (void)setVersionValue:(int32_t)value_ {
	[self setVersion:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveVersionValue {
	NSNumber *result = [self primitiveVersion];
	return [result intValue];
}

- (void)setPrimitiveVersionValue:(int32_t)value_ {
	[self setPrimitiveVersion:[NSNumber numberWithInt:value_]];
}





@dynamic projects;

	
- (NSMutableSet*)projectsSet {
	[self willAccessValueForKey:@"projects"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"projects"];
  
	[self didAccessValueForKey:@"projects"];
	return result;
}
	






@end
