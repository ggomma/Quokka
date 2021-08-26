// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Avatar} from "./Avatar.sol";
import {MainToken} from "./MainToken.sol";
import {SystemVariables} from "./SystemVariables.sol";

// TODO: 721 Compatible
contract Factory {
    SystemVariables public systemVariables;
    MainToken public mainToken;
    address public feePool;

    mapping(uint256 => address) ownerOf; // Avatar owner
    mapping(uint256 => address) avatarOf; // Avatar address
    uint256 public totalSupply = 0;

    constructor(
        SystemVariables _systemVariables,
        MainToken _mainToken,
        address _feePool
    ) {
        mainToken = _mainToken;
        feePool = _feePool;
        systemVariables = _systemVariables;
    }

    function mint() public returns (address avatarAddress) {
        uint256 amount = systemVariables.immigrantFee();

        uint256 allowance = mainToken.allowance(msg.sender, address(this));
        require(allowance >= amount, "Token allowance is not enough");
        mainToken.transferFrom(msg.sender, feePool, amount);

        Avatar avatar = new Avatar(msg.sender);
        avatarAddress = address(avatar);

        totalSupply += 1;
        ownerOf[totalSupply] = msg.sender;
        avatarOf[totalSupply] = avatarAddress;
    }
}
