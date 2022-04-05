const Voting = artifacts.require("./voting.sol");
const { BN, expectRevert, expectEvent } = require('@openzeppelin/test-helpers');
const { assertion } = require('@openzeppelin/test-helpers/src/expectRevert');
const { expect } = require('chai');


// We firts check that our smart contract can be deployed correctly
contract("Test Voting", function () {
  it('should deploy the smart contract voting correctly', async ()=> {
    const votingDeploy = await Voting.deployed();
    console.log(Voting.adress);
    assertion(Voting.adress !== "" && Voting.adress !== undefined);
  });

contract('Voting', accounts => {
    const owner = accounts[0];
    const voter1 = accounts[1];
    const Voter2 = accounts[2];
  
    let VotingInstance;

// We check unitary test with function addVoter and WorkflowStatus

    describe("addVoter steps + Test Require + Event", function () {
        beforeEach(async function () {
            VotingInstance = await Voting.new({from:owner});
          }); 

// we check that only owner can add voter 
          it("should owner only to add voter", async () => {
            await (expectRevert(VotingInstance.addVoter(voter1, false ,{ from: Voter2 }), "Ownable: caller is not the owner"));
          });
// We check that Voter is not already registered
          it("should voter not already registered", async () => {
            const Newvoter =  await VotingInstance.voters(voter1);
            expect(Newvoter.isRegistered).to.equal(false);
          });
// We add voter to the list
          const record = await VotingInstance.addVoter(voter1 ,{ from: owner });
        });
// We check that Status registered is well recovered
        expectEvent(record, "VoterRegistered", { voterAddress : voter1});
      });
// We check that Voter is now registered
          it("should voter be now registered", async () => {
            const voterRecorded =  await VotingInstance.voters(voter1);
            expect(voterRecorded.isRegistered).to.equal(true);
          });
// we  checked that after registering voter, we have a expect revert when we try to add him again
          it("should be already registered", async () => {
            await (expectRevert(VotingInstance.addVoter(voter1, false ,{ from: owner }), 'Already registered'));
          });

    describe("Workflow status + Test Require with ExpectRevert", function () {
        beforeEach(async function () {
            VotingInstance = await Voting.new({from:owner});
          }); 
// we check that only owner can modify workflow status to open Proposal
          it("should owner only to add voter", async () => {
            await (expectRevert(VotingInstance.startProposalsRegistering({ from: Voter2 }), "Ownable: caller is not the owner"));
          });
// we check that only owner can modify workflow status to close proposal
          it("should owner only to add voter", async () => {
            await (expectRevert(VotingInstance.endProposalsRegistering({ from: Voter2 }), "Ownable: caller is not the owner"));
          });
// we check that only owner can modify workflow status to open voting session
          it("should owner only to add voter", async () => {
            await (expectRevert(VotingInstance.startVotingSession({ from: Voter2 }), "Ownable: caller is not the owner"));
          });
// we check that only owner can modify workflow status to close voting session
          it("should owner only to add voter", async () => {
          await (expectRevert(VotingInstance.endVotingSession({ from: Voter2 }), "Ownable: caller is not the owner"));
          });


      describe("scenarii Tests : Get Event /Require", function () {
          beforeEach(async function () {
              VotingInstance = await Voting.new({from:owner});
            }); 
// We modify the status of the workflow to check that the event goes up well
          it("should owner starts Proposal Registration", async () => {
            const status = await VotingInstance.startProposalsRegistering({owner});
            const newstatus = new BN(1);
            const currentWorkflowStatus = await VotingInstance.workflowStatus.call();
            expect(currentWorkflowStatus).to.be.bignumber.equal(newstatus);
            expectEvent(status,'WorkflowStatusChange', {previousStatus: '0', newStatus: '1'});
          });
// we check that we get event ProposalRegistered
          it('should add proposal, get event ProposalRegistered', async()=> {
            const findEvent = await VotingInstance.addProposal( "Test1", {from:voter1});
            expectEvent(findEvent, 'ProposalRegistered', {_id: new BN(0),}); 
          });
          it('should add proposal, get event ProposalRegistered', async()=> {
            const findEvent = await VotingInstance.addProposal( "Test2", {from:Voter2});
            expectEvent(findEvent, 'ProposalRegistered', {_id: new BN(1),}); 
          });
// We check that we can't vote to non existing proposal
          it('should not vote with non existing proposal', async() => {
            await (expectRevert.unspecified(VotingInstance.setVote(3, {from: voter1})));
          });
          it('should vote, get event Voted', async()=> {
            const findEvent = await VotingInstance.setVote( 0, {from:voter1});
            expectEvent(findEvent, 'Voted', {_addr :voter1, _id:new BN(0),}); 
          });
    });
   
  });
});