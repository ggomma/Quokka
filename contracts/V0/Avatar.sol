// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "./Ownable.sol";

contract Avatar is Ownable {
    address immigrantCenter;

    constructor(address _immigrantCenter, address _owner) Ownable(_owner) {
        immigrantCenter = _immigrantCenter;
    }
}
