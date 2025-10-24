// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

import "forge-std/Script.sol";

contract PostEverywhere is Script {
    function run(string memory msgText) external {
        vm.startBroadcast();

        // --- Validate message ---
        if (bytes(msgText).length == 0) {
            console.log("Error: No message provided. Usage: forge script script/PostEverywhere.s.sol --sig 'run(string)' 'Your message here'");
            return;
        }

        // --- Read credentials from environment variables ---
        string memory mastodonToken = vm.envString("MASTODON_ACCESS_TOKEN");
        string memory mastodonInstance = vm.envString("MASTODON_INSTANCE");
        string memory xToken = vm.envString("X_BEARER_TOKEN");
        string memory blueskyBearer = vm.envString("BLUESKY_BEARER");
        string memory blueskyHandle = vm.envString("BLUESKY_HANDLE");

        // --- Mastodon ---
        {
            string[] memory mastodonCmd = new string[](11);
            mastodonCmd[0] = "curl";
            mastodonCmd[1] = "-s";
            mastodonCmd[2] = "-X";
            mastodonCmd[3] = "POST";
            mastodonCmd[4] = "-H";
            mastodonCmd[5] = string.concat("Authorization: Bearer ", mastodonToken);
            mastodonCmd[6] = "-H";
            mastodonCmd[7] = "Content-Type: application/json";
            mastodonCmd[8] = "-d";
            mastodonCmd[9] = string.concat('{"status":"', msgText, '"}');
            mastodonCmd[10] = string.concat(mastodonInstance, "/api/v1/statuses");

            bytes memory mastodonRes = vm.ffi(mastodonCmd);
            console.log("\nMastodon response:");
            console.log(string(mastodonRes));
        }

        // --- X (Twitter) ---
        {
            string[] memory xCmd = new string[](11);
            xCmd[0] = "curl";
            xCmd[1] = "-s";
            xCmd[2] = "-X";
            xCmd[3] = "POST";
            xCmd[4] = "-H";
            xCmd[5] = string.concat("Authorization: Bearer ", xToken);
            xCmd[6] = "-H";
            xCmd[7] = "Content-Type: application/json";
            xCmd[8] = "-d";
            xCmd[9] = string.concat('{"text":"', msgText, '"}');
            xCmd[10] = "https://api.twitter.com/2/tweets";

            bytes memory xRes = vm.ffi(xCmd);
            console.log("\nX response:");
            console.log(string(xRes));
        }

        // --- Bluesky ---
        {
            string[] memory blueCmd = new string[](11);
            blueCmd[0] = "curl";
            blueCmd[1] = "-s";
            blueCmd[2] = "-X";
            blueCmd[3] = "POST";
            blueCmd[4] = "-H";
            blueCmd[5] = string.concat("Authorization: Bearer ", blueskyBearer);
            blueCmd[6] = "-H";
            blueCmd[7] = "Content-Type: application/json";
            blueCmd[8] = "-d";
            blueCmd[9] = string.concat(
                '{"repo":"', blueskyHandle,
                '","collection":"app.bsky.feed.post","record":{"text":"', msgText, '"}}'
            );
            blueCmd[10] = "https://bsky.social/xrpc/com.atproto.repo.createRecord";

            bytes memory blueRes = vm.ffi(blueCmd);
            console.log("\nBluesky response:");
            console.log(string(blueRes));
        }

        vm.stopBroadcast();
    }
}
