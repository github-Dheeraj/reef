// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

contract funder is Initializable, ContextUpgradeable, ERC721Upgradeable {

    uint public currentNumber = 1;
    uint public minValue;
    uint public maxSupply;
    string private baseURI;
    uint public proposalNumber;
    address public _owner;
    event newFundsRecieved(
        address funderAddress,
        uint amount,
        uint tokenId
    );
    struct addressAndVote{
        address proposer;
        bool decision;
    }
    mapping(uint => addressAndVote[]) votingMap;
    mapping(address => uint) public addressToTokenId;
    modifier onlyOwner{
        require(msg.sender == _owner, "only Owner can call this function");
        _;
    }
      function initialize(string memory _name, string memory _symbol, uint _maxSupply)
        public
        initializer
    {
        maxSupply = _maxSupply;
        _owner = payable(tx.origin);
        __ERC721_init(_name, _symbol);
    }
    
    function safeMintInternal(address to) internal returns(uint){
        require(balanceOf(msg.sender) < 1,"already minted");
        _safeMint(to, currentNumber);
        currentNumber++;
        return currentNumber -1;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "Non Existent Token");
        string memory currentBaseURI = _baseURI();

        return (
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        "1.json"
                    )
                )
                : ""
        );
    }

    function createVotingProposal(bool _value) public onlyOwner{
        addressAndVote memory currentVote;
        currentVote.proposer = msg.sender;
        currentVote.decision = _value;
        votingMap[proposalNumber].push(currentVote);
        proposalNumber++;
    }

    function voteForProposal(uint _proposalNumber, bool _desicion) public {
        require(balanceOf(msg.sender) == 1,"You are not part of the crowdfunding");
        addressAndVote[] memory totalVotes = votingMap[_proposalNumber];
        bool isVoted = checkIfAlreadyVoted(totalVotes, msg.sender);
        require(isVoted == true, "you have already voted");
        addressAndVote memory currentVote;
        currentVote.proposer = msg.sender;
        currentVote.decision = _desicion;
        votingMap[proposalNumber].push(currentVote);
    }

    function checkIfAlreadyVoted(addressAndVote[] memory _arrayOfStruct, address checkAddress) internal pure returns(bool){

        bool check = false;
        for(uint i = 0; i < _arrayOfStruct.length; i++){
            if(_arrayOfStruct[i].proposer == checkAddress){
                check = true;
            }
        }
        return check;
    }

    
    function fundThisProject() payable public {
        require(msg.value >= 0 ether,"Minimum value to stake is 0.003 reef");
        uint tokenId = safeMintInternal(msg.sender);
        addressToTokenId[msg.sender] = tokenId;
        emit newFundsRecieved(
            msg.sender,
            msg.value,
            tokenId
        );
    }

    function transferTokenRight(address payable _to) external {
        require(balanceOf(msg.sender) == 1,"");
        uint tokenId = addressToTokenId[msg.sender];
        safeTransferFrom(msg.sender, _to,tokenId);
    }
    
    function withdraw() payable external onlyOwner{
        (bool status, ) = (msg.sender).call{value: address(this).balance}("");
        require(status == true,"payable should be true");
            
    }
    function changeMaxSupply(uint64 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }
    fallback() external payable {
        // custom function code
    }

    receive() external payable {
        // custom function code
    }
}

