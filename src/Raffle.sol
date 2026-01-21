// Layout of Contract:
// license
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

/**
 * @title Raffle contract
 * @author Kuteesa Joash
 * @notice  This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */

contract Raffle {
    /** Errors */
    error Raffle__NotEnoughETHSent();

    uint256 private immutable I_ENTRANCE_FEE;

    constructor(uint256 entranceFee) {
        I_ENTRANCE_FEE = entranceFee;
    }

    function enterRaffle() public payable {
        // require(msg.value >= I_ENTRANCE_FEE, "Not enough ETH sent!");
        if (msg.value < I_ENTRANCE_FEE) {
            revert Raffle__NotEnoughETHSent();
        }
    }

    function pickWinner() public {}

    /** Getter functions */
    function getEntranceFee() external view returns (uint256) {
        return I_ENTRANCE_FEE;
    }
}
