// SPDX-License-Identifier:MIT
pragma solidity ^0.8.11;
contract BallotV1 { 
   uint deployDate;
 enum Phase {Init, Regs, Vote, Done}
 Phase  state = Phase.Init;
 modifier validPhase(Phase reqPhase)
 {   
    require(state == reqPhase,"wrong phase !");

 _;
 }
    uint CandidateA = 0; 
    uint CandidateB = 0; 
    uint BlankVotes = 0; 
    uint NullVotes = 0; 
    uint NumberCandidateA = 1; 
    uint NumberCandidateB = 2; 
    uint NumberBlankVotes = 3; 
    address BallotBoxAdress; 

 bool canstartvoting = false;
mapping(address => uint) vari_people;
mapping(address => uint) vari_voted;
mapping(uint => bool) time;
    constructor()  { 
        BallotBoxAdress = msg.sender;
         state = Phase.Regs; 
          deployDate =block.timestamp;
           
    } 
     bool Registertime;
     bool votertime;
     
  function InsertElectorID(uint _ElectorID, address _adress) public verification1 validPhase(Phase.Regs) {
           Registertime=(block.timestamp >= (deployDate + 1 minutes));
           if(Registertime==true)
           {
              revert("timeout") ;
              }
              if( _adress==  BallotBoxAdress ){revert("Responsible cant vot!!");}
           vari_people[_adress]= _ElectorID;
         vari_voted[_adress]= 0;

    
    }
  
 function changeState(Phase x) public verification1{
  bool timeer=(block.timestamp >= (deployDate + 1 minutes));
  bool timeer2=(block.timestamp >= (deployDate + 2 minutes));
  if(timeer2!=true && x==Phase.Done) {
  revert("not Result time");
  }
  if(timeer!=true && x==Phase.Vote) {
  revert("not voting time");
  }
 state = x;
 if(state==Phase.Vote){
     canstartvoting =  true;}
    
 }

    function ToVote(uint voto, address peopleoadress, uint IDd) public verification1  validPhase(Phase.Vote){
         if(  vari_people[peopleoadress]!=IDd ){revert("this isnt registered!");}
        if(  vari_voted[peopleoadress]!= 0){revert("you cant vote again!!");}
            votertime=(block.timestamp >= (deployDate+ 2 minutes));
           if( votertime==true)
           {
              revert("timeout") ;
           
           }
            if(voto == NumberCandidateA){
                   vari_voted[peopleoadress]= 1;
                CandidateA++; 
            }
            else if(voto == NumberCandidateB){
                   vari_voted[peopleoadress]= 1;
                CandidateB++; 
            }
            else if(voto == NumberBlankVotes){
                   vari_voted[peopleoadress]= 1;
                BlankVotes++; 
            }
            else{
                   vari_voted[peopleoadress]= 1;
                NullVotes++;
            }
        
          
    }

 function Results() public view verification1() validPhase(Phase.Done) returns( uint _CandidateA, uint _CandidateB, uint _BlankVotes, uint _NullVotes){ 
        return( 
                CandidateA,
                CandidateB,
                BlankVotes,
                NullVotes);
        
    }
 modifier verification1(){
        require(msg.sender == BallotBoxAdress,"wrong address !");
        _;
    }
 }