// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TicketingSystem{
    struct Ticket{
        uint256 id;
        address seller;
        string eventName;
        uint256 price;
        bool available;
    }

    uint256 public ticketCount;
    mapping(uint256 => Ticket) public tickets;
    event TicketCreated(uint256 id, address seller, string eventName, uint256 price);
    event TicketPurchased(uint256 id, address buyer, string eventName, uint256 price);

    function createTicket(string memory _eventName, uint256 _price) public {
        require(bytes(_eventName).length > 0 , "Event name cannot be empty");
        require(_price > 0, "Ticket price must be greater than zero");

        ticketCount ++;

        tickets[ticketCount] = Ticket({
            id:ticketCount,
            seller:msg.sender,
            eventName:_eventName,
            price: _price,
            available: true
        });

        emit TicketCreated(ticketCount, msg.sender, _eventName, _price);
    }

    function PurchaseTicket(uint256 _id) public payable {
        require(_id > 0 && _id <= ticketCount, "Invalid ticket ID");

        Ticket storage ticket = tickets[_id];

        require(ticket.available, "Ticket not available");
        require(msg.value == ticket.price, "Not a valid amount for buying the ticket");

        ticket.available = false;

        emit TicketPurchased(_id, msg.sender, ticket.eventName, ticket.price);
    }

    function getTicket(uint256 _id) public view returns (
        uint256 id,
        address seller,
        string memory eventName,
        uint256 price,
        bool available
    ){
        require(_id > 0 && _id <= ticketCount, "Invalid Ticket ID");
        Ticket storage ticket = tickets[_id];

        return(
            ticket.id,
            ticket.seller,
            ticket.eventName,
            ticket.price,
            ticket.available
        );
    }


}