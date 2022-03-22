// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/access/Ownable.sol";

contract Voting is Ownable {
    // Structure that defines the characteristics of a voter
    struct Voter {
        bool isRegistered; // Registered  Yes/No
        bool hasVoted; // has voted Yes/No
        uint votedProposalId; // ID Voter
    }

    struct Proposal {
        string description;
        uint voteCount;
    }
    // Enums restrict a variable to have one of only a few predefined values, we have all steps of voting process.
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied 
    }

    uint winningProposalId; 
    mapping (address => Voter) voters; // Allows to associate address type with the Voters type in a "voters" hash table
    mapping (address => uint) votes; // Allows to associate address type with the uint type in a "votes" hash table

    Proposal[] public proposals; // Array dynamic to record n proposals 

    WorkflowStatus currentStatus = WorkflowStatus.RegisteringVoters; // Initialisation to first WorkflowStatus

    // Event to communicate with client application that something has happened on the Blockchain
    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

 // MODIFIER // Use to add a prerequisite to a function

    modifier registeredOnWhitelisted(address _address) { // we verify that voter is registered on whitelist
        require(voters[_address].isRegistered, "You are not whitelisted"); 
        _;
    }
    modifier notRegisteredOnWhitelisted(address _address) { // we verify that voter is not already on whitelist
        require(!voters[_address].isRegistered, "You are already whitelisted");
        _;
    }
    modifier workflowStatus(WorkflowStatus status) { // We verifiy that status is correct 
        require(currentStatus == status, "Error workflow status");
        _; 
    }
    modifier notHaveAlreadyVote(address _address) { // we verify that voter not have already voted 
        require(! voters[_address].hasVoted, "You have already voted");
        _;
    }

    // Fonctions //

// function to add voter on whitelist with control status and admin only
    function addAddressToWhitelist(address _address) public notRegisteredOnWhitelisted(_address) workflowStatus(WorkflowStatus.RegisteringVoters) onlyOwner {
        voters[_address].isRegistered = true;
    }
//  We open the possibility to save the proposals of the people registered on the white list and check the status
    function openProposalRegistration() public onlyOwner workflowStatus(WorkflowStatus.RegisteringVoters) {
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted); // trigger the event WorkflowStatusChange
       currentStatus = WorkflowStatus.ProposalsRegistrationStarted;
    }
//  We close the possibility to save the proposals of the people registered on the white list and check the status
    function closeProposalRegistration() public onlyOwner workflowStatus(WorkflowStatus.ProposalsRegistrationStarted) { 
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded); // trigger the event WorkflowStatusChange
        currentStatus = WorkflowStatus.ProposalsRegistrationEnded;
    }
//  We open the possibility to vote to people registered on the white list and check the status
    function openVotingSession() public onlyOwner workflowStatus(WorkflowStatus.ProposalsRegistrationEnded) {
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted); // trigger the event WorkflowStatusChange
        currentStatus = WorkflowStatus.VotingSessionStarted;
    }
//  We close the possibility to vote to people registered on the white list and check the status
    function closeVotingSession() public onlyOwner workflowStatus(WorkflowStatus.VotingSessionStarted) {
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded); // trigger the event WorkflowStatusChange
        currentStatus = WorkflowStatus.VotingSessionEnded;
    }
//  we count the votes
    function countVotes() public onlyOwner workflowStatus(WorkflowStatus.VotingSessionEnded) {
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied); // trigger the event WorkflowStatusChange
         currentStatus = WorkflowStatus.VotesTallied;
//  we launch a For loop which will allow us to count the votes by initializing uint i to 0 and adding 1 each time as long as the count is less than the number of proposals
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }
//  function that pushes a proposal into the Proposal table if the voter is on the whitelist and the proposal registration status is started
    function proposal(string memory _description) public registeredOnWhitelisted(msg.sender) workflowStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        proposals.push(Proposal(_description, 0)); 
    }
//  Allows you to vote by verifying that he is on the whitelist, has not already voted and that the registration status of the votes has started
    function vote(uint _proposalId) public registeredOnWhitelisted(msg.sender) notHaveAlreadyVote(msg.sender) workflowStatus(WorkflowStatus.VotingSessionStarted) { 
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;       
        emit Voted(msg.sender, _proposalId); // Trigger the event voted
    }
//  Allows to obtain the result by checking the status with counted votes and returning a uint , here the WinningProposolID
    function getWinner() public view workflowStatus(WorkflowStatus.VotesTallied) returns (uint) {
        return winningProposalId;
    }
}