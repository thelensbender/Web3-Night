// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;


import {Script} from "../lib/forge-std/src/Script.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {EventTicketNFT} from "../src/EventTicketNFT.sol";
import {EventTicketERC20} from "../src/EventTicketERC20.sol";


contract DeployEventTicketNFT is Script {
   EventTicketERC20 public eventTicketERC20;
   EventTicketNFT public eventTicketNFT;

   address deployer;

   string public NFTJSON = "ipfs://bafkreifpnksepmuzunqpe2hmnssclie3deb2xdhe7evgip2elpyuqkffqe";

   function run() public {
      deployer = msg.sender;
      vm.startBroadcast();
      // Deploy token contract
      eventTicketERC20 = new EventTicketERC20("Web3 Night", "W3N");
      console.log("The payment token contract address is: ", address(eventTicketERC20));

      // Transfer token to my address
      eventTicketERC20.mint( deployer, 100e18 );

      // Deploy NFT contract
      eventTicketNFT = new EventTicketNFT("Web3 Night Ticket", "W3NT", address(eventTicketERC20));
      eventTicketERC20.approve(address(eventTicketNFT), eventTicketNFT.ticketPrice());
      console.log("The NFT contract address is: ", address(eventTicketNFT));
   
      eventTicketNFT.mintTicket(NFTJSON);
      vm.stopBroadcast();
   }
}