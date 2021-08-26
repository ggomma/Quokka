// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibEquipment {
    enum EquipmentFormat {
        ERC721,
        ERC1155
    }

    struct Equipment {
        address assetContract;
        uint256 tokenId;
        EquipmentFormat equipmentFormat;
    }
}
