# BitForge Protocol

**Bitcoin-Native Gaming Infrastructure on Stacks**

[![Clarity Version](https://img.shields.io/badge/clarity-3-brightgreen.svg)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/daniel-joshdev/bitforge)

BitForge leverages Bitcoin's security through Stacks to create the first truly decentralized gaming economy. Build legendary artifacts, develop persistent heroes, and compete in Bitcoin-secured tournaments where skill determines rewards and ownership is guaranteed by the world's most secure blockchain.

## 🎮 Core Features

- **True Digital Ownership** - All assets secured by Bitcoin's immutable ledger
- **Cross-Game Compatibility** - Items and characters transcend individual games  
- **Merit-Based Rewards** - Earnings tied directly to skill and participation
- **Community Governance** - Player-driven tournament and reward structures
- **Persistent Progression** - Character development across the entire ecosystem
- **Bitcoin Settlement** - Final value settlement on the Bitcoin network

## 🏗️ Architecture

### Smart Contract Components

#### Non-Fungible Tokens (NFTs)

- **Artifacts** (`bitforge-artifact`) - Unique gaming items with power levels and rarity
- **Heroes** (`bitforge-hero`) - Player characters with progression and equipment

#### Core Game Mechanics

- **Artifact Forging** - Create unique items with specific rarities and power levels
- **Hero Summoning** - Create persistent characters for cross-game adventures
- **Realm Establishment** - Create gaming environments with entry requirements
- **Experience System** - Level-based progression with XP requirements
- **Achievement Tracking** - Player scores and victory counts

#### Asset Management

- **Secure Transfers** - Owner-verified NFT transfers
- **Authorization System** - Multi-operator contract management
- **Protocol Fees** - Configurable fee structure (default 0.25%)

## 🚀 Getting Started

### Prerequisites

- [Clarinet CLI](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Node.js](https://nodejs.org/) v16+ - For running tests
- [Git](https://git-scm.com/) - Version control

### Installation

```bash
# Clone the repository
git clone https://github.com/daniel-joshdev/bitforge.git
cd bitforge

# Install dependencies
npm install

# Check contract syntax
clarinet check

# Run tests
npm test
```

### Development Setup

```bash
# Start Clarinet console for contract interaction
clarinet console

# Format contract code
clarinet fmt --in-place

# Run tests with coverage
npm run test:report

# Watch for changes and auto-test
npm run test:watch
```

## 📖 Contract API

### Core Functions

#### Artifact Management

```clarity
;; Forge a new artifact
(forge-artifact 
  name description rarity power-level realm-id)

;; Transfer artifact ownership
(transfer-artifact artifact-id recipient)

;; Get artifact information
(get-artifact-info artifact-id)
```

#### Hero Management

```clarity
;; Summon a new hero
(summon-hero name starting-realm)

;; Transfer hero ownership
(transfer-hero hero-id recipient)

;; Award experience points
(award-experience hero-id xp-amount)

;; Get hero information
(get-hero-info hero-id)
```

#### Realm Operations

```clarity
;; Create a new realm
(establish-realm 
  name description entry-level reward-multiplier)

;; Get realm information
(get-realm-info realm-id)
```

#### Player Profiles

```clarity
;; Get player profile
(get-adventurer-profile adventurer)

;; Update player score
(update-adventurer-score adventurer score-gained)
```

### Administrative Functions

```clarity
;; Initialize protocol (owner only)
(initialize-bitforge-protocol)

;; Authorize new operators
(authorize-operator new-operator)

;; Update protocol fees
(update-protocol-fee new-fee-bps)
```

### Read-Only Functions

```clarity
;; Check operator authorization
(is-authorized-operator user)

;; Get protocol statistics
(get-protocol-statistics)
```

## 🎯 Game Mechanics

### Artifact System

**Rarity Levels:**

- `common` - Basic items with standard power
- `uncommon` - Enhanced items with increased capabilities
- `rare` - Powerful items with special properties
- `epic` - Elite items with significant bonuses
- `legendary` - Mythical items with maximum power

**Power Scaling:** 1-1000 power level range with realm-specific origins

### Hero Progression

**Level System:**

- Maximum level: 100
- XP requirement formula: `level² × 100`
- Equipment slots: 5 artifacts maximum
- Exploration tracking: Up to 10 realms

**Achievement Points:**

- Victory-based scoring
- Lifetime score accumulation
- Leaderboard ranking system

### Economic Model

**Protocol Fees:**

- Default: 25 basis points (0.25%)
- Maximum: 1000 basis points (10%)
- Configurable by authorized operators

**Bitcoin Integration:**

- Prize pool accumulation
- Settlement on Bitcoin network
- Stacks-secured transactions

## 🧪 Testing

The project includes comprehensive test coverage using Vitest and Clarinet SDK:

```bash
# Run all tests
npm test

# Run tests with coverage report
npm run test:report

# Watch mode for development
npm run test:watch
```

### Test Structure

```
tests/
├── bitforge.test.ts    # Main contract tests
└── helpers/            # Test utilities
```

## 🔧 Configuration

### Network Settings

The protocol is configured for multiple networks:

- **Devnet** - Local development and testing
- **Testnet** - Public testing environment  
- **Mainnet** - Production deployment

Configuration files are located in the `settings/` directory.

### Contract Constants

Key protocol parameters:

```clarity
;; Character limits
MAX-HERO-LEVEL: 100
BASE-XP-MULTIPLIER: 100
MAX-LEADERBOARD-SIZE: 100

;; String validation
MIN-NAME-LENGTH: 3
MAX-NAME-LENGTH: 50
MAX-DESCRIPTION-LENGTH: 200

;; Economic parameters
DEFAULT-PROTOCOL-FEE: 25 basis points
MAX-PROTOCOL-FEE: 1000 basis points
```

## 🤝 Contributing

We welcome contributions to BitForge! Please follow these guidelines:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Clarity best practices
- Add comprehensive tests for new features
- Update documentation for API changes
- Use descriptive commit messages
- Ensure all tests pass before submitting PR

## 📋 Roadmap

### Phase 1: Core Protocol ✅

- [x] Basic NFT infrastructure
- [x] Hero and artifact systems
- [x] Realm management
- [x] Experience and progression

### Phase 2: Advanced Features 🚧

- [ ] Tournament system
- [ ] Cross-realm interactions
- [ ] Enhanced artifact crafting
- [ ] Guild mechanics

### Phase 3: Bitcoin Integration 📋

- [ ] Lightning Network integration
- [ ] Bitcoin settlement layer
- [ ] Cross-chain asset bridges
- [ ] Decentralized marketplace

### Phase 4: Ecosystem Expansion 📋

- [ ] Game developer SDK
- [ ] Third-party integrations
- [ ] Mobile wallet support
- [ ] Community governance tools

## 🔒 Security

BitForge implements multiple security layers:

- **Authorization Checks** - Multi-operator permission system
- **Input Validation** - Comprehensive parameter checking
- **Overflow Protection** - Safe arithmetic operations
- **Access Control** - Owner and operator restrictions

### Audit Status

- **Internal Review**: ✅ Complete
- **External Audit**: 📋 Planned
- **Bug Bounty**: 📋 Coming Soon

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌐 Links

- **Documentation**: [docs.bitforge.com](https://docs.bitforge.com)
- **Website**: [bitforge.com](https://bitforge.com)
- **Discord**: [discord.gg/bitforge](https://discord.gg/bitforge)
- **Twitter**: [@BitForgeGaming](https://twitter.com/BitForgeGaming)

## 📊 Statistics

```clarity
;; Get current protocol statistics
(get-protocol-statistics)
;; Returns:
;; {
;;   total-artifacts-forged: uint,
;;   total-heroes-created: uint,
;;   total-realms-active: uint,
;;   bitcoin-prize-pool: uint,
;;   protocol-fee-bps: uint
;; }
```
