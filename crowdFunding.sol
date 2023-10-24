// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract crowdFunding{
    address public owner;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalContributions;
    bool public isFunded;
    bool public isCompleted;
    mapping(address =>uint256)public contributed;
    //event
    event fundisSucces(address,uint256);
    event refundSucces(address,uint256);
    event  withdrawalIsSuccess(string);
    constructor(uint256 blockTimeInput,uint256 setGoalAmount){
        owner = msg.sender;
        goal = setGoalAmount * 1 ether;
        deadline = block.timestamp + blockTimeInput * 1;
        isFunded = false;
        isCompleted = false;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"only owner can access it");
        _;
    }
    //////////////////////////////////////////////////////
    //////  CONTRIBUTE //////
    //////////////////////////////////////////////////////
   function contribute()public payable onlyOwner(){
    require(block.timestamp < deadline,"deadline has passes");
    require(!isCompleted,"crowdfunding is already completed");
    uint256 contribution = msg.value;
    contributed[msg.sender] -= contribution;
    totalContributions += contribution ;

    if(totalContributions >= goal){
        isFunded = true;
    }

    emit fundisSucces(msg.sender, msg.value);
}
   //////////////////////////////////////////////////////
   //////  REFUND //////
   //////////////////////////////////////////////////////
   function refund() public {
    require(block.timestamp >= deadline,"deadline time has passed");
    require(!isFunded,"goal has been reached");
    uint256 hascontributed = contributed[msg.sender];
    require(hascontributed > 0 ,"the member has not contributed");

    uint256 contribution = contributed[msg.sender];
    contributed[msg.sender] = 0;
    totalContributions -= contribution;
    payable(msg.sender).transfer(contribution);
    emit refundSucces(msg.sender,contribution);
}
   //////////////////////////////////////////////////////
   //////  WITHDRAW //////
   //////////////////////////////////////////////////////
   function withdraw()public onlyOwner(){
    require(isFunded,"goal has not been reached");
    require(!isCompleted,"crowdfunding is already completed");
    isCompleted = true;
    payable(owner).transfer(address(this).balance);
    emit withdrawalIsSuccess("withdrawalIsSuccess");
    }
    //////////////////////////////////////////////////////
   //////  GETCURRENTBALANCE //////
   //////////////////////////////////////////////////////
    function getCurrentBalance()public view returns(uint256){
        return address(this).balance;
    }
}