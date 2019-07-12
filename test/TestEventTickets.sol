pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EventTickets.sol";
import "./Proxy.sol";

contract TestEventTickets {
  string _description = 'book';
  string _url = 'website';
  uint _totalTickets = 10;

  // address buyer = 0xCdABc2bcb262A2aaDdD01de1f7710C6E2F50AC12;

  EventTickets public eventTickets;
  Proxy public ticketsBuyer;

  event ConsoleLog(bytes);

  function() external payable {}

  function beforeEach() public
  {
    // Contract to test
    eventTickets = new EventTickets(_description, _url, _totalTickets);
    ticketsBuyer = new Proxy(eventTickets);
    (bool success, bytes memory ticketsBought) = ticketsBuyer.buyTickets(5);
    emit ConsoleLog(ticketsBought);
    Assert.isTrue(success, "Buyer should have bought 5 tickets");
  }

  function testReadEvent() public  {
    (string memory description, string memory url, uint totalTickets, uint sales, bool isOpen) = eventTickets.readEvent();
    Assert.isTrue(keccak256(abi.encodePacked(description)) == keccak256(abi.encodePacked(_description)), "event not initialized properly");
    Assert.isTrue(keccak256(abi.encodePacked(url)) == keccak256(abi.encodePacked(_url)), "event not initialized properly");
    Assert.isTrue(totalTickets == _totalTickets, "event not initialized properly");
    Assert.isTrue(sales == 0, "event not initialized properly");
    Assert.isTrue(isOpen == true, "event not initialized properly");
  }

  function testGetBuyerTicketCount() public {
    uint afterBuyTickets = eventTickets.getBuyerTicketCount(address(ticketsBuyer));
    Assert.isTrue(afterBuyTickets == 5, "Buyer should have bought 5 tickets");
  }


}