// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {CreateSubscription} from "script/Interactions.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract InteractionsTest is Test {
    HelperConfig helperConfig;
    uint256 public subId;
    address public vrfCoordinator;

    function setUp() external {
        console.log("Setting up test...");

        helperConfig = new HelperConfig();

        console.log("Setup complete!");
    }

    function test_Create_Subscription_Is_Valid() public {
        // Arrange
        CreateSubscription createSubscription = new CreateSubscription();

        // Get the config once for clarity
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        // Act
        (uint256 newSubId, address resultVrfCoordinator) = createSubscription
            .createSubscription(config.vrfCoordinator, config.account);

        // Assert
        assert(newSubId > 0);
        assert(resultVrfCoordinator == config.vrfCoordinator);

        console.log("Subscription ID:", newSubId);
        console.log("VRF Coordinator:", resultVrfCoordinator);
    }
}
