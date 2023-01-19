// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Escrow {

    //this enum stores the current state of the transcation
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE} // declare a custom data type

    // variable to hold the State
    State public currentState;

    //buyer address
    address public buyer;

    //seller address
    address payable public seller;

    // Ensure that only the buyer can call functions the modifier is attached to
    modifier onlyBuyer() {
        require(msg.sender==buyer, "Only the buyer can call this function!");
        _;
    }

    //Set up the buyer and seller addresses
    constructor(address _buyer, address payable _seller) {
        buyer = _buyer;
        seller = _seller;
    }

    // only the Buyer can call this function to deposit Ether to the contract
    function deposit() onlyBuyer external payable {
        require(currentState==State.AWAITING_PAYMENT, "Buyer has already deposited Ether to the contract");
        currentState = State.AWAITING_DELIVERY;
    } 

    // the buyer calls this function to confirm that they have received the item for sale
    function comfirmDelivery() onlyBuyer external {
        require(currentState==State.AWAITING_DELIVERY, "Delivery has not been confirmed!");
        seller.transfer(address(this).balance);
        currentState = State.COMPLETE;
        currentState = State.AWAITING_PAYMENT;
    } 

    // function returnToState() public {
    //     require(currentState==State.COMPLETE, "Delivery has been confirmed!");
    //     currentState = State.AWAITING_PAYMENT;
    // }

}