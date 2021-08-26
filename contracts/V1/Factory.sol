// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Avatar} from "./Avatar.sol";

contract Factory {
    mapping(uint256 => address) ownerOf; // Avatar owner
    mapping(uint256 => address) avatarOf; // Avatar address
    uint256 public totalSupply = 0;

    function mint() public returns (address avatarAddress) {
        Avatar avatar = new Avatar(msg.sender);
        avatarAddress = address(avatar);

        totalSupply += 1;
        ownerOf[totalSupply] = msg.sender;
        avatarOf[totalSupply] = avatarAddress;
    }
}
