// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "./Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {EquipmentRegistry} from "./EquipmentRegistry.sol";
import {LibEquipment} from "./LibEquipment.sol";

contract Avatar is Ownable {
    address public immigrantCenter;
    EquipmentRegistry public equipmentRegistry;

    /**
        Equipment
     */
    mapping(bytes4 => LibEquipment.Equipment) equipped;

    /**
        Inventory
     */
    mapping(address => mapping(uint256 => bool)) erc721Inventory;
    mapping(address => uint256) erc20Inventory;

    constructor(
        address _immigrantCenter,
        EquipmentRegistry _equipmentRegistry,
        address _owner
    ) Ownable(_owner) {
        immigrantCenter = _immigrantCenter;
        equipmentRegistry = _equipmentRegistry;
    }

    modifier onlyImmigrantCenter() {
        require(
            msg.sender == immigrantCenter,
            "Only immigrant center contract can call this"
        );
        _;
    }

    function transferOwnership(address newOwner)
        public
        override
        onlyImmigrantCenter
    {
        super.transferOwnership(newOwner);
    }

    function get721Asset(
        address _assetContract,
        address _from,
        uint256 _tokenId
    ) public {
        ERC721(_assetContract).transferFrom(_from, address(this), _tokenId);
        erc721Inventory[_assetContract][_tokenId] = true;
    }

    function transfer721Asset(
        address _assetContract,
        address _to,
        uint256 _tokenId
    ) public onlyOwner {
        drop721Asset(_assetContract, _tokenId);

        ERC721(_assetContract).transferFrom(address(this), _to, _tokenId);
    }

    function drop721Asset(address _assetContract, uint256 _tokenId) internal {
        require(erc721Inventory[_assetContract][_tokenId], "No asset");

        bytes4 assetType = equipmentRegistry.equipmentType(_assetContract);
        unEquip(assetType);

        delete erc721Inventory[_assetContract][_tokenId];
    }

    function equip(
        bytes4 _type,
        address _assetContract,
        uint256 _tokenId
    ) public {
        require(
            erc721Inventory[_assetContract][_tokenId],
            "You do not own asset"
        );

        bool isRegistered = equipmentRegistry.isRegistered(
            _type,
            _assetContract
        );
        require(isRegistered, "Not registered");

        Equipment memory equipment = Equipment({
            assetContract: _assetContract,
            tokenId: _tokenId,
            equipmentFormat: LibEquipment.EquipmentFormat.ERC721
        });
        equipped[_type] = equipment;
    }

    function unEquip(bytes4 _type) public {
        delete equipped[_type];
    }
}
