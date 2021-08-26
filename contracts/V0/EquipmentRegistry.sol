// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibEquipment} from "./LibEquipment.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract EquipmentRegistry is Ownable {
    mapping(bytes4 => address[]) public registeredEquipments;
    mapping(address => bytes4) public equipmentType;
    mapping(address => uint256) public equipmentIndex;

    function isRegistered(address _assetContract) public view returns (bool) {
        bytes4 eqType = equipmentType[_assetContract];
        return (eqType != bytes4(0x0));
    }

    function registerEquipment(bytes4 _type, address _assetContract)
        public
        onlyOwner
    {
        require(
            equipmentType[_assetContract] == bytes4(0x0),
            "Already registered"
        );

        equipmentType[_assetContract] = _type;
        uint256 totalEquipments = registeredEquipments[_type].length;
        equipmentIndex[_assetContract] = totalEquipments;
        registeredEquipments[_type].push(_assetContract);
    }

    function deregisterEquipment(address _assetContract) public onlyOwner {
        bytes4 eqType = equipmentType[_assetContract];
        require(eqType != bytes4(0x0), "Unregistered equipment");

        uint256 index = equipmentIndex[_assetContract];
        uint256 lastEquipmentIndex = registeredEquipments[eqType].length - 1;
        if (index != lastEquipmentIndex) {
            address lastEquipment = registeredEquipments[eqType][
                lastEquipmentIndex
            ];
            registeredEquipments[eqType][index] = lastEquipment;
            equipmentIndex[lastEquipment] = index;
            registeredEquipments[eqType][lastEquipmentIndex] = _assetContract;
        }
        registeredEquipments[eqType].pop();
        delete equipmentIndex[_assetContract];
    }
}
