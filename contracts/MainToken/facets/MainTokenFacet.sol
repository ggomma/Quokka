// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {AppStorage} from "../libraries/LibAppStorage.sol";

contract MainTokenFacet {
    AppStorage internal s;

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function name() external pure returns (string memory) {
        return "Main";
    }

    function symbol() external pure returns (string memory) {
        return "Main";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return s.totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        balance = s.balances[_owner];
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        uint256 currentBalance = s.balances[msg.sender];
        require(
            currentBalance >= _value,
            "MAINToken: Not enough MAIN to transfer"
        );
        s.balances[msg.sender] = currentBalance - _value;
        s.balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    function addApprovedContract(address _contract) external {
        LibDiamond.enforceIsContractOwner();
        require(
            s.approvedContractIndexes[_contract] == 0,
            "MAINToken: Approved contract already exists"
        );
        s.approvedContracts.push(_contract);
        s.approvedContractIndexes[_contract] = s.approvedContracts.length;
    }

    function removeApprovedContract(address _contract) external {
        LibDiamond.enforceIsContractOwner();
        uint256 index = s.approvedContractIndexes[_contract];
        require(index > 0, "MAINToken: Approved contract does not exist");
        uint256 lastIndex = s.approvedContracts.length;
        if (index != lastIndex) {
            address lastContract = s.approvedContracts[lastIndex - 1];
            s.approvedContractIndexes[lastContract] = index;
        }
        s.approvedContracts.pop();
        delete s.approvedContractIndexes[_contract];
    }

    function approvedContracts()
        external
        view
        returns (address[] memory contracts_)
    {
        contracts_ = s.approvedContracts;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        uint256 fromBalance = s.balances[_from];

        if (msg.sender != _from || s.approvedContractIndexes[msg.sender] == 0) {
            uint256 l_allowance = s.allowances[_from][msg.sender];
            require(
                l_allowance >= _value,
                "MAINToken: Not allowed to transfer"
            );
            s.allowances[_from][msg.sender] = l_allowance - _value;
            emit Approval(_from, msg.sender, l_allowance - _value);
        }

        require(
            fromBalance >= _value,
            "MAINToken: Not enough MAIN to transfer"
        );
        s.balances[_from] = fromBalance - _value;
        s.balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        success = true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        s.allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
    }

    function increaseAllowance(address _spender, uint256 _value)
        external
        returns (bool success)
    {
        uint256 l_allowance = s.allowances[msg.sender][_spender];
        uint256 newAllowance = l_allowance + _value;
        require(
            newAllowance >= l_allowance,
            "MAINToken: Allowance increase overflowed"
        );
        s.allowances[msg.sender][_spender] = newAllowance;
        emit Approval(msg.sender, _spender, newAllowance);
        success = true;
    }

    function decreaseAllowance(address _spender, uint256 _value)
        external
        returns (bool success)
    {
        uint256 l_allowance = s.allowances[msg.sender][_spender];
        require(
            l_allowance >= _value,
            "MAINToken: Allowance decreased below 0"
        );
        l_allowance -= _value;
        s.allowances[msg.sender][_spender] = l_allowance;
        emit Approval(msg.sender, _spender, l_allowance);
        success = true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining_)
    {
        remaining_ = s.allowances[_owner][_spender];
    }

    function mint(address _to, uint256 _amount) public {
        LibDiamond.enforceIsContractOwner();
        s.balances[_to] += _amount;
        s.totalSupply += _amount;
        emit Transfer(address(0), _to, _amount);
    }
}
