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

contract Raffle is VRFConsumerBaseV2Plus {
    /** Errors */
    error Raffle__NotEnoughETHSent();
    error Raffle_TransferFailed();
    error Raffle__NotOpen();
    error Raffle__UpKeepNotNeeded(
        uint256 balance,
        uint256 playerslength,
        uint256 state
    );

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
    uint256 private sLasttimestamp;
    address payable[] private sPlayers;
    bytes32 private immutable I_KEY_HASH;
    uint256 private immutable I_SUBSCRIPTION_ID;
    uint32 private immutable I_CALLBACK_GAS_LIMIT;
    uint32 private constant NUMWORDS = 1;
    address private sRecentWinner;
    RaffleState private sRaffleState;

    /**Events  */
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    /** Modifiers */

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

        I_KEY_HASH = gasLane;
        I_SUBSCRIPTION_ID = subscriptionId;
        I_CALLBACK_GAS_LIMIT = callbackGasLimit;

        sLasttimestamp = block.timestamp;
        sRaffleState = RaffleState.OPEN;
    }

    function enterRaffle() external payable {
        // require(msg.value >= I_ENTRANCE_FEE, "Not enough ETH sent!");
        if (msg.value < I_ENTRANCE_FEE) {
            revert Raffle__NotEnoughETHSent();
        }
        if (sRaffleState != RaffleState.OPEN) {
            revert Raffle__NotOpen();
        }
        sPlayers.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    /**
 * @dev This is the function that the chainlink nodes will call if the lottery is ready to be picked 
 * The following should be true for this to happen:
 * 1. The time interval has passed between raffle runs 
 * 2. The lottery  is open
 * 3. The contract has ETH
 * 4. Implicitly, your subscription has LINK
 * @param  -ignored
 * @return  upKeepNeeded - true if its time to restart the lottery 
 * @return -ignored 
 
*/
    function checkUpKeep(
        bytes memory /*calldata*/
    ) public view returns (bool upKeepNeeded, bytes memory /*performData*/) {
        bool timeHasPassed = ((block.timestamp - sLasttimestamp) > I_INTERVAL);
        bool isOpen = sRaffleState == RaffleState.OPEN;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = sPlayers.length > 0;
        upKeepNeeded = timeHasPassed && isOpen && hasBalance && hasPlayers;

        return (upKeepNeeded, "");
    }

    function pickWinner(bytes calldata /* performData */) external {
        // check to see if enough time has passed
        (bool upKeepNeeded, ) = checkUpKeep("");
        if (!upKeepNeeded) {
            revert Raffle__UpKeepNotNeeded(
                address(this).balance,
                sPlayers.length,
                uint256(sRaffleState)
            );
        }
        sRaffleState = RaffleState.CALCULATING;

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: I_KEY_HASH,
                subId: I_SUBSCRIPTION_ID,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: I_CALLBACK_GAS_LIMIT,
                numWords: NUMWORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });
        s_vrfCoordinator.requestRandomWords(request);
    }

    // CEI Checks , Effects , Interactions Pattern

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {
        //Checks
        //conditionals
        //Effects
        uint256 indexOfWinner = randomWords[0] % sPlayers.length;
        address payable recentWinner = sPlayers[indexOfWinner];
        sRecentWinner = recentWinner;

        sRaffleState = RaffleState.OPEN;
        sPlayers = new address payable[](0);
        sLasttimestamp = block.timestamp;
        emit WinnerPicked(sRecentWinner);

        // Interactions(External contract Interactions)
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

    function getRaffleState() external view returns (RaffleState) {
        return sRaffleState;
    }
}
