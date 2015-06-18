.PHONY: MongoDB.prefPane debug clean

MongoDB.prefPane:
	xcodebuild -project MongoDB.prefPane.xcodeproj -configuration "Release" $(XC_OPTIONS) build

debug:
	xcodebuild -project MongoDB.prefPane.xcodeproj -configuration "Debug" $(XC_OPTIONS) build

clean:
	@rm -rf ./build

# other way to clean (slower though)
#xcodebuild -project MongoDB.prefPane.xcodeproj -configuration "Release" clean
#xcodebuild -project MongoDB.prefPane.xcodeproj -configuration "Debug" clean
