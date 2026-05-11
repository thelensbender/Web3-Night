// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {EventTicketERC20} from "../src/EventTicketERC20.sol";

contract TestEventTicketERC20 is Test {
   // Creating actors
   address Daniel = makeAddr("Daniel");
   address Bola = makeAddr("Bola");

   EventTicketERC20 public deployedEventTicketERC20;

   function setUp() public {
      vm.startPrank(Daniel);
         deployedEventTicketERC20 = new EventTicketERC20("Web3 Night", "W3N");
      vm.stopPrank();
   }

   // This function confirms the token balance of the deployedEventTicketERC20 contract is 1000000e18
   function testTokenContractBalance() public {
      vm.startPrank(Daniel);
         assertEq(deployedEventTicketERC20.balanceOf(address(deployedEventTicketERC20)), 1000000e18);
      vm.stopPrank();
   }


   // This function tests the transferToken function in deployedEventTicketERC20 contract
   function testtransferToken() public {
      vm.startPrank(Daniel);
         deployedEventTicketERC20.transferToken(Bola, 10e18);
         assertEq(deployedEventTicketERC20.balanceOf(Bola), 10e18);
         assertEq(deployedEventTicketERC20.balanceOf(address(deployedEventTicketERC20)), 999990e18);
      vm.stopPrank();
   }

   // Try to call with another actor to be sure that its only owner that can call. It gives an error which proves that only owner can call.
// function testtransferTokenOnlyOwner() public {
//    vm.startPrank(Bola);
//       deployedEventTicketERC20.transferToken(Bola, 10e18);
//       assertEq(deployedEventTicketERC20.balanceOf(Bola), 10e18);
//       console.log("Only user can call this function!");
//    vm.stopPrank();
// }
} 