// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract realEstate {
    // admin's address
    address immutable admin;

    // creating structure for the property
    struct property{
        uint id;
        string description;
        string location;
        uint price;
        address owner;
    }

    // mapping for the properties of the type property
    property[] public properties;

    // Caller of this contract will be the admin of this particular process
    constructor() {
        admin = msg.sender;
    }
    // modifiers to restrict access to the function execution by owner and admin
    modifier onlyOwner(uint propertyId){
        require(msg.sender == properties[propertyId].owner,"You are not the Owner!");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin,"You are not a authroized person");
        _;
    }
    // this are events to automate the property listing,updating,deleting and selling process
    event propertyListing(uint indexed id,string _description,string _location,uint _price,address _owner);
    event propertyUpdated(uint indexed id, string newDescription, string newLocation, uint newPrice, address _owner);
    event deleteProperty(uint indexed id);
    event sellProperty(uint indexed id, address previousOwner,address newOwner,uint price);

    // function for property listing by anyone
    function listProperty(string memory _description,string memory _location,uint _price) external {
        uint propertyId=properties.length;
        properties.push(property(propertyId,_description,_location,_price,msg.sender));
        emit propertyListing(propertyId, _description, _location, _price, msg.sender);
    }
    // function for property updating by owner
    function updateProperty(uint propertyId,string memory newDescription,string memory newLocation,uint newPrice) external onlyOwner(propertyId){
        property storage prop = properties[propertyId];
        prop.description = newDescription;
        prop.location = newLocation;
        prop.price = newPrice;
        emit propertyUpdated(propertyId,newDescription,newLocation,newPrice,msg.sender);
    }
    // function for property deleting by owner and admin
    function deletingProperty(uint propertyId) external onlyOwner(propertyId) onlyAdmin() {
        require(propertyId <= properties.length,"Property is not listed");
        emit deleteProperty(propertyId);
        delete properties[propertyId];
    }
    // function for buying the property
    function buyProperty(uint propertyId) external payable{
        property storage prop = properties[propertyId];
        require(prop.owner != address(0),"Property does not exist!");
        require(msg.value == prop.price,"Not enough price!");

        address previousOwner = prop.owner;
        prop.owner = msg.sender;

        payable(previousOwner).transfer(msg.value);
        emit sellProperty(propertyId, previousOwner, msg.sender, msg.value);
    }
 
}

