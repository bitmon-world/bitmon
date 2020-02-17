pragma solidity ^0.5.0;

/**
 * @title BitmonBase
 * @dev The BitmonBase contains the base information for a Bitmon struct
 * @author eabz@polispay.org
 */
contract BitmonBase  {

    // The Bitmon struct is the ADN information defined at the born of a Bitmon.
    // This variables affect in-game experience and are used to fill the Breeding algorithm.
    // Bitmon data is encoded on a uint256 (32 bytes) element.
    struct Bitmon {
        uint32    bitmonId;        // Unique ID to identify this Bitmon
        uint32    fatherId;        // Father unique ID to trace parent line
        uint32    motherId;        // Mother unique ID to trace mother line
        uint32    birthHeight;     // BlockHeight of the network at Bitmon born.
        uint8     generation;      // Generation
        uint8     nature;          // Characteristics of the behaviour (between 1 to 30)
        uint8     specimen;        // Specie identifier
        uint8     variant;         // Color variants
        uint8     gender;          // Gender definition (female 1 or male 0)
        uint8     purity;          // Speciment purity (Between 0 and 100)
        uint8     H;               // Health
        uint8     A;               // Attack
        uint8     SA;              // Special attack
        uint8     D;               // Defense
        uint8     SD;              // Special defense
    }

}
