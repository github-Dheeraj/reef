//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./funder.sol";

contract funderFactory {
    uint256 public contractNumber = 1;
    struct deployedStruct {
        uint256 _depolymentCounter;
        address _deployedaddress;
        address _deployementOwner;
    }
    event newContractsCreated(
        uint256 _depolymentCounter,
        address _deployedaddress,
        address _deployementOwner
    );
    deployedStruct[] public deployedContracts;

    function createERC7211Upgrade(string memory _name, string memory _symbol, uint _maxSupply)
        public
    {
        funder testContract = new funder();
        testContract.initialize(_name, _symbol,_maxSupply);
        deployedStruct memory sampleContract;
        sampleContract._depolymentCounter = contractNumber;
        sampleContract._deployementOwner = msg.sender;
        sampleContract._deployedaddress = address(testContract);
        deployedContracts.push(sampleContract);

        emit newContractsCreated(
            sampleContract._depolymentCounter,
            sampleContract._deployedaddress,
            sampleContract._deployementOwner
        );
        contractNumber++;
    }

    function getDeployedContracts(uint256 index)
        public
        view
        returns (deployedStruct memory)
    {
        return deployedContracts[index];
    }
}
