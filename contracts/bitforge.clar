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

;; Realm Registry
(define-map realms
  { realm-id: uint }
  {
    name: (string-ascii 50),
    description: (string-ascii 200),
    entry-level-requirement: uint,
    active-adventurers: uint,
    reward-multiplier: uint,
  }
)

;; Player Profiles
(define-map adventurer-profiles
  { adventurer: principal }
  {
    primary-hero-id: uint,
    lifetime-score: uint,
    victories: uint,
    bitcoin-earnings: uint,
    leaderboard-rank: uint,
    registration-block: uint,
  }
)

;; Additional validation functions for enhanced security
(define-private (is-valid-hero-id (hero-id uint))
  (and (> hero-id u0) (< hero-id (var-get next-hero-id)))
)

(define-private (is-valid-adventurer (adventurer principal))
  (and
    (is-standard adventurer)
    (is-some (get-adventurer-profile adventurer))
  )
)

(define-private (is-valid-string
    (text (string-ascii 200))
    (min-len uint)
    (max-len uint)
  )
  (and
    (>= (len text) min-len)
    (<= (len text) max-len)
    (> (len text) u0)
  )
)

(define-private (is-valid-rarity (rarity (string-ascii 20)))
  (or
    (is-eq rarity RARITY-COMMON)
    (is-eq rarity RARITY-UNCOMMON)
    (is-eq rarity RARITY-RARE)
    (is-eq rarity RARITY-EPIC)
    (is-eq rarity RARITY-LEGENDARY)
  )
)

(define-private (calculate-level-requirement (level uint))
  (* level level BASE-XP-MULTIPLIER)
)

(define-private (can-advance-level
    (current-xp uint)
    (current-level uint)
  )
  (>= current-xp (calculate-level-requirement (+ current-level u1)))
)

;; READ-ONLY FUNCTIONS

(define-read-only (is-authorized-operator (user principal))
  (or
    (is-eq user (var-get contract-owner))
    (default-to false (map-get? authorized-operators user))
  )
)

(define-read-only (get-artifact-info (artifact-id uint))
  (map-get? artifacts { artifact-id: artifact-id })
)

(define-read-only (get-hero-info (hero-id uint))
  (map-get? heroes { hero-id: hero-id })
)

(define-read-only (get-realm-info (realm-id uint))
  (map-get? realms { realm-id: realm-id })
)

(define-read-only (get-adventurer-profile (adventurer principal))
  (map-get? adventurer-profiles { adventurer: adventurer })
)

(define-read-only (get-protocol-statistics)
  {
    total-artifacts-forged: (- (var-get next-artifact-id) u1),
    total-heroes-created: (- (var-get next-hero-id) u1),
    total-realms-active: (- (var-get next-realm-id) u1),
    bitcoin-prize-pool: (var-get total-prize-pool),
    protocol-fee-bps: (var-get protocol-fee-bps),
  }
)

;; ADMINISTRATIVE FUNCTIONS

(define-public (initialize-bitforge-protocol)
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-UNAUTHORIZED)
    (map-set authorized-operators tx-sender true)
    (ok "BitForge Protocol Successfully Initialized")
  )
)

(define-public (authorize-operator (new-operator principal))
  (begin
    (asserts! (is-authorized-operator tx-sender) ERR-UNAUTHORIZED)
    (map-set authorized-operators new-operator true)
    (ok true)
  )
)

(define-public (update-protocol-fee (new-fee-bps uint))
  (begin
    (asserts! (is-authorized-operator tx-sender) ERR-UNAUTHORIZED)
    (asserts! (<= new-fee-bps u1000) ERR-INVALID-INPUT) ;; Max 10%
    (var-set protocol-fee-bps new-fee-bps)
    (ok true)
  )
)

;; CORE GAMEPLAY FUNCTIONS

(define-public (forge-artifact
    (name (string-ascii 50))
    (description (string-ascii 200))
    (rarity (string-ascii 20))
    (power-level uint)
    (realm-id uint)
  )
  (let ((artifact-id (var-get next-artifact-id)))
    (asserts! (is-authorized-operator tx-sender) ERR-UNAUTHORIZED)
    (asserts! (is-valid-string name MIN-NAME-LENGTH MAX-NAME-LENGTH)
      ERR-INVALID-INPUT
    )
    (asserts! (is-valid-string description u1 MAX-DESCRIPTION-LENGTH)
      ERR-INVALID-INPUT
    )
    (asserts! (is-valid-rarity rarity) ERR-INVALID-RARITY)
    (asserts! (and (> power-level u0) (<= power-level u1000)) ERR-INVALID-INPUT)
    (asserts! (is-some (get-realm-info realm-id)) ERR-NOT-FOUND)

    (try! (nft-mint? bitforge-artifact artifact-id tx-sender))

    (map-set artifacts { artifact-id: artifact-id } {
      name: name,
      description: description,
      rarity: rarity,
      power-level: power-level,
      origin-realm: realm-id,
      experience: u0,
      enhancement-level: u1,
      creation-block: stacks-block-height,
    })

    (var-set next-artifact-id (+ artifact-id u1))
    (ok artifact-id)
  )
)

(define-public (summon-hero
    (name (string-ascii 50))
    (starting-realm uint)
  )
  (let ((hero-id (var-get next-hero-id)))
    (asserts! (is-valid-string name MIN-NAME-LENGTH MAX-NAME-LENGTH)
      ERR-INVALID-INPUT
    )
    (asserts! (is-some (get-realm-info starting-realm)) ERR-NOT-FOUND)
    (asserts! (is-none (get-adventurer-profile tx-sender)) ERR-ALREADY-EXISTS)

    (try! (nft-mint? bitforge-hero hero-id tx-sender))

    (map-set heroes { hero-id: hero-id } {
      name: name,
      level: u1,
      total-experience: u0,
      equipped-artifacts: (list),
      explored-realms: (list starting-realm),
      achievement-points: u0,
      birth-block: stacks-block-height,
    })

    (map-set adventurer-profiles { adventurer: tx-sender } {
      primary-hero-id: hero-id,
      lifetime-score: u0,
      victories: u0,
      bitcoin-earnings: u0,
      leaderboard-rank: u0,
      registration-block: stacks-block-height,
    })

    (var-set next-hero-id (+ hero-id u1))
    (ok hero-id)
  )
)