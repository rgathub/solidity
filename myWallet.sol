// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract myWallet {

        address owner; 
        mapping(address => uint) public dependents; 
        uint public funds;

        constructor()
        {
            owner = msg.sender;
            funds = 0;
        }

        modifier onlyOwner {
        
            require(msg.sender == owner, "You are not allowed");
            _;
        }

        modifier isDependentOrOwner {
            require(dependents[msg.sender] > 0 || msg.sender == owner, "You are not allowed");
            _;
        }

        function addDependent(address dependent, uint allowableExpense) public onlyOwner {
            dependents[dependent] = allowableExpense;
        } 

        receive() external payable
        {
            addMoney();
        }

        function addMoney() public payable {
            funds += msg.value;
        }

        function withdrawMoney(uint _amount) public isDependentOrOwner{
            require(funds > _amount,"Not enough funds");
            if(!(msg.sender == owner))
            {
                require(dependents[msg.sender] > _amount, "Not enough money in allowance");
                dependents[msg.sender] -= _amount;
            }
            funds -= _amount;
            address payable to = payable(msg.sender);
            to.transfer(_amount);
        } 

        function updateAllowance(address dependent, uint allowableExpense) public onlyOwner {
                dependents[dependent] = allowableExpense;
        }


}