// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooProject.m instead.

#import "_SYMBambooProject.h"

const struct SYMBambooProjectAttributes SYMBambooProjectAttributes = {
	.key = @"key",
	.name = @"name",
};

const struct SYMBambooProjectRelationships SYMBambooProjectRelationships = {
	.plans = @"plans",
	.server = @"server",
};

const struct SYMBambooProjectFetchedProperties SYMBambooProjectFetchedProperties = {
};

@implementation SYMBambooProjectID
@end

@implementation _SYMBambooProject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BambooProject" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BambooProject";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BambooProject" inManagedObjectContext:moc_];
}

- (SYMBambooProjectID*)objectID {
	return (SYMBambooProjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic key;






@dynamic name;






@dynamic plans;

	
- (NSMutableSet*)plansSet {
	[self willAccessValueForKey:@"plans"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"plans"];
  
	[self didAccessValueForKey:@"plans"];
	return result;
}
	

@dynamic server;

	






@end
