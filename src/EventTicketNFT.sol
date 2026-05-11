// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

// Import the token contract
import {EventTicketERC20} from "../src/EventTicketERC20.sol";

// Import the necessary libraries from openzeppelin
import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC721URIStorage} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// 1. Mints NFT tickets to an event(e.g Web3 Night).
// 2. Each NFT represents one ticket.
// 3. Users pay a fee in ETH OR any customised ERC20 TOKEN to mint.
// 4. Each wallet is limited so one person can't buy out the whole event.
contract EventTicketNFT is ERC721URIStorage, Ownable {

   // This variable saves the contract addres of te payment token.
   address paymentToken;
   uint256 public ticketPrice = 4e18;
   // This variable is used to generate token ID
   uint256 public id;
   uint256 public max_ticket = 200;

   // This tracks the total number of tickets the user has.
   mapping(address user=> uint256 ticket) UserAmountOfTicketOwned;
   constructor(string memory _name, string memory _symbol, address _paymentToken)ERC721(_name, _symbol) Ownable(msg.sender) {
     paymentToken = _paymentToken;
   }

   function mintTicket(string memory URI) public {
      // Makes sure the maximum ticket number isn't crossed
      require(id < (max_ticket + 1), "Ticket all sold out!");

      // This limits the number of tickets a user can own.
      require(UserAmountOfTicketOwned[msg.sender] < 5, "Maximum ticket per wallet reached");
      
      // Makes sure the balance of the user is enough to purchase the ticket.
      require( IERC20(paymentToken).balanceOf(msg.sender) >= ticketPrice, "Insufficient token to purchase the ticket");
      
      // Transfer token in exchange for the ticket.
      bool successfulTransfer = IERC20(paymentToken).transferFrom(msg.sender, address(this), ticketPrice);
      require(successfulTransfer, "Transfer failed");

      // increase total sold ticket
      id++;

      // Increase the number of ticket the user owns
      UserAmountOfTicketOwned[msg.sender]++;
      _safeMint(msg.sender, id);
      _setTokenURI(id, URI);
   }

   function withdrawToken(uint256 amount) public onlyOwner {
      IERC20(paymentToken).transfer(msg.sender , amount);
   } 
}