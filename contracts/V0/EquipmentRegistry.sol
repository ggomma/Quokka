// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EquipmentRegistry {
    enum EquipmentFormat {
        ERC721,
        ERC1155
    }

    mapping(bytes4 => mapping(address => bool)) public registeredEquipments;
    mapping(address => bytes4) public equipmentType;
    mapping(address => EquipmentFormat) public equipmentFormat;

    function isRegistered(bytes4 _type, address _assetAddress)
        public
        view
        returns (bool)
    {
        return registeredEquipments[_type][_assetAddress];
    }
}
