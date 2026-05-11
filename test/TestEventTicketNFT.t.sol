// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {EventTicketNFT} from "../src/EventTicketNFT.sol";
import {EventTicketERC20} from "../src/EventTicketERC20.sol";

contract TestEventTicketNFT is Test {
   // Creating actors
   address Daniel = makeAddr("Daniel");
   address Bola = makeAddr("Bola");
   uint256 beforePayment;

   EventTicketNFT public deployedEventTicketNFT;
   EventTicketERC20 public deployedEventTicketERC20;

   function setUp() public {
      vm.startPrank(Daniel);
         deployedEventTicketERC20 = new EventTicketERC20("Web3 Night", "W3N");
         deployedEventTicketNFT = new EventTicketNFT("Web3 Night Ticket", "W3NT", address(deployedEventTicketERC20));
      vm.stopPrank();
   }

   // This function confirms if the mint function is working properly
   function testNFTMint() public {
      vm.startPrank(Daniel);
         deployedEventTicketERC20.transferToken(Daniel, 200e18);
         beforePayment = deployedEventTicketERC20.balanceOf(Daniel);
         deployedEventTicketERC20.approve(address(deployedEventTicketNFT), type(uint256).max);
         deployedEventTicketNFT.mintTicket("ipfs://bafkreifpnksepmuzunqpe2hmnssclie3deb2xdhe7evgip2elpyuqkffqe");
      vm.stopPrank();
   }

   // Confirm the owner of the NFT
   function testNFTOwner() public {
      testNFTMint();
      address NFTowner = deployedEventTicketNFT.ownerOf(deployedEventTicketNFT.id());
      assertEq(NFTowner, Daniel);
   }

   // Check the number of NFT the user has
   function testNFTAmount() public {
      testNFTMint();
      uint256 balance = deployedEventTicketNFT.balanceOf(Daniel);
      assertEq(balance, 1);
   }

   // Validate tokenURI
   function testTokenURI() public {
      testNFTMint();
      string memory uri = deployedEventTicketNFT.tokenURI(deployedEventTicketNFT.id());
      assertEq(uri, "ipfs://bafkreifpnksepmuzunqpe2hmnssclie3deb2xdhe7evgip2elpyuqkffqe");
   }

   // Confirm ticket payment addition from contract
   function testTicketPaymentContract() public{
      uint256 beforePayment = deployedEventTicketERC20.balanceOf(address(deployedEventTicketNFT));
      testNFTMint();
      
      uint256 afterPayment = deployedEventTicketERC20.balanceOf(address(deployedEventTicketNFT));
      assertEq(afterPayment, (beforePayment + deployedEventTicketNFT.ticketPrice()));
   }

   // Confirm ticket payment deduction from user
   function testTicketPaymentUser() public{
      testNFTMint();
      
      uint256 afterPayment = deployedEventTicketERC20.balanceOf(Daniel);
      assertEq(afterPayment, (beforePayment - deployedEventTicketNFT.ticketPrice()));
   }

   // Check mint limit. User should not be able to buy more than 5 tickets.
   function testTicketLimit() public {
      testNFTMint();
      testNFTMint();
      testNFTMint();
      testNFTMint();
      testNFTMint();
      // testNFTMint(); This throws an error
      uint256 balance = deployedEventTicketNFT.balanceOf(Daniel);
      assertEq(balance, 5); // Change the 5 to the number of times you want to mint the ticket
   }  
}