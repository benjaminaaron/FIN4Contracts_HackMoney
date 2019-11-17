pragma solidity ^0.5.0;

import "contracts/proof/Fin4BaseProofType.sol";

contract MinimumInterval is Fin4BaseProofType {

  constructor(address Fin4MessagingAddress)
    Fin4BaseProofType(Fin4MessagingAddress)
    public {
      name = "MinimumInterval";
      description = "Defines a minimum time that has to pass between claims.";
      // minimumInterval = 1 * 24 * 60 * 60 * 1000; // 1 day
    }

    function submitProof_MinimumInterval(address tokenAddrToReceiveProof, uint claimId) public {
      if (minimumIntervalRequirementMet(tokenAddrToReceiveProof, msg.sender, claimId)) {
        _sendApproval(address(this), tokenAddrToReceiveProof, claimId);
      } else {
        string memory message = string(abi.encodePacked(
          Fin4TokenStub(tokenAddrToReceiveProof).name(),
          ": The time between your previous claim and this one is shorter than the minimum required timespan of ",
          uint2str(_getMinimumInterval(tokenAddrToReceiveProof) / 1000), "s."
        ));
        Fin4Messaging(Fin4MessagingAddress).addInfoMessage(address(this), msg.sender, message);
      }
    }

    function minimumIntervalRequirementMet(address tokenAddressUsingThisProofType, address claimer, uint claimId) private view returns(bool) {
      uint timeBetween = Fin4TokenStub(tokenAddressUsingThisProofType).getTimeBetweenThisClaimAndThatClaimersPreviousOne(claimer, claimId);
      return timeBetween >= _getMinimumInterval(tokenAddressUsingThisProofType);
    }

    // @Override
    function getParameterForTokenCreatorToSetEncoded() public pure returns(string memory) {
      return "uint:minimumInterval:days";
    }

    mapping (address => uint) public tokenToParameter;

    function setParameters(address token, uint minimumInterval) public {
      // TODO safeguard
      tokenToParameter[token] = minimumInterval;
    }

    // @Override
    function getParameterizedDescription(address token) public view returns(string memory) {
      return string(abi.encodePacked(
          "The token creator defined the minimum time that has to pass between claims as ",
          uint2str(_getMinimumInterval(token) / (1000 * 60 * 60 * 24)), " days."
        ));
    }

    function _getMinimumInterval(address token) private view returns(uint) {
      return tokenToParameter[token] * 24 * 60 * 60 * 1000; // from days to miliseconds
    }

}
