// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PaymentContract {
    address public payer;
    address public payee;
    uint public amount;

    constructor (address _payee, uint _amount){
        payer = msg.sender;
        payee = _payee;
        amount = _amount;
    } 

    function makePayment() public payable {
        require(msg.sender == payer, "Only the payer can make a payment!");
        require(address(this).balance >= amount, "Insufficient contract balance!");

        (bool success, ) = payee.call{value : amount}("");
        require(success, "Payment Failed");




    }
}