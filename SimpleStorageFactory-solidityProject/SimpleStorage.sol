// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18; // states solidity version



contract SimpleStorage{

    // Basic Types: boolean, uint, int, address, bytes

    uint256 MyfavoriteNumber; //intialize with 0 if value is not assigned

   

    //uint256[] listofFavouriteNumbers;

    struct Person{

        uint256 favoriteNumber;

        string name;

    }

    // dynamic array if nothing mentioned in []

    Person[] public ListofPeople;

    // Person public pat = Person({favoriteNumber: 10, name:"Pat"});

    mapping(string=>uint256) public nameToFavoriteNumber;



    function store(uint256 _favouriteNumber) public{

        MyfavoriteNumber = _favouriteNumber;

    }

    // visibility : public, private, external, internal



    //getter function

    // view - read state cant accept update, pure - disallow reading also only return specific.

    function retrieve() public view returns (uint256){

        return MyfavoriteNumber;

    }


    //(calldata- cant modified, memory - modifible)-temp vars, storage - permenant variable (any variable outside of function in smart contract is storage variable)

    function addPerson(string  memory _name, uint256 _favoriteNumber) public{

        ListofPeople.push(Person(_favoriteNumber, _name));

        nameToFavoriteNumber[_name] = _favoriteNumber;

    }


}