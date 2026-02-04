## 🎟 Foundry Smart Lottery
# 📖 Description

Foundry Smart Lottery is a decentralized raffle (lottery) game built using Foundry and Chainlink VRF to ensure provably fair randomness.

Participants must send a specified amount of ETH to enter the raffle. Once entered, players are assigned entries in the game, and when the raffle period ends, random numbers are generated using Chainlink VRF. These random values are then used to securely and fairly select a winner.

By leveraging Chainlink VRF, the lottery avoids predictable or manipulable randomness, ensuring:

- Transparency

- Fairness

- Resistance to miner or validator manipulation

This project focuses on real-world smart contract design, where trust minimization, security, and correctness are critical.

# 📑 Table of Contents

- Getting Started

- Project Structure

-  What I Learned

- Notes & Contributions

## 🚀 Getting Started
# Prerequisites

Ensure you have:

- Git

- Foundry

- MetaMask wallet

- Alchemy RPC URL

- Chainlink VRF subscription

- Testnet LINK

# Installation & Setup
```
# Clone the repository
git clone https://github.com/Joshkovu/foundry-smart-contract-lottery.git
cd foundry-smart-contract-lottery

# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test -vvv
```
# 🗂 Project Structure

Sample structure — update to match your repository.

```
├── src/
│   └── Raffle.sol              # Core lottery contract
│
├── script/
│   ├── DeployRaffle.s.sol      # Deployment script
│   └── HelperConfig.s.sol      # Network & VRF configuration
|   └── Interactions.s.sol 
│
├── test/
│   ├── unit/
│   │   └── RaffleTest.t.sol    # Unit tests
|   |   └── InteractionsTest.t.sol 
│   └── integration/
│       └── integration.t.sol
|   └── mocks/
|       └── LinkToken.sol 
│
├── lib/
│   └── chainlink-brownie-contracts/
│   └── forge-std/
│   └── foundry-devops/
│   └── solmate/
│
├── foundry.toml
└── README.md
```
# 🧠 What I Learned

This project deepened my understanding of oracles, randomness, and clean smart contract architecture.

# 🎲 Chainlink VRF (Verifiable Random Function)

- Learned how to integrate Chainlink VRF for secure randomness

- Created and managed a VRF subscription

- Funded the subscription using LINK

- Understood how randomness requests and callbacks work on-chain

- Learned why on-chain pseudo-randomness (e.g. block.timestamp) is insecure

# 🧱 Contract & Function Layout (Clean Architecture)

I learned how to structure smart contracts for clarity, maintainability, and audit-readiness by following a well-defined layout:
```
📐 Contract Layout
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
```

This layout:

- Makes contracts easier to read and audit

- Helps reviewers quickly find critical logic

- Encourages consistency across large codebases
```
🔧 Function Layout
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions
```

This function ordering:

- Separates user-facing logic from internal logic

- Improves readability and reasoning about control flow

- Helps avoid accidental misuse of functions

# 🧪 Testing & Reliability

- Wrote unit and integration tests for raffle logic

- Tested edge cases such as:

- Entering without enough ETH

- Picking a winner with multiple participants

- Gained confidence in building systems that handle real value

# 📝 Notes & Contributions

If you notice any issues, bugs, or potential improvements:

Please open an issue in the Issues section

I’ll review it and address it as soon as possible

Feedback and contributions are always welcome 

# 🙌 Appreciation

If you appreciate this project and my work, feel free to connect with me on my socials:

[![Joash_Kuteesa Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://x.com/JoashKutee80790)
[![Joash_Kuteesa Linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/joshkovu/)
