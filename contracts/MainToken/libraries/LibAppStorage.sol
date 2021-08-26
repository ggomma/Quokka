// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct AppStorage {
    mapping(address => mapping(address => uint256)) allowances;
    mapping(address => uint256) balances;
    address[] approvedContracts;
    mapping(address => uint256) approvedContractIndexes;
    address contractOwner;
    uint256 totalSupply;
    bytes32[1000] emptyMapSlots;
}
