# Alyra Test Voting Projct 2

## Unit tests contract Voting


## Context :
- These are my first tests in javascript, learning this programming language in parallel with my training at Alyra. Also, I think that the next time, I will split my tests by categories, or in several files, to make reading easier and above all to better organize things.

- Due to lack of time, I decided to test some require and event in the whole code.

## Exercise goal :
Since the last release, you have seen the CI/CD part with testing and deployment. 
You must then provide the unit tests of your smart contract. We do not expect 100% coverage of the smart contract but be sure to test the different possibilities of returns (event, revert).

1 file: votingTests.js

### 1) Tests Expect Revert

- I checked that adding a voter by someone other than the owner triggers a revert
- I checked that the modification of the status for the opening and closing of Proposal Registration by a person other than the owner, triggers a revert
- I checked that the modification of the status for the opening and closing of Voting Sessiob    by a person other than the owner, triggers a revert
- I checked that after registering voter, we have a expect revert when i try to add him again
- I added a test on the case of a vote with an unregistered proposal


### 2) Tests Expect 

- I tested the "expects" by data checks concerning the registration of a voter
- We check that the voter is not already registered for this, the expectation must return a false
- Once the voter has been added by the owner only, we relaunch the previous test which must be passed to true

### 3) Tests Expect Event

- Once the voter is added, we need to have the voter's status changed to "voterRegistered" as shown in the events.
- We modify the status of the workflow to check that the event goes up well
- I added a test that allows to retrieve the event when a proposal is recorded
- I have a test concerning the recovery of the "Voted" event when a participant votes