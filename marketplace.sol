// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract marketPlace {
    struct Product {
        uint id;
        string name;
        uint price;
        address payable seller;
        bool isSold;
    }

    uint public ProductCount;
    mapping(uint => Product) public products;

    event ProductCreated(uint id, string name, uint price, address seller);
    event ProductSold(uint id, string name, uint price, address seller, address buyer);

    function createProduct(string memory _name, uint _price) public {
        ProductCount ++;

        products[ProductCount] = Product(ProductCount, _name, _price, payable(msg.sender), false);

        emit ProductCreated(ProductCount, _name, _price, payable(msg.sender));
    }

    function buyProduct(uint _id) public payable{
        Product storage product = products[_id];

        require(product.id > 0 && product.id <= ProductCount, "Invalid Product ID");
        require(!product.isSold, "Product Already Sold!");
        require(msg.value >= product.price, "Insufficient funds");

        product.isSold = true;
        product.seller.transfer(product.price);

        emit ProductSold(product.id, product.name, product.price, payable(product.seller), payable(msg.sender));
    }
}