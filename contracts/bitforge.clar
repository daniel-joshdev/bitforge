;; BitForge Protocol
;;
;; Bitcoin-Native Gaming Infrastructure on Stacks
;;
;; BitForge leverages Bitcoin's security through Stacks to create the first truly
;; decentralized gaming economy. Build legendary artifacts, develop persistent 
;; heroes, and compete in Bitcoin-secured tournaments where skill determines 
;; rewards and ownership is guaranteed by the world's most secure blockchain.
;;
;; Core Features:
;; - True Digital Ownership - All assets secured by Bitcoin's immutable ledger
;; - Cross-Game Compatibility - Items and characters transcend individual games  
;; - Merit-Based Rewards - Earnings tied directly to skill and participation
;; - Community Governance - Player-driven tournament and reward structures
;; - Persistent Progression - Character development across the entire ecosystem
;; - Bitcoin Settlement - Final value settlement on the Bitcoin network
;;
;; Built for the Bitcoin economy, powered by Stacks smart contracts.

;; ERROR CONSTANTS

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-ASSET (err u101))
(define-constant ERR-INSUFFICIENT-FUNDS (err u102))
(define-constant ERR-INVALID-INPUT (err u103))
(define-constant ERR-NOT-FOUND (err u104))
(define-constant ERR-ALREADY-EXISTS (err u105))
(define-constant ERR-MAX-LIMIT-REACHED (err u106))
(define-constant ERR-INVALID-RARITY (err u107))

;; PROTOCOL CONSTANTS

;; Character & Progression Limits
(define-constant MAX-HERO-LEVEL u100)
(define-constant BASE-XP-MULTIPLIER u100)
(define-constant MAX-LEADERBOARD-SIZE u100)

;; String Validation
(define-constant MIN-NAME-LENGTH u3)
(define-constant MAX-NAME-LENGTH u50)
(define-constant MAX-DESCRIPTION-LENGTH u200)

;; Artifact Rarity Classifications
(define-constant RARITY-COMMON "common")
(define-constant RARITY-UNCOMMON "uncommon")
(define-constant RARITY-RARE "rare")
(define-constant RARITY-EPIC "epic")
(define-constant RARITY-LEGENDARY "legendary")

;; STATE VARIABLES

(define-data-var protocol-fee-bps uint u25) ;; Fee in basis points (0.25%)
(define-data-var next-artifact-id uint u1)
(define-data-var next-hero-id uint u1)
(define-data-var next-realm-id uint u1)
(define-data-var total-prize-pool uint u0)
(define-data-var contract-owner principal tx-sender)

;; DATA STRUCTURES & MAPS

;; Access Control
(define-map authorized-operators
  principal
  bool
)

;; Non-Fungible Tokens
(define-non-fungible-token bitforge-artifact uint)
(define-non-fungible-token bitforge-hero uint)

;; Artifact Registry
(define-map artifacts
  { artifact-id: uint }
  {
    name: (string-ascii 50),
    description: (string-ascii 200),
    rarity: (string-ascii 20),
    power-level: uint,
    origin-realm: uint,
    experience: uint,
    enhancement-level: uint,
    creation-block: uint,
  }
)

;; Hero Registry  
(define-map heroes
  { hero-id: uint }
  {
    name: (string-ascii 50),
    level: uint,
    total-experience: uint,
    equipped-artifacts: (list 5 uint),
    explored-realms: (list 10 uint),
    achievement-points: uint,
    birth-block: uint,
  }
)