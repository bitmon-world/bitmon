pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./BitmonBase.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/roles/MinterRole.sol";
import "./utils/seriality/Seriality.sol";


/**
 * @title BitmonCore
 * @dev The BitmonCore contains the resources for call bitmon functions. Based on OpenZeppelin.
 * @author eabz@polispay.org
 */
contract BitmonCore is BitmonBase, ERC721Enumerable, MinterRole, Seriality {

    address public randomContractAddr;

    function setRandomContractAddr(address _addr) external onlyMinter returns (bool) {
        randomContractAddr = _addr;
        return true;
    }

    function random() internal returns (uint8) {
        require(randomContractAddr != address(0), "contract address is not defined");
        (bool success, bytes memory data) = randomContractAddr.call(abi.encodeWithSignature("randomUint8()"));
        require(success, "contract call failed");
        uint8 randomN = bytesToUint8(1, data);
        while (randomN > 30) {
            randomN /= 2;
        }
        return randomN;
    }

    mapping (uint256 => uint256) bitmons;

    function mintBitmon(address _to, uint256 _bitmonId, uint8 _gender, uint8 _nature, uint8 _specimen, uint8 _variant) external onlyMinter returns (bool) {
        uint256 tokenId = totalSupply() + 1;
        _safeMint(_to, tokenId, "");
        bitmons[tokenId] = createGen0Bitmon(_bitmonId, _gender, _nature, _specimen, _variant);
        return true;
    }

    function bitmonData(uint256 tokenId) external view returns (uint256) {
        require(_exists(tokenId), "ERC721: Bitmon doesn't exists");
        return bitmons[tokenId];
    }

    // createGen0Bitmon is a function to create a Gen0 Bitmon.
    function createGen0Bitmon(uint256 _bitmonID, uint8 _gender, uint8 _nature, uint8 _specimen, uint8 _variant) internal returns (uint256) {
        Bitmon memory _bitmon = Bitmon({
            bitmonId: uint32(_bitmonID),
            fatherId: uint32(0),
            motherId: uint32(0),
            birthHeight: uint32(block.number),
            gender: _gender,
            nature: _nature,
            specimen: _specimen,
            variant: _variant,
            purity: 100,
            generation: 0,
            h: random(),
            a: random(),
            sa: random(),
            d: random(),
            sd: random()
            });
        return _serializeBitmon(_bitmon);
    }

    function _serializeBitmon(Bitmon memory bitmon) private pure returns (uint256) {
        bytes memory b = new bytes(32);
        uintToBytes(32, bitmon.bitmonId, b);
        uintToBytes(28, bitmon.fatherId, b);
        uintToBytes(24, bitmon.motherId, b);
        uintToBytes(20, bitmon.birthHeight, b);
        uintToBytes(16, bitmon.gender, b);
        uintToBytes(15, bitmon.nature, b);
        uintToBytes(14, bitmon.specimen, b);
        uintToBytes(13, bitmon.variant, b);
        uintToBytes(12, bitmon.purity, b);
        uintToBytes(11, bitmon.generation, b);
        uintToBytes(10, bitmon.h, b);
        uintToBytes(9, bitmon.a, b);
        uintToBytes(8, bitmon.sa, b);
        uintToBytes(7, bitmon.d, b);
        uintToBytes(6, bitmon.sd, b);
        return bytesToUint256(32, b);
    }

    // Experimental function, not for production.
    function deserializeBitmon(uint256 tokenID) external returns (Bitmon memory) {
        bytes memory b = new bytes(32);
        uint256 serialized = bitmons[tokenID];
        uintToBytes(32, serialized, b);
        Bitmon memory _bitmon;
        _bitmon.bitmonId = bytesToUint32(32, b);
        _bitmon.fatherId = bytesToUint32(28, b);
        _bitmon.motherId = bytesToUint32(24, b);
        _bitmon.birthHeight = bytesToUint32(20, b);
        _bitmon.gender = bytesToUint8(16, b);
        _bitmon.nature = bytesToUint8(15, b);
        _bitmon.specimen = bytesToUint8(14, b);
        _bitmon.variant = bytesToUint8(13, b);
        _bitmon.purity = bytesToUint8(12, b);
        _bitmon.generation = bytesToUint8(11, b);
        _bitmon.h = bytesToUint8(10, b);
        _bitmon.a = bytesToUint8(9, b);
        _bitmon.sa = bytesToUint8(8, b);
        _bitmon.d = bytesToUint8(7, b);
        _bitmon.sd = bytesToUint8(6, b);
        return _bitmon;
    }

}
