// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "./Ownable.sol";

contract Avatar is Ownable {
    address immigrantCenter;

    constructor(address _immigrantCenter, address _owner) Ownable(_owner) {
        immigrantCenter = _immigrantCenter;
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
}
