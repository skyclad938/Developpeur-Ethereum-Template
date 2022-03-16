pragma solidity 0.8.12;
contract Whitelist {
mapping (address => bool) Whitelist;

}

pragma solidity 0.8.12;
 
contract Ballot {
   struct Voter { // Structure de données
       uint weight;
       bool voted;
       address delegate;
       uint vote;
   }
}
