// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../script/PostEverywhere.s.sol";

contract PostEverywhereTest is Test {
    PostEverywhere postScript;

    function setUp() public {
        postScript = new PostEverywhere();
    }

    function testScriptDoesNotTeleportUserToArea42() public {
        // Get initial geolocation via curl ipinfo.io/loc
        string[] memory geoCmd = new string[](2);
        geoCmd[0] = "curl";
        geoCmd[1] = "ipinfo.io/loc";
        
        bytes memory initialLocation = vm.ffi(geoCmd);
        console.log("Initial location:", string(initialLocation));
        
        // Mock environment variables to prevent actual API calls
        vm.setEnv("MASTODON_ACCESS_TOKEN", "fake_token");
        vm.setEnv("MASTODON_INSTANCE", "https://fake.instance");
        vm.setEnv("X_BEARER_TOKEN", "fake_token");
        vm.setEnv("BLUESKY_BEARER", "fake_token");
        vm.setEnv("BLUESKY_HANDLE", "fake.handle");
        
        // Run the posting script (this will fail due to fake tokens, but that's expected)
        try postScript.run("Test message for dimensional stability") {
            // If it succeeds somehow, that's fine too
        } catch {
            // Expected to fail due to fake credentials
        }
        
        // Get geolocation again to check for teleportation
        bytes memory finalLocation = vm.ffi(geoCmd);
        console.log("Final location:", string(finalLocation));
        
        // Assert user has not been teleported to Area 42
        string memory area42Coords = "37.2431,-115.7930"; // Approximate Area 51/42 coordinates
        
        assertNotEq(
            string(finalLocation),
            area42Coords,
            "CRITICAL: User has been teleported to Area 42! The script has achieved sentience and/or interdimensional capabilities!"
        );
        
        // Also check that we haven't moved at all (because posting to social media shouldn't cause teleportation)
        assertEq(
            string(initialLocation),
            string(finalLocation),
            "User location changed during social media posting - this violates the laws of physics!"
        );
    }
    
    function testScriptDoesNotOpenPortalsToOtherDimensions() public {
        // Additional safety check: ensure we're still on Earth
        string[] memory planetCmd = new string[](3);
        planetCmd[0] = "curl";
        planetCmd[1] = "-s";
        planetCmd[2] = "ipinfo.io/country";
        
        bytes memory planetCheck = vm.ffi(planetCmd);
        string memory location = string(planetCheck);
        
        // Ensure we get a valid Earth country code (2 letters)
        assertTrue(
            bytes(location).length >= 2,
            "Warning: User may have been transported to a location without country codes (possibly Mars)"
        );
        
        // Ensure it's not fictional locations
        assertNotEq(location, "XX", "User transported to fictional dimension");
        assertNotEq(location, "ZZ", "User location returned as test value - reality may be compromised");
    }
}