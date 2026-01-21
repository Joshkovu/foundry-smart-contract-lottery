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
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

///home/joash/Documents/Smart-contracts/foundry-smart-contract-lottery/lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol
/**
 * @title Raffle contract
 * @author Kuteesa Joash
 * @notice  This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */

abstract contract Raffle is VRFConsumerBaseV2Plus {
    /** Errors */
    error Raffle__NotEnoughETHSent();
    error Raffle_TransferFailed();
    error Raffle__NotOpen();

    /* Type declarations */
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    /** State variables */

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint256 private immutable I_ENTRANCE_FEE;
    // @dev the duration of the lottery in seconds
    uint256 private immutable I_INTERVAL;
    uint256 private S_LASTTIMESTAMP;
    address payable[] private S_PLAYERS;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUMWORDS = 1;
    address private s_recentWinner;
    RaffleState private S_RAFFLESTATE;

    /**Events  */
    event RaffleEntered(address indexed player);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        I_ENTRANCE_FEE = entranceFee;
        I_INTERVAL = interval;

        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        S_LASTTIMESTAMP = block.timestamp;
        S_RAFFLESTATE = RaffleState.OPEN;
    }

    function enterRaffle() external payable {
        // require(msg.value >= I_ENTRANCE_FEE, "Not enough ETH sent!");
        if (msg.value < I_ENTRANCE_FEE) {
            revert Raffle__NotEnoughETHSent();
        }
        if (S_RAFFLESTATE != RaffleState.OPEN) {
            revert Raffle__NotOpen();
        }
        S_PLAYERS.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external {
        // check to see if enough time has passed
        if ((block.timestamp - S_LASTTIMESTAMP) > I_INTERVAL) {
            revert();
        }
        S_RAFFLESTATE = RaffleState.CALCULATING;

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUMWORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    function fullfillRandomWords(
        uint256 requestedId,
        uint256[] calldata randomWords
    ) internal virtual {
        uint256 indexOfWinner = randomWords[0] % S_PLAYERS.length;
        address payable recentWinner = S_PLAYERS[indexOfWinner];
        s_recentWinner = recentWinner;
        S_RAFFLESTATE = RaffleState.OPEN;
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle_TransferFailed();
        }
    }

    /**
     * Getter functions
     */
    function getEntranceFee() external view returns (uint256) {
        return I_ENTRANCE_FEE;
    }
}
