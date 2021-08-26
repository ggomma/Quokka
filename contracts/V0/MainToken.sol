// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MainToken is ERC20 {
    constructor() ERC20("MAIN", "MAIN") {}

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
