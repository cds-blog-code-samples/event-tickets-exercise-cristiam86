pragma solidity >= 0.5.0 < 0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EventTickets.sol";
import "./Proxy.sol";

contract TestEventTickets {
  // 1. Seed the Main test contract
  uint public initialBalance = 1 ether;

  string _description = 'book';
  string _url = 'website';
  uint _totalTickets = 10;

  EventTickets public eventTickets;
  Proxy public ticketBuyer;

  function() external payable {}

  function beforeEach() public
  {
    // Contract to test
    eventTickets = new EventTickets(_description, _url, _totalTickets);
    ticketBuyer = new Proxy(eventTickets);

    // 2. Fund the ticketBuyer
    address(ticketBuyer).transfer(500 wei);

    // 3. Tell ticketBuyer to purchase tickets (with price)
    (bool success, uint ticketsBought) = ticketBuyer.buyTickets(5, 500 wei);

    // 4. assert no revert
    Assert.isTrue(success, "Transaction should not have reverted");

    // 5. assert expected number of tickets brought is the return value.
    Assert.equal(ticketsBought, 5, "Buyer should have purchased 5 tickets");
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
    uint afterBuyTickets = eventTickets.getBuyerTicketCount(address(ticketBuyer));
    Assert.isTrue(afterBuyTickets == 5, "Buyer should have bought 5 tickets");
  }


}
