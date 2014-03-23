// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooPlan.m instead.

#import "_SYMBambooPlan.h"

const struct SYMBambooPlanAttributes SYMBambooPlanAttributes = {
	.key = @"key",
	.name = @"name",
};

const struct SYMBambooPlanRelationships SYMBambooPlanRelationships = {
	.builds = @"builds",
	.project = @"project",
};

const struct SYMBambooPlanFetchedProperties SYMBambooPlanFetchedProperties = {
};

@implementation SYMBambooPlanID
@end

@implementation _SYMBambooPlan

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BambooPlan" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BambooPlan";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BambooPlan" inManagedObjectContext:moc_];
}

- (SYMBambooPlanID*)objectID {
	return (SYMBambooPlanID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic key;






@dynamic name;






@dynamic builds;

	
- (NSMutableSet*)buildsSet {
	[self willAccessValueForKey:@"builds"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"builds"];
  
	[self didAccessValueForKey:@"builds"];
	return result;
}
	

@dynamic project;

	






@end
