// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    // Entities - Manager, players and winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){
        manager=msg.sender;
        }

    function participate() public payable{
        require(msg.value == 1 ether , "Please pay only 1 ether.");
        players.push(payable(msg.sender));
       
    }

    function getBalance() public view returns (uint){
        require(manager == msg.sender, "You are not a manager");
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(blockhash(block.number - 1), players.length)));
    }

    function pickWinner() public{
        require(manager == msg.sender, "You are not the manager.");
        require(players.length >=3, "Players are less than 3");
        uint randomNum = random();
        uint index = randomNum%players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }
}