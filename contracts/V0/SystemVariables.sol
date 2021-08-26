// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SystemVariables {
    uint256 public immigrantFee;

    function setImmigrantFee(uint256 _immigrantFee) public {
        immigrantFee = _immigrantFee;
    }
}
