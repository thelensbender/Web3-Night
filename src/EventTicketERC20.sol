// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract EventTicketERC20 is ERC20, Ownable {
   constructor (string memory _name, string memory _symbol) ERC20(_name, _symbol) Ownable(msg.sender) {
      // Mint a million units of token to the contract
      _mint(address(this), 1000000e18);
   }

   function mint(address to, uint256 amount) external onlyOwner {
      _mint(to, amount);
   }

   // Transfer token from contract to user. Only contract owner can call this.
   function transferToken(address _user, uint256 _amount) external onlyOwner() {
      _transfer(address(this), _user, _amount);
   }
}